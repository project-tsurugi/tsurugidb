# tgctl session show

## NAME

`tgctl session show` - Tsurugi データベースのセッション情報表示

## SYNOPSIS

```sh
tgctl session show <session-ref> [OPTIONS]
```

## DESCRIPTION

`tgctl session show` コマンドは、指定した Tsurugi データベースセッションの詳細情報を表示します。

## EXAMPLES

```sh
tgctl session show example-1
tgctl session show :1234567890
```

## OPTIONS

このコマンドは以下のオプションをサポートします。

* `<session-ref>` ： セッション参照
  * 対象セッションのセッションIDまたはセッションラベルを指定します
  * 未指定の場合、エラーになります

上記のほかに、 `tgctl` コマンドの[共通オプション](./tgctl_ja.md#common-options) も利用できます。

## NOTES

* 本コマンドは、Tsurugi インスタンスが稼働中の状態で利用可能です
* セッション ID は、セッション作成時に Tsurugi データベースによって自動的に割り当てられ、コロン (`:`) から始まります
* セッションラベルは、セッション作成時にユーザが任意に指定でき、コロン (`:`) から始められません
* 指定したセッションが現在の権限で参照可能でない場合はエラーになります
* 本コマンドの出力は以下の通りです

  ラベル | 内容 | 備考
  ------|------|------
  `id` | セッションID | 先頭に `:` が付与されている数値
  `application` | アプリケーション名 | 不明の場合は空文字列
  `label` | セッションラベル | 不明の場合は空文字列
  `user` | ログインユーザ名 | 不明の場合は空文字列
  `start` | セッション開始時刻 | ISO 8601 形式のローカルタイム
  `type` | 接続種類 | `ipc`, `tcp` などのエンドポイント URI スキーマ名
  `remote` | 接続元情報 | `ipc`の場合はPID, `tcp`の場合はリモートアドレス

## EXIT STATUS

* `0` - 指定したTsurugi データベースセッションの詳細情報取得に成功した
* その他 : エラー等により指定したTsurugi データベースセッションの詳細情報を取得できなかった

## SEE ALSO

* [tgctl session list](./tgctl-session-list_ja.md)
* [tgctl session shutdown](./tgctl-session-shutdown_ja.md)
* [tgctl session set](./tgctl-session-set_ja.md)