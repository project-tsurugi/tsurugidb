# Tsurugi Getting Started

## インストール環境

Tsurugiをインストールするための環境については、以下のドキュメントに記載の要件を満たす必要があります。

* [Supported Platforms](./supported-platforms.md)

## インストール手順

### インストールアーカイブのダウンロード

TsurugiのインストールアーカイブはGitHub Releasesで公開されています。

- https://github.com/project-tsurugi/tsurugidb/releases

リリースページの各リリースの `Assets` を開き、 `tsurugidb-<version>.tar.gz` をダウンロードしてください。

**注意: Assetsに含まれる `Source code (zip)` , `Source code (tar.gz)` はGitHubが自動生成するリンクで、ここから取得できるアーカイブにはインストールに必要なファイルが含まれていないので使用しないでください**

ダウンロードしたインストールアーカイブを任意のディレクトリで解凍します。
このディレクトリは作業用ディレクトリであり、インストールディレクトリはインストール手順の中で別途指定します。

```sh
tar xf tsurugidb-<version>.tar.gz
cd tsurugidb-<version>
```

### インストーラーの実行 (Ubuntu)

Ubuntu上でのインストール手順を説明します。

#### aptパッケージ用インストールスクリプトの実行

インストールパッケージを解凍したディレクトリ直下に含まれる `apt-install.sh` を使ってTsurugiのインストールおよび実行に必要なライブラリをインストールします。

```sh
sudo ./apt-install.sh
```

`apt-install.sh` は `apt-get update` や `apt-get install` を使って必要なパッケージをインストールするため、スーパーユーザや `sudo` コマンド経由で実行する必要があります。
インストール環境への影響があるため、実行前にスクリプトの内容を確認の上で実行することを強く推奨します。

#### Tsurugiインストールスクリプトの実行

ソースアーカイブに含まれるインストールスクリプト `install.sh` を実行して実行バイナリをビルドし、 `--prefix=<install_directory>` で指定したインストールディレクトリにインストールします。
`--symbolic` はインストールパス上にシンボリックリンク `tsurugi` を作成します。

```sh
$ mkdir $HOME/opt
$ ./install.sh --prefix=$HOME/opt --symbolic
...
------------------------------------
[Install Tsurugi successful]
Install Directory: $HOME/opt/tsurugi-1.x.x
------------------------------------
```

`install.sh` を引数なしで実行する場合、標準のインストールパス `/usr/lib/tsurugi-<tsurugi-version>` 配下にインストールします。この場合、通常はスーパーユーザの権限での実行が必要となります。

### インストーラーの実行 (AlmaLinux, Rocky Linux)

AlmaLinux および Rocky Linux上でのインストール手順を説明します。

> [!IMPORTANT]
> 現在 AlmaLinux, Rocky Linux上での利用は試験的機能として提供しています。

#### EPELリポジトリ有効化スクリプトの実行

AlmaLinux および Rocky Linux上でのインストールに必要ないくつかのパッケージはEPELリポジトリからインストールします。
そのため、まずEPELリポジトリを有効化する必要があります。

インストール環境でEPELリポジトリが有効化されていない場合、インストールパッケージを解凍したディレクトリ直下に含まれる `dist/install/dnf-enable-epel.sh` を実行してEPELリポジトリを有効化します。

`dnf-enable-epel.sh` は `dnf update` や `dnf install` を使って必要なパッケージをインストールするため、スーパーユーザや `sudo` コマンド経由で実行する必要があります。
また、本書で示すインストール手順ではこのスクリプトによって有効化された設定はインストール後も維持されます。
インストール環境への影響があるため、実行前にスクリプトの内容を確認の上で実行することを強く推奨します。

```sh
sudo ./dist/install/dnf-enable-epel.sh
```

EPELリポジトリについての詳細は、OSのドキュメントなどを参照してください。
AlmaLinuxについては、以下のドキュメントにて説明されています。
- https://wiki.almalinux.org/repos/Extras.html#epel

