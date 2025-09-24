# tgctl backup create

## NAME

`tgctl backup create` - Tsurugi データベースのバックアップ作成

## SYNOPSIS

```sh
tgctl backup create <backup-directory> [OPTIONS]
```

## DESCRIPTION

`tgctl backup create` コマンドは、Tsurugi データベースの現在の状態をバックアップとして保存します。
`<backup-directory>` として指定したディレクトリにバックアップデータ一式を出力します。
バックアップはオンラインで取得可能です。

## EXAMPLES

```sh
tgctl backup create /var/backup/tsurugi
```

## OPTIONS

このコマンドは以下のオプションをサポートします:

* `<backup-directory>` ： バックアップディレクトリ
  * バックアップデータ一式を出力するディレクトリ
  * 出力先のディレクトリは、コマンド実行前にあらかじめ作成しておく必要があります
  * 未指定の場合、エラーとなります
* `--label`
  * バックアップの操作にラベルを指定します
  * 未指定の場合、ラベルは設定されません
* `--verbose`
  * この操作に関する詳細情報を表示します
  * 未指定の場合、詳細情報は表示されません

上記のほかに、 `tgctl` コマンドの[共通オプション](./tgctl_ja.md#common-options) も利用できます。

<!--
- `--overwrite`は未実装
-->

## NOTES

* 本コマンドは、Tsurugi インスタンスが稼働中、または未稼働の状態で利用可能です
  * Tsurugi インスタンスが未稼働の場合は、[静止状態](./tgctl-quiesce_ja.md)で起動してバックアップを行い、その後、Tsurugi インスタンスを停止させます
  * インスタンスの起動中やシャットダウン中などにおいて、コマンドがエラー終了する場合があります
* バックアップ取得後は、[`tgctl restore backup`](./tgctl-restore-backup_ja.md) コマンドでリストア可能です
* 本コマンドの実行にはシステム管理者権限が必要です

## EXIT STATUS

* `0` : 正常にTsurugi データベースのバックアップを作成した
* その他 : エラー等によりTsurugi データベースのバックアップを作成できなかった

## SEE ALSO

* [`tgctl restore backup`](./tgctl-restore-backup_ja.md)
* [`tgctl quiesce`](./tgctl-quiesce_ja.md)