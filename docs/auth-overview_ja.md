# Tsurugi のユーザー認証とテーブル権限

[tsurugi.ini の設定一覧]:https://github.com/project-tsurugi/tsurugidb/blob/master/docs/config-parameters.md
[tgctl]:https://github.com/project-tsurugi/tsurugidb/tree/master/docs/cli/tgctl_ja.md
[tgctl credentials]:https://github.com/project-tsurugi/tsurugidb/tree/master/docs/cli/tgctl-credentials_ja.md
[tgsql]:https://github.com/project-tsurugi/tsurugidb/tree/master/docs/cli/tgsql_ja.md
[tgdump]:https://github.com/project-tsurugi/tsurugidb/tree/master/docs/cli/tgdump_ja.md
[REST API 仕様]:https://github.com/project-tsurugi/harinoki/blob/master/docs/rest-api-ja.md
[認証トークン仕様]:https://github.com/project-tsurugi/harinoki/blob/master/docs/token-ja.md
[認証サーバーの起動設定]:https://github.com/project-tsurugi/harinoki/blob/master/docs/setting-ja.md
[エラーコード]:https://github.com/project-tsurugi/tsurugidb/blob/master/docs/error-code-tsurugi-services.md
[Jetty]:https://jetty.org/
[JAAS]:https://jetty.org/docs/jetty/12/operations-guide/security/jaas-support.html

Tsurugi 1.6.0 では、簡単なユーザー認証と、テーブル権限の制御の仕組みを導入しました。
このドキュメントでは、その概要と設定方法について説明します。

## ユーザー認証

Tsurugi のユーザー認証は、Tsurugi に接続する際に資格情報 (ユーザー名やパスワードなど) を要求する仕組みです。
認証機能を有効にした状態で、存在しないユーザーや誤ったパスワードを入力すると、Tsurugi への接続が拒否されます。

```sh
# tgsql に存在しないユーザー名を指定する例
tgsql -c ipc:tsurugi --user no-such-user
password: ****
SCD-00201: authentication failed as the combination of user name and password is incorrect (Use `\connect` to connect)
```

なお、上記の `SCD-00201` は Tsurugi の[エラーコード]で、認証に失敗したことを示しています (`AUTHENTICATION_ERROR`)。

## システム構成

Tsurugi の認証機構は、以下のコンポーネントで構成されています:

![認証機構のシステム構成図](auth-overview/architecture_ja.drawio.svg)

* アプリケーション: Tsurugi に接続するクライアントアプリケーション
* Tsurugi データベース: ユーザー認証を有効にした Tsurugi インスタンス
* 認証サービス: 認証トークンを発行するサービス
  * [Jetty] 内のウェブアプリケーションとして動作します
* 認証バックエンド: 実際にユーザー名とパスワードを管理するコンポーネント群
  * Jetty の標準の認証機構である、 [JAAS] を利用して認証を行います

ユーザー認証は、主に以下の流れで行います (パスワード認証の例)。

1. Tsurugi データベースは、システム起動時に認証サービスから公開鍵を取得します
2. アプリケーションは、Tsurugi データベースに接続を試みる際、データベースから公開鍵を取得します
3. アプリケーションは、ユーザー名とパスワードを公開鍵で暗号化し (暗号化資格情報) 、Tsurugi データベースに送信します
4. Tsurugi データベースは、受け取った暗号化資格情報を認証サービスに送信します
5. 認証サービスは、秘密鍵を利用して暗号化資格情報を復号し、ユーザー名とパスワードを取得します
6. 認証サービスは、ユーザー名とパスワードを認証バックエンドに渡し、検証を行います
7. 認証サービスは、認証に成功したら認証トークンを発行し、Tsurugi データベースに返します
8. Tsurugi データベースは、認証トークンを受け取ったら、アプリケーションに接続を許可します

上記のような構成で、アプリケーションは認証サービスと直接の通信を行わないため、認証サービスを外部に公開する必要はありません。

## 認証サービスの設定

