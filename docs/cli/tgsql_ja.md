# tgsql

## NAME

`tgsql` - Tsurugi SQLコンソール

## SYNOPSIS

```sh
tgsql [OPTIONS]
```

## DESCRIPTION

`tgsql` コマンドは、Tsurugi データベースに対してSQLを実行するためのコンソールです。

このコマンドを利用してTsurugiサーバーへのセッションを確立し、対話的にSQL文を入力・実行できます。  
また、SQL文の一括実行やスクリプトファイルの実行にも対応しています。

## EXAMPLES

```sh
tgsql -c ipc:tsurugi
tgsql --exec -c tcp://localhost:12345 "SELECT * FROM test"
tgsql --script -c tcp://localhost:12345 /path/to/script.sql
```

## OPTIONS

主なオプション例：

- `--help` : ヘルプを表示します。
- `--version` : tgsqlのバージョンを表示します。

### 実行モード

- `--console` : コンソールモード（対話モード・REPLモード）でtgsqlを起動します。
  - 対話的にSQL文を入力・実行していくモードです。
- `--exec` : SQL実行モードでtgsqlを起動します。
  - 単一のSQL文を実行するモードです。
  - 追加オプションでSQL文を指定します。
- `--script` : SQLスクリプトモードでtgsqlを起動します。
  - SQLスクリプト（SQL文を複数書いたファイル）を実行するモードです。
  - 追加オプションでスクリプトファイルのパスを指定します。

実行モードのオプションを省略した場合はコンソールモードになります。

### DB接続

* `-c, --connection <connection-uri>` : 接続先TsurugiサーバーのURI
  * 例: `ipc:tsurugi`, `tcp://localhost:12345`
* `--connection-label <label>` : セッションラベル

### 認証

 `tgctl` コマンドと同様の [認証オプション](./tgctl_ja.md#認証オプション) (`--user`, `--auth-token`, `--credentials`, `--no-auth`) を利用できます。

コンソールモードでは、認証に失敗した場合はTsurugiサーバーに接続していない状態で起動します。  
（ `\connect` コマンドでTsurugiサーバーに接続することができます）

### 暗黙のトランザクション

tgsqlでは、トランザクションを明示的に開始せずにSQL文を実行すると、以下のオプションに従って自動的にトランザクションが開始されます。

- `-t, --transaction <transaction type>` : トランザクション種別
  - `OCC` （デフォルト）
  - `LTX`
  - `RTX`
  - `manual` : トランザクションを自動で開始しません。（明示的にstart/begin文を実行する必要があります）
- `--label <label>` : トランザクションラベル
- `--include-ddl` : DDLをLTXで実行する場合に指定します。
- `-w, --write-preserve <table>[,...]` : LTXで更新するテーブル
- `--read-area-include <table>[,...]` : LTXで参照するテーブル
- `--read-area-exclude <table>[,...]` : LTXで参照しないテーブル

### 暗黙のコミット

処理終了時に自動的にコミットするかどうかを指定します。

- `--auto-commit` : SQL文をひとつ実行する度にコミットします。（コンソールモードのデフォルト）
- `--no-auto-commit` : 自動的にはコミットしません。（明示的にcommit文を実行する必要があります）
- `--commit` : 処理全体が成功した場合にコミットします。（SQL実行モード・SQLスクリプトモードのデフォルト）
- `--no-commit` : 処理全体が終了したときにロールバックします。
- `--commit-option <commit option>` : 自動的にコミットする際のコミットオプションです。Tsurugiサーバー内でどこまで処理したらtgsqlに制御が戻るか（どういう状態になるまで待つか）を指定します。
  - `DEFAULT` - Tsurugiサーバー側の設定に従います。（コミットオプションを指定しない場合のデフォルト）
  - `ACCEPTED` - コミット操作が受け付けられるまで待ちます。
  - `AVAILABLE` - コミットデータが他トランザクションから見えるようになるまで待ちます。
  - `STORED` - コミットデータがTsurugiサーバーのローカルディスクに書かれるまで待ちます。
  - `PROPAGATED` - コミットデータが適切な全てのノードに伝播されるまで待ちます。

### SQLスクリプトモード用

- `-e, --encoding <charset>` : スクリプトファイルの文字コード（デフォルト: UTF-8）

### クライアント変数

- `-D<key>=<value>` : クライアント変数を設定します。
- `--client-variable <file>` : クライアント変数の設定値が書かれたファイルを読み込みます。

クライアント変数については [tgsql client variable](https://github.com/project-tsurugi/tanzawa/blob/master/modules/tgsql/docs/client-variable_ja.md) を参照してください。

----

詳細なオプションは `tgsql --help` で確認できます。

## NOTES

* 接続プロトコル（IPC/TCP）や認証方式は環境・設定に依存します。
* コマンドの詳細や使い方は [tgsql README](https://github.com/project-tsurugi/tanzawa/blob/master/modules/tgsql/README.md) も参照してください。

## EXIT STATUS

* `0` - SQLの実行に成功
* その他 - エラー終了

## SEE ALSO

* [tgdump](./tgdump_ja.md)
