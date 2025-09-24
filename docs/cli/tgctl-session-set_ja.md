# tgctl session set

## NAME

`tgctl session set` - Tsurugi データベースの特定のセッション変数の値を変更

## SYNOPSIS

```sh
tgctl session set <session-ref> <key> [<value>] [OPTIONS]
```

## DESCRIPTION

`tgctl session set` コマンドは、指定したセッションIDまたはラベルに対応する Tsurugi データベースセッションの変数（スイッチ等）を変更します。

<!-- NOTE: currently, no session variables are generally available, only sql.plan_recording is available for Altimeter.
## EXAMPLES

```sh
tgctl session set example-1 timeout 600
tgctl session set 1234567890abcdef isolation_level SERIALIZABLE
```
-->

## OPTIONS

このコマンドは以下のオプションをサポートします。

* `<session-ref>` ： セッション参照
  * 対象セッションのセッションIDまたはセッションラベルを指定します
  * 未指定の場合、エラーとなります
* `<key>` ： セッション変数名
  * 操作対象のセッション変数名を指定します
  * 未指定の場合、エラーとなります
* `<value>` ： セッション変数値
  * 操作対象のセッション変数に設定する値を指定します
  * 未指定の場合、対象のセッション変数のデフォルト値にリセットします

上記のほかに、 `tgctl` コマンドの[共通オプション](./tgctl_ja.md#common-options) も利用できます。

## NOTES

* 本コマンドは、Tsurugi インスタンスが稼働中の状態で利用可能です
* セッション ID は、セッション作成時に Tsurugi データベースによって自動的に割り当てられ、コロン (`:`) から始まります
* セッションラベルは、セッション作成時にユーザが任意に指定でき、コロン (`:`) から始められません
* 指定したセッションが現在の権限で参照可能でない場合はエラーになります
* セッションをセッションラベルで指定する場合、そのセッションラベルに対応するセッションが複数存在しているとエラーになります
* セッション変数名は大文字小文字の区別がありません

## EXIT STATUS

* `0` - 指定したセッション変数を変更した
* その他 - エラー等により指定したセッション変数を変更できなかった

## SEE ALSO

* [tgctl session list](./tgctl-session-list_ja.md)
* [tgctl session show](./tgctl-session-show_ja.md)