# tgctl credentials

## NAME

`tgctl credentials` - 資格情報ファイルの作成

## SYNOPSIS

```sh
tgctl credentials [</path/to/credentials.key>] [OPTIONS]
```

## DESCRIPTION

`tgctl credentials` コマンドは、Tsurugi データベースへの接続に利用可能な資格情報ファイルを作成します。

## EXAMPLES

```sh
# create a default credentials file using username and password prompt
tgctl credentials

# creates or replaces a credentials file onto /tmp/creds.key using password prompt
tgctl credentials /tmp/creds.key --overwrite --user example
```

## OPTIONS

このコマンドは以下のオプションをサポートします。

* `</path/to/credentials.key>` : 保存先パス
  * 作成する資格情報ファイルのパスを指定します
  * 未指定の場合、 `~/.tsurugidb/credentials.key` に保存されます
* `--user <username>` : 接続に使用するユーザー名
  * プロンプトでパスワードを入力し、オプション引数のユーザー名と組み合わせて認証を試みます
  * 未指定の場合、プロンプトでユーザー名とパスワードの入力が求められます
* `--overwrite`
  * 資格情報の作成先に既存のファイルが存在する場合、上書きします
  * 未指定の場合、既存ファイルがあるとエラーになります
* `--no-overwrite`
  * 資格情報ファイルの作成先に既存のファイルが存在する場合、ファイルを出力せずエラー終了します
  * デフォルトの挙動であり、未指定の場合でも同様の挙動をします
* `--expiration <days>` : 有効期限 (日数)
  * 作成する資格情報ファイルの有効期限を日数で指定します
  * `0` を指定した場合、無期限の資格情報ファイルを作成します
  * 指定可能な最大値は 365 日です
  * 未指定の場合、デフォルトで 30 日に設定されます
* `--conf </path/to/tsurugi.ini>` : 構成定義ファイルのパス
  * 操作対象の Tsurugi インスタンスの構成定義ファイル (`tsurugi.ini`) を指定します
  * 未指定の場合は [デフォルトの構成定義ファイル](./tgctl_ja.md#構成定義ファイル) を使用します

## NOTES

* `tgctl credentials` サブコマンドでは、`tgctl` コマンドの[共通オプション](./tgctl_ja.md#common-options) のほとんどを利用できません
* 資格情報をデフォルトの `~/.tsurugidb/credentials.key` に作成すると、ほかのコマンドのデフォルトの資格情報として利用可能です
* 資格情報は暗号化してローカルに保存します。ローカル側では復元できません

## EXIT STATUS

* `0` - 資格情報ファイルを作成した
* その他 - エラー等により資格情報ファイルを作成できなかった

## SEE ALSO

* [tgctl](./tgctl_ja.md)
* [tgsql](./tgsql_ja.md)