なお、認証サービスは Tsurugi データベースとは独立して起動や終了の制御を行う必要があります。
以下は、認証サービスを起動、終了する例です:

```sh
# 認証サービスの起動
$TSURUGI_HOME/bin/authentication-server start

# 認証サービスの終了
$TSURUGI_HOME/bin/authentication-server stop
```

また、標準のインストールでは、認証バックエンドとしてローカルのパスワードファイルを使用します。
標準のパスワードファイル (`$TSURUGI_HOME/var/auth/etc/harinoki-users.props`) には、インストール直後は以下の内容が含まれます:

```props
tsurugi: password,harinoki-user
```

上記は、ユーザー名 `tsurugi` とパスワード `password` の組み合わせで認証を行う設定です。
また、認証を行う realm には `harinoki-user` を指定します。

このファイルに `ユーザー名: パスワード,harinoki-user` の行を追加することで、データベースに接続可能なユーザーを追加できます。
以下は `admin` ユーザーを追加する例です。

```props
tsurugi: password,harinoki-user
admin: p@ssw0rd,harinoki-user
```

認証サービスの詳細や設定方法については、 [認証サーバーの起動設定] を参照してください。

## Tsurugi データベースの設定

Tsurugi データベースは、デフォルトではユーザー認証が無効になっています。
ユーザー認証を有効にするには、認証サービスを利用可能な状態にしたうえで、Tsurugi の構成定義ファイル (`tsurugi.ini`) の `[authentication]` セクションを以下のように設定します:

```ini
[authentication]
enabled = true
```

上記では、ユーザー認証を有効にし、デフォルトの認証サービス `http://localhost:8080/harinoki` を利用して認証を行います。

ユーザー認証を有効にして Tsurugi データベースを起動すると、接続時に資格情報の提供が必要になります。

各種設定の詳細は、 [tsurugi.ini の設定一覧] の `[authentication]` セクションを参照してください。

## 資格情報

ユーザー認証を有効にした場合、Tsurugi へ接続する際にはユーザーの資格情報を提供する必要があります。
資格情報には主に以下の種類があります:

| 資格情報の種類 | 概要 |
|----------------|------|
| ユーザー名とパスワード | ユーザー名とパスワードの組み合わせで認証を行います |
| 暗号化資格情報 | 暗号化したユーザー名とパスワードの情報を使用して認証を行います |
| 認証トークン | 認証サービスから発行されるトークンを使用して認証を行います |

以降では、各資格情報の詳細と、Tsurugi の各種ツールでの使用方法について説明します。

### 暗号化資格情報

暗号化資格情報は、ユーザー名とパスワードを暗号化した形式で保存し、認証時に使用する方法です。
平文でユーザー名とパスワードを保存することなく、安全に Tsurugi を利用できます。

暗号化資格情報を作成するには、以下のコマンドを実行します:

```sh
tgctl credentials
```

上記のコマンドを実行すると、対話形式でユーザー名とパスワードの入力を求められます。
これらを入力すると、暗号化された資格情報 `~/.tsurugidb/credentials.key` が生成されます。

>[!IMPORTANT]
> 資格情報の作成には、認証機能を有効化した Tsurugi データベースが稼働中である必要があります。

なお、オプションを指定しない場合、この資格情報は 90 日間有効です。
有効期限を変更するには、 `--expiration <days>` オプションを使用します (例: `--expiration 30`)。

暗号化資格情報の作成について、詳しくは [tgctl credentials] のドキュメントを参照してください。

>[!NOTE]
> 内部的には、ユーザー名とパスワードを直接入力して Tsurugi と接続した際にも、
> 一時的に上記と同様の暗号化資格情報を生成してそれを Tsurugi データベースに送信しています。
> `tgctl credentials` コマンドは、その暗号化資格情報をあらかじめ作成し、保存するためのものです。

### 認証トークン

認証トークンは認証サービスが発行するトークンで、Tsurugi への接続時に利用できます。
これは主に、Tsurugi と連携するサービス (例: Belayer) のために設計されており、通常はユーザーが直接利用するケースはありません。