#### dnfパッケージ用インストールスクリプトの実行

インストールパッケージを解凍したディレクトリ直下に含まれる `dist/install/dnf-install.sh` を使ってTsurugiのインストールおよび実行に必要なライブラリをインストールします。

```sh
sudo ./dist/install/dnf-install.sh
```

`dnf-install.sh` は `dnf update` や `dnf install` を使って必要なパッケージをインストールするため、スーパーユーザや `sudo` コマンド経由で実行する必要があります。
インストール環境への影響があるため、実行前にスクリプトの内容を確認の上で実行することを強く推奨します。

#### Tsurugiインストールスクリプトの実行

> [!IMPORTANT]
> 現在Tsurugiが動作検証済みのAlmaLinux, Rocky Linuxはバージョン9系ですが、これらのディストリビューションに含まれるGCCの不具合により、GCCを利用してTsurugiをインストールした場合にTsurugiに性能上の問題が発生することを確認しています。
> このため、AlmaLinux, Rocky Linux上でTsurugiをインストールする場合、Clangを使ってTsurugiをインストールすることを推奨しています。以降ではClangを使ったインストール手順を説明します。

ソースアーカイブに含まれるインストールスクリプト `install.sh` を実行して実行バイナリをビルドし、 `--prefix=<install_directory>` で指定したインストールディレクトリにインストールします。
`--symbolic` はインストールパス上にシンボリックリンク `tsurugi` を作成します。

また上述した通り、AlmaLinux, Rocky Linux上でのインストールはClangを使ってビルドを行うため、インストールスクリプト実行時にClangを利用するための環境変数を指定します。

```sh
$ mkdir $HOME/opt
$ CC=clang CXX=clang++ ./install.sh --prefix=$HOME/opt --symbolic
...
------------------------------------
[Install Tsurugi successful]
Install Directory: $HOME/opt/tsurugi-1.x.x
------------------------------------

[WARNING] /var/lock/ is not set to 1777.
Tsurugi uses /var/lock/ as the default location to create the lock file at startup.
However, the permissions on /var/lock/ are currently not set to 1777, which prevents non-privileged users from writing to this directory.
If you are starting tsurugidb process as a non-privileged user, edit the system.pid_directory parameter in var/etc/tsurugi.ini accordingly.
```

一般ユーザでインストールした場合、インストール完了時に `/var/lock/` ディレクトリのパーミッションが1777でないことによる警告が表示されることがあります (AlmaLinux, Rocky Linuxの標準のパーミッション設定ではこの警告が表示されます)。
この警告が表示された場合、後述の「 `pid_directory` の設定変更」の項を参照して、Tsurugiの設定を変更してください。

`install.sh` を引数なしで実行する場合、標準のインストールパス `/usr/lib/tsurugi-<tsurugi-version>` 配下にインストールします。この場合、通常はスーパーユーザの権限での実行が必要となります。

#### `pid_directory` の設定変更

Tsurugiはプロセスの死活監視やプロセスの二重起動防止のために、Tsurugiの設定ファイル `tsurugi.ini` の設定項目 `pid_directory` に指定されたディレクトリにプロセスのロックファイルを作成します。

`pid_directory` のデフォルト値は `/var/lock/` ですが、AlmaLinux, Rocky Linuxの標準のパーミッション設定では一般ユーザがこのディレクトリにロックファイルを作成できないため、Tsurugiを一般ユーザで起動する場合は `pid_directory` の値を変更する必要があります。

`pid_directory` の値を変更するには、Tsurugiのインストールディレクトリ配下に含まれる設定ファイル `var/etc/tsurugi.ini` を編集します。
コメントアウトされている `pid_directory` の行を有効にして、任意のディレクトリを絶対パスで指定します。

```ini
[system]
    pid_directory=/opt/tsurugi/var/lock
```

