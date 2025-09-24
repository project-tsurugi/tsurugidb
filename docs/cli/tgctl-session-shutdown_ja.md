# tgctl session shutdown

## NAME

`tgctl session shutdown` - Tsurugi データベースの特定のセッションを終了させる

## SYNOPSIS

```sh
tgctl session shutdown <session-ref> [OPTIONS]
```

## DESCRIPTION

`tgctl session shutdown` コマンドは、指定した Tsurugi データベースセッションの終了を要求します。

## EXAMPLES

```sh
tgctl session shutdown example-1
tgctl session shutdown 1234567890abcdef
```

## OPTIONS

このコマンドは主に以下のオプションをサポートします。

* `<session-ref>` ： セッション参照
  * 対象セッションのセッションIDまたはセッションラベルを指定します
  * 未指定の場合、エラーになります
* `--forceful`
  * このオプションを指定すると、対象のセッションの新しいリクエストを閉塞し、稼働中のリクエストを速やかに終了させたのちに、セッションを終了させます (forceful シャットダウン)
  * デフォルトの挙動であり、未指定の場合も同様に forceful シャットダウンを行います
* `--graceful`
  * このオプションを指定すると、対象のセッションの新しいリクエストを閉塞し、稼働中のリクエストの自然な終了を待ったのちに、セッションを終了させます (graceful シャットダウン)
  * 未指定の場合、 forceful シャットダウンを行います

上記のほかに、 `tgctl` コマンドの[共通オプション](./tgctl_ja.md#common-options) も利用できます。

## NOTES

* 本コマンドは、Tsurugi インスタンスが稼働中の状態で利用可能です
* 本コマンドは、セッションの安全な終了を行います
  * 稼働中のリクエストをすべて終了させたのちに、セッションを終了させます
  * オプションの `--forceful` または `--graceful` の指定に応じて、それぞれリクエストの終了方法が異なります
  * 現在、セッションを強制終了させる方法は提供していません
* セッション ID は、セッション作成時に Tsurugi データベースによって自動的に割り当てられ、コロン (`:`) から始まります
* セッションラベルは、セッション作成時にユーザが任意に指定でき、コロン (`:`) から始められません
* 指定したセッションが現在の権限で参照可能でない場合はエラーになります
* `--forceful` と `--graceful` の両方を指定するとエラーになります

## EXIT STATUS

* `0` - 対象のセッションに終了要求を出せた
* その他 - エラー等により指定したTsurugi データベースセッションに終了要求を出せなかった

## SEE ALSO

* [tgctl session list](./tgctl-session-list_ja.md)
* [tgctl session show](./tgctl-session-show_ja.md)
* [tgctl session set](./tgctl-session-set_ja.md)