認証トークンを取得するには、認証サービスの REST API (`/issue`) を使用します:

```sh
curl -u tsurugi:password http://localhost:8080/harinoki/issue
```

上記は `http://localhost:8080/harinoki` で稼働している認証サービスから、ユーザー `tsurugi` のトークンを取得する例です。
実行すると、以下のような JSON レスポンスが返されます (一部省略):

```json
{"type":"ok","token":"..."}
```

実際には、 `token` フィールドに含まれる長い文字列が認証トークンです。

認証サービスの REST API や、認証トークンの詳細については、それぞれ以下を参照してください。

* [REST API 仕様]
* [認証トークン仕様]

### CLI の認証オプション

Tsurugi の各種 CLI ツールでは、以下のオプションを使用して認証機能を利用できます:

| オプション | 説明 |
|------------|------|
| `--user <username>` | オプションにユーザー名、プロンプトでパスワードを入力し、認証を行います。 |
| `--credentials <file>` | 指定したファイルから暗号化資格情報を読み込み、認証を行います。 |
| `--auth-token <token>` | 指定した認証トークンを使用して認証を行います。 |
| `--no-auth` | 資格情報を使用せずに、ログインを試みます (認証機能が無効な場合にのみ有効)。 |

上記のオプションがいずれも指定されなかった場合、以下の手順で認証を試みます:

1. 環境変数 `TSURUGI_AUTH_TOKEN` が設定されている場合、その値を認証トークンとして使用します
2. `~/.tsurugidb/credentials.key` が存在する場合、そのファイルを暗号化資格情報として使用します
3. ユーザー名とパスワードを対話的に入力し、認証を行います

以下は、SQL コンソールに接続する際の例です:

```sh
$ tgsql -c ipc:tsurugi --user tsurugi
[main] INFO com.tsurugidb.tgsql.core.TgsqlRunner - establishing connection: ipc:tsurugi
password: ********
[main] INFO com.tsurugidb.tgsql.core.TgsqlRunner - start repl
tgsql>
```

それぞれの CLI ツールについて、詳細は以下を参照してください:

* [tgctl]
* [tgsql]
* [tgdump]

### Tsubakuro (Java)

Tsurugi の Java クライアントライブラリである Tsubakuro から、資格情報を指定して Tsurugi に接続するには以下のように書きます:

```java
Credential credential = new UsernamePasswordCredential("tsurugi", "password");
Session session = SessionBuilder.connect("ipc:tsurugi")
    .withCredential(credential)
    .create();
```