その上で、Tsurugiを起動するユーザが `/opt/tsurugi/var/lock` ディレクトリに書き込み権限を持つようにパーミッションを変更してください。

```sh
sudo mkdir -p /opt/tsurugi/var/lock
sudo chmod 1777 /opt/tsurugi/var/lock
```

### トラブルシューティングに関するインストール・オプション

- `--parallel=<jobs>` インストール時に実行されるビルド処理の最大並列ジョブ数を指定します。インストール時にメモリ不足などの問題が発生する場合、この値を低く設定することで問題を回避できる可能性があります。未指定の場合はインストール環境の(論理コア数 + 2)が設定されます。

  ```sh
  ./install.sh --parallel=8
  ```

### 環境変数 `TSURUGI_HOME` の設定

Tsurugiのインストールが完了したら、環境変数 `TSURUGI_HOME` にTsurugiのインストールパスを設定してください。
前述のインストールスクリプト実行例(`./install.sh --prefix=$HOME/opt --symbolic`) でインストールした場合、以下のように `TSURUGI_HOME` を設定します。

```sh
export TSURUGI_HOME="$HOME/opt/tsurugi"
```

環境変数 `TSURUGI_HOME` はTsurugiが提供するクライアントライブラリやツールが使用します。これらを使うユーザ環境については、実行時に `TSURUGI_HOME` が適用されるようシェル環境などを設定してください。

## Tsurugiの基本機能

Tsurugiサーバの起動/停止、Tsurugiサーバに対するSQL実行などの基本機能を提供するコマンドを紹介します。

以下に紹介するコマンドはイントールディレクトリの `bin` ディレクトリに配置されています。

### `tgctl` : Tsurugiサーバ管理コマンド

`tgctl` コマンドはTsurugiの起動・停止・状態確認などを行う管理コマンドです。

`tgctl start` でTsurugiサーバを起動します。

```sh
$ $TSURUGI_HOME/bin/tgctl start
...
successfully launched tsurugidb
```

`tgctl status` でTsurugiサーバの状態を確認できます。

```sh
$ $TSURUGI_HOME/bin/tgctl status
Tsurugi OLTP database is RUNNING
```

`tgctl shutdown` でTsurugiサーバを停止します。

```sh
$ $TSURUGI_HOME/bin/tgctl shutdown
...
successfully shutdown tsurugidb
```

### `tgsql` Tsurugi SQLコンソール

`tgsql` コマンドはTsurugiに対してクエリーを発行するためのCLIツールです。
`tgsql` では以下のいずれかの接続プロトコルを使って接続することができます。

- IPC接続: 比較的高速であるが、Tsurugiサーバと同一のマシンからのみ接続可能。
- TCP接続: 比較的低速であるが、Tsurugiサーバと異なるマシンからでも接続可能。

以下ではIPC接続を使った使用例を説明します。

```sh
$ $TSURUGI_HOME/bin/tgctl start
successfully launched tsurugidb

$ $TSURUGI_HOME/bin/tgsql -c ipc:tsurugi

[main] INFO com.tsurugidb.console.core.ScriptRunner - establishing connection: ipc:tsurugi
[main] INFO com.tsurugidb.console.core.ScriptRunner - start repl
tgsql>
```

`tgsql>` プロンプトが表示されるので、ここに任意のクエリーを入力できます。

```sql
tgsql> BEGIN;
transaction started. option=[
  type: OCC
]
Time: 56.096 ms
tgsql> CREATE TABLE tb1(pk INT PRIMARY KEY, c1 INT);
Time: 58.242 ms
tgsql> INSERT INTO tb1(pk, c1) VALUES(1,100);
Time: 49.57 ms
tgsql> SELECT * FROM tb1;
[pk: INT4, c1: INT4]
[1, 100]
(1 rows)
Time: 40.011 ms
tgsql> COMMIT;
transaction commit(DEFAULT) finished.
Time: 127.856 ms

tgsql> \quit
[main] INFO com.tsurugidb.console.core.ScriptRunner - repl execution was successfully completed
```

