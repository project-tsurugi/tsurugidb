# tgdump

## NAME

`tgdump` - Tsurugi データベースダンプツール

## SYNOPSIS

```sh
tgdump <table-name> [<table-name> ...] [OPTIONS]
tgdump --sql <query-text> [<query-text> ...] [OPTIONS]
```

## DESCRIPTION

`tgdump` コマンドは、Tsurugi データベースのテーブルの内容をダンプ（エクスポート）するためのツールです。

このコマンドを利用して、指定したテーブルのデータをファイルへ出力できます。
ダンプ形式や出力先、対象テーブルの指定、SQL 文の直接指定など、柔軟なオプションを利用可能です。

## EXAMPLES

```sh
# Export the tables "t1" and "t2" to /tmp/dump/{t1, t2}
tgdump t1 t2 --to /tmp/dump --connection ipc:tsurugi

# Export the query results to /tmp/sql/{a, b}
tgdump --sql "a: SELECT * FROM t1 WHERE k = 0" "b: SELECT * FROM t2 WHERE k = 1" --to /tmp/sql --connection ipc:tsurugi

# Export the table "t1" to /tmp/single without sub-directories
tgdump --single t1 --to /tmp/single --connection ipc:tsurugi

# Export the table "t1" to /tmp/arrow/t1 as Arrow format
tgdump t1 --profile arrow --to /tmp/arrow --connection ipc:tsurugi
```

## OPTIONS

主なオプション例：

* `<table-name>` または `<query-text>` : テーブル名または SQL 文（必須）
  * ダンプ出力対象のテーブル名を指定します (複数指定可)
  * オプション `--sql` を指定した場合、ここにはテーブル名の代わりに SQL 文（またはラベル付き SQL 文）を指定します
  * このパラメータは、`--sql` オプションの有無によってテーブル名 (`<table-name>`) または SQL 文 (`<query-text>`) として解釈されます
* `--sql`
  * テーブル名 (`<table-name>`) に指定した文字列を、代わりに SQL 文 (`<query-text>`) として処理します
  * `<query-label>: <query-text>` の形式で SQL 文に対してオプションのクエリラベルを指定可能です (例: `label: SELECT * FROM t1`)
  * クエリラベルを指定しない場合、自動的にラベル付けを行います (例: `sql1`, `sql2`, ...)
* `--to <directory>` : 出力先ディレクトリ (必須)
  * ダンプデータの出力先ディレクトリを指定します
  * 空または未作成のディレクトリのみ指定できます
  * 指定したディレクトリ内にテーブル名やクエリラベルのサブディレクトリを作成します
* `--single`
  * テーブル名またはSQL文の指定を 1 つだけに制限します
  * このオプションを指定した場合、 `--to` で指定したディレクトリ配下にサブディレクトリを作成せず、直接ダンプデータを保存します
* `--connection <endpoint-uri>` : Tsurugi のエンドポイント URI (必須)
  * 接続先の Tsurugi エンドポイント URI を指定します
  * `ipc:` プロトコルのみ利用可能です (例: `ipc:tsurugi`)
* `--profile <profile>` : ダンププロファイル名
  * ダンプ出力するデータのデータ形式を指定します
  * 以下のプロファイル名を利用可能です (大文字小文字の区別なし)
    * `Arrow` - Apache Arrow 形式でダンプ
    * `Parquet` - Apache Parquet 形式でダンプ
    * `PG-Strom` - PG-Strom 拡張を利用したダンプ
    * `default` - デフォルトのダンプ設定 (Apache Parquet 形式)
  * 未指定の場合、 `default` のプロファイルを使用して出力します
* `--transaction <transaction-type>` : トランザクションの種類
  * ダンプ実行時に利用するトランザクションの種類を指定します
  * 以下のトランザクションタイプを利用可能です (大文字小文字の区別なし)
    * `RTX`
    * `OCC`
    * `LTX`
  * 未指定の場合、 `RTX` のトランザクションタイプを使用します
* `--verbose`
  * 詳細なメッセージを表示します
* `--help`
  * ヘルプを表示します

上記のほかに、 `tgctl` コマンドと同様の[認証オプション](./tgctl_ja.md#認証オプション) (`--user`, `--auth-token`, `--credentials`, `--no-auth`) も利用できます。
また、未指定の場合は `tgctl` と同様に標準の認証情報の探索を行います。

詳細なオプションは `tgdump --help` や、[GitHub 上](https://github.com/project-tsurugi/tanzawa/blob/master/modules/tgdump/README.md) で確認できます。

## NOTES

* 複数のテーブルやクエリを指定した場合、必ず同一のトランザクション内でダンプ処理を実行します
  * 複数回に分けてコマンドを実行した場合、テーブル間のデータの整合性が保証されない場合があります
* デフォルトの `--transaction` の `RTX` では、最新のデータよりも少しだけ古いデータを読み出す場合があります
  * `OCC` や `LTX` を指定することで常に最新のデータを取得できますが、他のトランザクションとの競合が発生する可能性があります
* エラー時の挙動など、より詳細な情報は [デザインドキュメント](https://github.com/project-tsurugi/tanzawa/blob/master/docs/tgdump-design_ja.md) を参照してください

## EXIT STATUS

* `0` - ダンプ処理が正常に完了した
* その他 - エラーによりダンプ処理が失敗した

## SEE ALSO

* [tgsql](./tgsql_ja.md)