上記では、 [`SessionBuilder`](https://github.com/project-tsurugi/tsubakuro/blob/master/modules/session/src/main/java/com/tsurugidb/tsubakuro/common/SessionBuilder.java) を利用してセッションを構築する際に、 `withCredential` メソッドを使用して資格情報を指定しています。
資格情報を表す [Credential](https://github.com/project-tsurugi/tsubakuro/blob/master/modules/common/src/main/java/com/tsurugidb/tsubakuro/channel/common/connection/Credential.java) インターフェースには、以下の種類の実装があります:

| クラス | CLI との対応 | 説明 |
|-------|------|------|
| [`UsernamePasswordCredential`](https://github.com/project-tsurugi/tsubakuro/blob/master/modules/common/src/main/java/com/tsurugidb/tsubakuro/channel/common/connection/UsernamePasswordCredential.java) | `--user` | ユーザー名とパスワードを使用して認証を行います。 |
| [`RememberMeCredential`](https://github.com/project-tsurugi/tsubakuro/blob/master/modules/common/src/main/java/com/tsurugidb/tsubakuro/channel/common/connection/RememberMeCredential.java) | `--auth-token` | 認証トークンを使用して認証を行います。 |
| [`FileCredential`](https://github.com/project-tsurugi/tsubakuro/blob/master/modules/common/src/main/java/com/tsurugidb/tsubakuro/channel/common/connection/FileCredential.java) | `--credentials` | 暗号化資格情報を使用して認証を行います。 |
| [`NullCredential`](https://github.com/project-tsurugi/tsubakuro/blob/master/modules/common/src/main/java/com/tsurugidb/tsubakuro/channel/common/connection/NullCredential.java) | `--no-auth` | 資格情報を使用せずに接続を試みます (認証機能が無効な場合にのみ有効)。 |

### Iceaxe (Java)

Iceaxe は Tsubakuro をラップし、より高レベルな API を提供するライブラリです。
Iceaxe から Tsurugi に接続する際も、Tsubakuro と同様に資格情報を指定できます:

```java
Credential credential = new UsernamePasswordCredential("tsurugi", "password");
TsurugiConnector connector = TsurugiConnector.of("ipc:tsurugi", credential);
try (TsurugiSession session = connector.createSession(credential)) {
    // ...
}
```

なお、Iceaxe と Tsubakuro では、共通の資格情報 ([Credential](https://github.com/project-tsurugi/tsubakuro/blob/master/modules/common/src/main/java/com/tsurugidb/tsubakuro/channel/common/connection/Credential.java) インターフェース) を利用可能です。

### Tsubakuro/Rust

Tsubakuro/Rust (Rust 版の Tsubakuro) でも、Java と類似の方法で資格情報を使用できます。

```rust
let credential = Credential::from_user_password("tsurugi", Some("password"));
let mut connection_option = ConnectionOption::new();
connection_option.set_endpoint_url("tcp://localhost:12345")?;
connection_option.set_credential(credential);
let session = Session::connect(&connection_option).await?;
```

資格情報を表す [Credential](https://github.com/project-tsurugi/tsubakuro-rust/blob/master/tsubakuro-rust-core/src/session/credential.rs) 列挙型には、以下の種類の実装があります:

| 列挙子 | 作成メソッド | CLI との対応 | 説明 |
|-------|-------------|------|------|
| `UserPassword` | `from_user_password` | `--user` | ユーザー名とパスワードを使用して認証を行います。 |
| `AuthToken` | `from_auth_token` | `--auth-token` | 認証トークンを使用して認証を行います。 |
| `File` | `load` | `--credentials` | 暗号化資格情報を使用して認証を行います。 |
| `Null` | `null` | `--no-auth` | 資格情報を使用せずに接続を試みます (認証機能が無効な場合にのみ有効)。 |

### Tsurugi ODBC ドライバー

Tsurugi ODBC ドライバー APIを使用して Tsurugi に接続する場合、接続文字列に資格情報を指定できます。詳細は、以下のドキュメントを参照してください:
- [Tsurugi ODBCドライバー 使用方法](https://github.com/project-tsurugi/tsubakuro-rust/blob/master/tsubakuro-rust-odbc/docs/usage_ja.md)

また、Windows 版のODBC ドライバーでは、ODBC データソース アドミニストレーターで資格情報を含むデータソースを設定できます。詳細は、以下のドキュメントを参照してください:
- [Tsurugi ODBCドライバー インストール方法](https://github.com/project-tsurugi/tsubakuro-rust/blob/master/tsubakuro-rust-odbc/docs/install_ja.md)

## システム管理者の設定

システム管理者は、Tsurugi データベースのすべての操作を実行できる特別なユーザーです。
Tsurugi のデフォルトの設定では、 **すべてのユーザーがシステム管理者** として登録されています。

システム管理者を制限するには、Tsurugi の構成定義ファイル (`tsurugi.ini`) の `[authentication]` セクションに以下の設定を追加します:

```ini
[authentication]
...
administrators = tsurugi, admin
```

上記のようにカンマ (`,`) 区切りでユーザー名を指定することで、システム管理者を `tsurugi` と `admin` の 2 ユーザーに制限できます。
設定の詳細は、 [tsurugi.ini の設定一覧] の `[authentication]` セクションを参照してください。

システム管理者でないユーザー (以下、一般ユーザー) は、主に以下の制限を受けます:

| 操作 | 制限 |
| ---- | ---- |
| データベースの起動・終了 | 制限はありません (*1) |
| バックアップの作成・復元 | 一般ユーザーは利用できません |
| セッションの制御 | 当該ユーザーが所有するセッションのみ表示や収量が可能です |
| テーブルの操作 | 個別の[テーブル権限](#テーブル権限の制御)によって制御されます |

*1: Tsurugi 1.6.0 での暫定的な仕様です。将来的に制限される可能性があります。

より詳細な情報については、[tgctl] のドキュメントや、次節の[テーブル権限の制御](#テーブル権限の制御)を参照してください。

## テーブル権限の制御

Tsurugi の一般ユーザーは、デフォルトではテーブルの読み書きが行えません。
読み書きを行うためには、システム管理者がテーブルを作成し、一般ユーザーに対してそのテーブルに対する権限を付与する必要があります。

### テーブル権限の付与

一般ユーザーにテーブル操作の権限を付与するには、 `GRANT` 文を使用します。
以下は、システム管理者がテーブルを作成し、一般ユーザーに対して読み取り (`SELECT`) と行の追加 (`INSERT`) の権限を付与する例です:

```sql
-- システム管理者で実行
CREATE TABLE t1 (id INT, name VARCHAR(*));

-- テーブル t1 に対して、一般ユーザー user1 に SELECT, INSERT 権限を付与
GRANT SELECT, INSERT ON t1 TO user1;
```

また、特別な権限として `ALL PRIVILEGES` があります。
これは、対象テーブルに対して管理者と同等のすべての権限を付与します:

```sql
GRANT ALL PRIVILEGES ON t1 TO user1;
```

以下は、権限の一覧と、その権限が許可する操作の例です:

| 操作内容 | `ALL PRIVILEGES` | `SELECT` | `INSERT` | `UPDATE` | `DELETE` |
|----------|:----------------:|:--------:|:-------:|:-------:|:-------:|
| メタデータの取得 | o | o | o | o | o |
| 行の読み取り | o | o |   |   |   |
| 行の追加 | o |   | o |   |   |
| 行の更新 | o |   |   | o*1 |   |
| 行の削除 | o |   |   |   | o*2 |
| テーブルの作成 |  |  |  |  |  |
| テーブルの削除 | o | |  |  |  |
| インデックスの作成 | o |  |  |  |  |
| インデックスの削除 | o |  |  |  |  |
| 権限の制御 | o |  |  |  |  |

*1: 行の更新 (`UPDATE` 文の実行) には、 `UPDATE` 権限のほかに `SELECT` 権限も必要です。

*2: 行の削除 (`DELETE` 文の実行) には、 `DELETE` 権限のほかに `SELECT` 権限も必要です。

メタデータの取得の権限は、テーブル一覧の取得、テーブルメタデータの取得、および `EXPLAIN` によるクエリプランの取得に必要です。
当該権限を持っていない場合、テーブル一覧の取得を行った際に、対象のテーブルが結果に含まれません。
なお、メタデータの権限は将来的に、個別の権限として独立させる予定です。

また、一般ユーザーであっても、テーブル権限の制御に関する権限 (`ALL PRIVILEGES`) が付与されていれば、ほかの一般ユーザーに対して `GRANT` 文を実行できます。

>[!NOTE]
> Tsurugi 1.6.0 では、一般ユーザーはテーブルの作成を行えません。
> 将来的に、スキーマの導入に伴い、スキーマにテーブル作成権限を付与することで、一般ユーザーでもテーブルを作成できるようになる予定です。

>[!IMPORTANT]
> Tsurugi 1.6.0 では、テーブルに付与された権限の一覧を確認する方法はありません。
> 今後、情報スキーマ等の方法で確認方法を提供予定です。

### テーブル権限の剥奪

一般ユーザーに付与したテーブル操作の権限を剥奪するには、 `REVOKE` 文を使用します。
以下は、一般ユーザー user1 からテーブル t1 に対する `INSERT`, `DELETE` 権限を剥奪する例です:

```sql
-- テーブル t1 に対して、一般ユーザー user1 から INSERT, DELETE 権限を剥奪
REVOKE INSERT, DELETE ON t1 FROM user1;
```

また、テーブルに対するすべての権限を剥奪するには、 `ALL PRIVILEGES` を指定します:

```sql
-- テーブル t1 に対して、一般ユーザー user1 からすべての権限を剥奪
REVOKE ALL PRIVILEGES ON t1 FROM user1;
```

注意すべき点として、 `ALL PRIVILEGES` の権限を付与したユーザーから、`SELECT`, `INSERT` などの個別の権限を剥奪することはできません。
そのため、一度 `REVOKE ALL PRIVILEGES` を実行したうえで、必要な権限を再度 `GRANT` する必要があります。

なお、 `REVOKE` 文の実行には、テーブル権限の制御に関する権限が必要です。
そのため、システム管理者または `ALL PRIVILEGES` 権限を付与された一般ユーザーのみが `REVOKE` 文を実行できます。

また、SQL標準外の機能として、ユーザー指定に関する拡張構文 `REVOKE ALL PRIVILEGES .. FROM *` , `REVOKE ALL PRIVILEGES .. FROM CURRENT_USER` をサポートしています。
- `REVOKE ALL PRIVILEGES .. FROM *` は、これを実行したユーザーを除き、すべてのユーザーの権限を剥奪します。
  - 後述する `PUBLIC` で付与したデフォルトの権限を含めて剥奪します。
- `REVOKE ALL PRIVILEGES .. FROM CURRENT_USER` は、これを実行したユーザー自身の権限を剥奪します。

### 全ユーザーに対するデフォルトの権限の制御

`GRANT .. TO ...` でユーザー名に `PUBLIC` を指定すると、すべてのユーザーに対するデフォルトの権限を付与できます。

```sql
-- テーブル t1 に対して、すべてのユーザーに SELECT 権限を付与
GRANT SELECT ON t1 TO PUBLIC;
```

デフォルトの権限が与えられたテーブルに対しては、個別の権限を持たない一般ユーザーであっても、当該権限に含まれる操作を行えます。
例えば、上記であればすべての一般ユーザーはテーブル t1 に対して行の読み取りを行えます。

また、すべてのユーザーに `SELECT` デフォルトの権限を付与したうえで、特定のユーザーに個別の権限を付与することも可能です。

```sql
-- テーブル t1 に対して、すべてのユーザーに SELECT 権限を付与
GRANT SELECT ON t1 TO PUBLIC;

-- テーブル t1 に対して、さらに一般ユーザー user1 に INSERT 権限を付与
GRANT INSERT ON t1 TO user1;
```

上記の場合、一般ユーザー user1 はテーブル t1 に対して行の読み取りと追加を行えますが、ほかの一般ユーザーは行の読み取りのみ可能です。

同様に、 `REVOKE .. FROM ...` でユーザー名に `PUBLIC` を指定すると、すべてのユーザーからデフォルトの権限を剥奪できます。

```sql
-- テーブル t1 に対して、すべてのユーザーから SELECT 権限を剥奪
REVOKE SELECT ON t1 FROM PUBLIC;
```

上記は、すべての一般ユーザーから `SELECT` の権限を **剥奪するわけではありません** 。
あくまで、デフォルトの権限を剥奪するのみであり、ユーザーに対して個別に `SELECT` 権限が付与されている場合、そのユーザーは引き続き `SELECT` 操作を行えます。

>[!NOTE] `GRANT` , `REVOKE` 文の仕様についての詳細は、以下のドキュメントを参照してください:
>  - [Available SQL features in Tsurugi - GRANT PRIVILEGE](https://github.com/project-tsurugi/tsurugidb/blob/master/docs/sql-features.md#grant-privilege)
>  - [Available SQL features in Tsurugi - REVOKE PRIVILEGE](https://github.com/project-tsurugi/tsurugidb/blob/master/docs/sql-features.md#revoke-privilege)
