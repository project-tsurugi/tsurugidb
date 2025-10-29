# tgctl

## NAME

`tgctl` - Tsurugi データベースの管理ツール

## SYNOPSIS

```sh
tgctl <command> [OPTIONS]
```

## DESCRIPTION

`tgctl` は Tsurugi データベースの管理コマンドラインツールです。
操作内容をサブコマンドに指定し、オプション引数で詳細な動作を制御します。

## EXAMPLES

```sh
tgctl start
tgctl status
tgctl shutdown
```

## COMMANDS

以下のサブコマンドが利用可能です:

* ライフサイクル管理
  * [`tgctl start`](./tgctl-start_ja.md)
  * [`tgctl shutdown`](./tgctl-shutdown_ja.md)
  * [`tgctl kill`](./tgctl-kill_ja.md)
  * [`tgctl quiesce`](./tgctl-quiesce_ja.md)
  * [`tgctl status`](./tgctl-status_ja.md)
* バックアップ・リストア
  * [`tgctl backup create`](./tgctl-backup-create_ja.md)
  * [`tgctl restore backup`](./tgctl-restore-backup_ja.md)
* セッション管理
  * [`tgctl session list`](./tgctl-session-list_ja.md)
  * [`tgctl session show`](./tgctl-session-show_ja.md)
  * [`tgctl session shutdown`](./tgctl-session-shutdown_ja.md)
  * [`tgctl session set`](./tgctl-session-set_ja.md)
* その他
  * [`tgctl credentials`](./tgctl-credentials_ja.md)
  * [`tgctl config`](./tgctl-config_ja.md)

<!--
* データベースメトリクス
  * `tgctl dbstats show`
  * `tgctl dbstats list`
* Altimeter ロガー制御
  * tgctl altimeter
-->

## COMMON OPTIONS

多くのサブコマンドでは、以下の共通オプションをサポートしています (いずれも任意):

* `--conf </path/to/tsurugi.ini>` : 構成定義ファイルのパス
  * 指定された構成定義ファイル (`tsurugi.ini`) に関連する、Tsurugi インスタンスの設定を表示します
  * 未指定の場合は [デフォルトの構成定義ファイル](#構成定義ファイル) を使用します
* `--user <username>` : 接続に使用するユーザー名
  * プロンプトでパスワードを入力し、オプション引数のユーザー名と組み合わせて認証を試みます
  * 詳細は [認証オプション](#認証オプション) を参照してください
* `--auth-token <token-string>` : 接続に使用する認証トークン
  * オプション引数に指定された認証トークンを使用して認証を試みます
  * 詳細は [認証オプション](#認証オプション) を参照してください
* `--credentials <path>` : 接続に使用する認証情報ファイルのパス
  * 指定された認証情報ファイルを使用して認証を試みます
  * 詳細は [認証オプション](#認証オプション) を参照してください
* `--no-auth`
  * ゲスト接続を試みます
  * 詳細は [認証オプション](#認証オプション) を参照してください
* `--quiet`
  * 標準出力への出力を抑制します

### 構成定義ファイル

`tgctl` は管理対象の Tsurugi インスタンスを特定するため、 `--conf` で対象の構成定義ファイル (`tsurugi.ini`) のパスを指定します。

オプション `--conf` が指定されない場合、以下の順序で構成定義ファイルを探します:

1. 環境変数 `TSURUGI_CONF` が設定されている場合、その値を構成定義ファイルのパスとして使用します
   * 当該ファイルが存在しない場合、コマンドはエラー終了します
2. 環境変数 `TSURUGI_CONF` が設定されておらず、環境変数 `TSURUGI_HOME` が設定されている場合、既定の構成ファイル (`${TSURUGI_HOME}/var/etc/tsurugi.ini`) を使用します
   * 当該ファイルが存在しない場合、コマンドはエラー終了します
3. 上記のいずれも設定されていない場合、コマンドはエラー終了します

### 認証オプション

認証オプションは以下のいずれか一つを指定できます:

* `--user`
* `--auth-token`
* `--credentials`
* `--no-auth`

認証オプションは互いに排他的です。
複数の認証オプションを指定した場合、コマンドはエラー終了します。

認証オプションが一つも指定されなかった場合、以下の順序で認証情報を取得します:

1. 環境変数 `TSURUGI_AUTH_TOKEN` が設定されている場合、その値を認証トークンとして使用します
   * 当該トークンを利用した認証に失敗した場合、次のステップに進みます
2. 既定の資格情報ファイル (`${HOME}/.tsurugidb/credentials.key`) が存在する場合、そのファイルを資格情報ファイルとして使用します
   * 当該ファイルを利用した認証に失敗した場合、次のステップに進みます
3. 認証情報を利用せず、ゲストで接続します
   * ゲスト接続が許可されていない場合、次のステップに進みます
4. ユーザー名とパスワードのプロンプトを表示し、対話的に資格情報を取得します
   * ユーザー名に空文字が指定された場合、次のステップに進みます
   * 入力された資格情報を利用した認証に失敗した場合、次のステップに進みます
5. コマンドはエラー終了します

## SEE ALSO

* [tgsql](./tgsql_ja.md)
