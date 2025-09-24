# tgctl restore backup

## NAME

`tgctl restore backup` - Tsurugi データベースのバックアップからリストア

## SYNOPSIS

```sh
tgctl restore backup <backup-directory> [OPTIONS]
```

## DESCRIPTION

`tgctl restore backup` コマンドは、 [backup create サブコマンド](./tgctl-backup-create_ja.md) 等で作成したバックアップを利用し、バックアップ作成時点の状態にデータベースをリストアします。

## EXAMPLES

```sh
tgctl restore backup /var/backup/tsurugi
```

## OPTIONS

このコマンドは以下のオプションをサポートします:

* `<backup-directory>` ： バックアップディレクトリ
  * Tsurugi データベースをリストアするバックアップデータ一式が格納されているディレクトリを指定します
  * 未指定の場合、エラーとなります
* `--label <label-string>` ： この操作のラベル
  * この操作に関するラベルを指定します
  * 未指定の場合、ラベルは付与されません
* `--force`
  * 確認プロンプトを表示せず、自動的にリストア処理を実行します
  * 未指定の場合、リストア処理の開始前に確認のプロンプトが表示されます
* `--no-keep-backup`
  * リストアに成功した場合、 `<backup-directory>` に指定したバックアップを自動的に削除します
  * 未指定の場合、バックアップは削除されずにそのまま残ります
* `--use-file-list </path/to/file-list>` ：  バックアップ対象ファイルのリスト
  * バックアップ対象のファイルを、JSON 形式のリストファイルで指定します
  * このオプションを指定した場合、 `<backup-directory>` に指定したバックアップのうち、リストファイルによって指定されたファイルのみを利用してリストアします
  * このオプションを指定した場合、 `--no-keep-backup` オプションは無視されます
  * 未指定の場合、 `<backup-directory>` に含まれるすべてのバックアップファイルを利用してリストアします

上記のほかに、 `tgctl` コマンドの [共通オプション](./tgctl_ja.md#common-options) も利用できます。

## NOTES

* 本コマンドは、Tsurugi インスタンスが停止中の状態で利用することが必須です
* リストア完了後は、データベースは自動的に終了します
  * リストア完了後にデータベースを起動する場合は、 [`tgctl start` サブコマンド](./tgctl-start_ja.md) を利用してください
* 本コマンドの実行にはシステム管理者権限が必要です

## EXIT STATUS

* `0` : Tsurugi データベースのバックアップからリストアした
* その他 : エラー等によりTsurugi データベースのバックアップからリストアできなかった

## SEE ALSO

* [`tgctl backup create`](./tgctl-backup-create_ja.md)
* [`tgctl start`](./tgctl-start_ja.md)
