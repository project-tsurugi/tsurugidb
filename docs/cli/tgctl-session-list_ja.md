# tgctl session list

## NAME

`tgctl session list` - Tsurugi データベースのアクティブセッション一覧表示

## SYNOPSIS

```sh
tgctl session list [OPTIONS]
```

## DESCRIPTION

`tgctl session list` コマンドは、現在アクティブな Tsurugi データベースセッションの一覧を表示します。

## EXAMPLES

```sh
tgctl session list
```

## OPTIONS

このコマンドは以下のオプションをサポートします。

* `--id`
  * このオプションを指定するとセッションラベルの代わりに常にセッションIDを出力します
  * 未指定の場合、セッションラベルを優先して表示します
* `--verbose`
  * 各セッションの詳細な情報を表示します
  * このオプションを指定した場合、 `--id` の指定は無視されます
  * 未指定の場合、セッションラベルまたはセッションIDのみを表示します

上記のほかに、 `tgctl` コマンドの[共通オプション](./tgctl_ja.md#common-options) も利用できます。

## NOTES

* 本コマンドは、Tsurugi インスタンスが稼働中の状態で利用可能です
* 当該コマンド（`tgctl session list`）を実行しているセッションは表示に含まれません
* 本コマンドの出力は以下の通りです
  * `--verbose` の指定がない場合
    * 稼働中のセッション一覧のセッションラベルを空白文字区切りで出力します
    * ただし、以下のいずれかの場合にはセッションIDを表示します
      * セッションラベルが未定義または取得できなかった場合
      * 複数のセッションでセッションラベルが重複している場合
      * セッションラベルに区切り文字である空白文字が含まれる場合
  * `--verbose` の指定がある場合
    * 各セッションの以下の内容をテーブル形式で出力します

      列 | 内容 | 備考
      ------|------|------
      `id` | セッションID | 先頭に `:` が付与されている数値
      `label` | セッションラベル | 不明の場合は空文字列
      `application` | アプリケーション名 | 不明の場合は空文字列
      `user` | ログインユーザ名 | 不明の場合は空文字列
      `start` | セッション開始時刻 | ISO 8601 形式のローカルタイム
      `type` | 接続種類 | `ipc`, `tcp` などのエンドポイント URI スキーマ名
      `remote` | 接続元情報 | `ipc` の場合はPID, `tcp` の場合はリモートアドレス

* 表示されるセッションは、現在の権限で参照可能なもののみです
  * システム管理権限を持つユーザーであれば、すべてのセッションを表示します
  * 一般ユーザーであれば、当該ユーザーが所有するセッションのみを表示します

## EXIT STATUS

* `0` - セッション一覧の取得に成功した
* その他 : エラー等によりTsurugi データベースセッションの一覧を取得できなかった

## SEE ALSO

* [tgctl session show](./tgctl-session-show_ja.md)
* [tgctl session shutdown](./tgctl-session-shutdown_ja.md)
* [tgctl session set](./tgctl-session-set_ja.md)