### Tsurugiサーバの設定

Tsurugiサーバの設定はTsurugiインストールディレクトリ配下の `var/etc/tsurugi.ini` に配置している「構成ファイル」によって定義されています。

```sh
$ cat $TSURUGI_HOME/var/etc/tsurugi.ini

# tsurugidb config parameters
# https://github.com/project-tsurugi/tsurugidb/blob/master/docs/config-parameters.md

[datastore]
    log_location=var/data/log

[cc]
    #epoch_duration=3000
    #waiting_resolver_threads=2
    ...
```

設定を編集したらTsurugiサーバを再起動して設定を反映してください。
設定項目については以下を参照してください。

- 構成ファイルのパラメーター
  - https://github.com/project-tsurugi/tsurugidb/blob/master/docs/config-parameters.md

## Tsurugiが提供する外部インターフェース群

TsurugiはプログラミングAPI、RESTインターフェース、他のデータベース連携といった様々な外部インターフェース機構を提供しています。

### `Iceaxe` アプリケーション開発用Java API

[Iceaxe](https://github.com/project-tsurugi/iceaxe)はTsurugiを利用するクライアントアプリケーションを開発するためのJava APIです。
Tsurugi固有の機能を利用しやすくすることに志向しており、JDBCインターフェースとは異なるAPI体系を持ちます。

- Iceaxe:
  - https://github.com/project-tsurugi/iceaxe
- Iceaxe Exmaples:
  - https://github.com/project-tsurugi/iceaxe/tree/master/modules/iceaxe-examples/src/main/java/com/tsurugidb/iceaxe/example

Iceaxeを利用して開発した、ベンチマーク用のバッチアプリケーションを合わせて公開しています。

- Cost Accounting Benchmark:
  - https://github.com/project-tsurugi/cost-accounting-benchmark
- Phone Bill Benchmark
  - https://github.com/project-tsurugi/phone-bill-benchmark

### `Tsubakuro` 低レベルJava API

[Tsubakuro](https://github.com/project-tsurugi/tsubakuro)はTsurugiの機能を最大限に引き出すための低レベルなJava APIです。
そのほとんどが非同期APIとして提供されており、便利なAPIではないですがTsurugiの性能を極限まで引き出す必要があるレイヤ開発などに有用です。

- Tsubakuro:
  - https://github.com/project-tsurugi/tsubakuro
- Tsubakuro Exmaples:
  - https://github.com/project-tsurugi/tsubakuro-examples

### `Belayer` 運用管理インターフェース

[Belayer](https://github.com/project-tsurugi/belayer-webapi)はRESTインターフェースを通じてバックアップ、リストア、データダンプ、データロードといった運用機能を提供します。
プロプライエタリのアドオンモジュールとしてGUI、コマンドラインツールなども提供しています。

- Belayer:
  - https://github.com/project-tsurugi/belayer-webapi
- Belayer Web API:
  - https://github.com/project-tsurugi/belayer-webapi/blob/master/docs/belayer_if_webapi-ja.md

### `Tsurugi_FDW` PostgreSQL連携インターフェース

[Tsurugi_FDW](https://github.com/project-tsurugi/tsurugi_fdw)は[PostgreSQL](https://www.postgresql.org/)の外部データラッパー機能を利用して、psqlなどのPostgreSQLが提供するインターフェースを経由してTsurugiに対するデータベース操作機能を提供します。

- Tsurugi_FDW:
  - https://github.com/project-tsurugi/tsurugi_fdw

### `Tanzawa` Tsurugi SQLコンソール

前述した `tgsql` コマンドを提供するモジュールです。
Tsurugiのインストーラーに同梱されている他に単体でのリリースアーカイブを提供しており、これをTsurugiのサーバとは別のマシンにインストールしてTCP接続経由でTsurugiを操作することも可能です。

- Tanzawa:
  - https://github.com/project-tsurugi/tanzawa
