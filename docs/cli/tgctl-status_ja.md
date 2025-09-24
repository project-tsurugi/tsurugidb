# tgctl status

## NAME

`tgctl status` - Tsurugi データベースの状態確認

## SYNOPSIS

```sh
tgctl status [OPTIONS]
```

## DESCRIPTION

`tgctl status` コマンドは、Tsurugi データベースインスタンスの現在の状態を表示します。
稼働状況、起動・停止状態を確認するために利用します。

## EXAMPLES

```sh
tgctl status
```

## OPTIONS

このコマンドは以下のオプションをサポートします

* `--conf </path/to/tsurugi.ini>` : 構成定義ファイルのパス
  * 操作対象の Tsurugi インスタンスの構成定義ファイル (`tsurugi.ini`) を指定します
  * 未指定の場合は [デフォルトの構成定義ファイル](./tgctl_ja.md#構成定義ファイル) を使用します

## NOTES

* 本コマンドは、Tsurugi インスタンスが稼働中・停止中いずれの状態でも利用可能です
  * 対象のTsurugi データベースが未稼働の場合、このコマンドはその旨を表示します
    * 'Tsurugi OLTP database is INACTIVE' ： Tsurugi データベースは未稼働
  * 対象のTsurugi データベースが稼働中の場合、コマンドはその状態を表示します
    * 'Tsurugi OLTP database is BOOTING_UP' ： Tsurugi データベースは起動中
    * 'Tsurugi OLTP database is RUNNING' ： Tsurugi データベースは稼働中
    * 'Tsurugi OLTP database is SHUTTING_DOWN' ： Tsurugi データベースはshutdown中
* 状態情報の取得に失敗した場合、エラー終了することがあります

## EXIT STATUS

* `0` : 状態情報の取得に成功
* その他 : エラー等によりTsurugi データベースの状態を取得できなかった

## SEE ALSO

* [`tgctl start`](./tgctl-start_ja.md)
* [`tgctl shutdown`](./tgctl-shutdown_ja.md)
* [`tgctl kill`](./tgctl-kill_ja.md)
