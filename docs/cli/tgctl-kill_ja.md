# tgctl kill

## NAME

`tgctl kill` - Tsurugi データベースの強制停止

## SYNOPSIS

```sh
tgctl kill [OPTIONS]
```

## DESCRIPTION

`tgctl kill` は、Tsurugi データベースを強制的に完全に終了させるコマンドです。

Tsurugi データベースの起動中やシャットダウンの最中にエラーが発生した場合などに、Tsurugi データベースが開始も終了もできなくなる場合があります。
このような場合、`tgctl kill` コマンドを使用して完全に終了させることで、`tgctl start` コマンドで起動できるようになる場合があります。

## EXAMPLES

```sh
tgctl kill
```

## OPTIONS

このコマンドは以下のオプションをサポートします:

* `--conf </path/to/tsurugi.ini>` : 構成定義ファイルのパス
  * 操作対象の Tsurugi インスタンスの構成定義ファイル (`tsurugi.ini`) を指定します
  * 未指定の場合は [デフォルトの構成定義ファイル](./tgctl_ja.md#構成定義ファイル) を使用します
* `--timeout <seconds>` : タイムアウト時間 (秒)
  * データベースプロセスの終了を確認するまでの時間を指定します
  * `0` を指定すると、データベースプロセスが終了するまで制御を返しません
  * 未指定の場合、デフォルトで `10` 秒が設定されます

## NOTES

* 本コマンドは、Tsurugi インスタンスが稼働中、または未稼働の状態で利用可能です
  * Tsurugi インスタンスが未稼働の場合、このコマンドは何も行いません
* 本コマンドは対象のデータベースがどのような状態であっても完全に終了させます
  * 強制停止はデータの整合性に影響を与える可能性があるため、通常は [`tgctl shutdown`](./tgctl-shutdown_ja.md)コマンドの利用を推奨します
* 本コマンドは、内部的には Linux プロセスの強制終了 (`SIGKILL` の送信) を行います

## EXIT STATUS

* `0` : 正常にデータベースを強制停止した
* その他 : エラー等によりTsurugi データベースを強制停止できなかった

## SEE ALSO

* [`tgctl start`](./tgctl-start_ja.md)
* [`tgctl shutdown`](./tgctl-shutdown_ja.md)
