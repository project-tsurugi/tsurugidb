# Tsurugi Getting Started

## インストール環境

現時点では、Tsurugiは以下のOS環境でのみ動作を確認しています。

- Ubuntu-22.04
- Ubuntu-24.04 (Experimental support)

## インストール手順

### インストールアーカイブ

TsurugiのインストールアーカイブはGitHub Releasesで公開されています。

- https://github.com/project-tsurugi/tsurugidb/releases

リリースページの各リリースの `Assets` を開き、 `tsurugidb-<version>.tar.gz` をダウンロードしてください。

**注意: Assetsに含まれる `Source code (zip)` , `Source code (tar.gz)` はGitHubが自動生成するリンクで、ここから取得できるアーカイブにはインストールに必要なファイルが含まれていないので使用しないでください**

ダウンロードしたインストールアーカイブを任意のディレクトリで解凍します。
このディレクトリは作業用ディレクトリであり、インストールディレクトリはインストール手順の中で別途指定します。

```sh
tar xf tsurugidb-<version>.tar.gz
```

### 実行環境用ライブラリ（aptパッケージ）のインストール

インストールパッケージを解凍したディレクトリ直下に含まれる `apt-install.sh` を使ってTsurugiのインストールおよび実行に必要なライブラリをインストールします。

```sh
sudo ./apt-install.sh
```

`apt-install.sh` は `apt-get update` や `apt-get install` を使って必要なパッケージをインストールするため、スーパーユーザや `sudo` コマンド経由で実行する必要があります。
インストール環境への影響があるため、実行前にスクリプトの内容を確認の上で実行することを強く推奨します。

### Tsurugiのインストール

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

#### その他のインストール・オプション

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
tgsql>  INSERT INTO tb1(pk, c1) VALUES(1,100);
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
# https://github.com/project-tsurugi/tateyama/blob/master/docs/config_parameters.md

[cc]
    #epoch_duration=40000
    #waiting_resolver_threads=2

[datastore]
    log_location=var/data/log
    ...
```

設定を編集したらTsurugiサーバを再起動して設定を反映してください。
設定項目については以下を参照してください。

- 構成ファイルのパラメーター
  - https://github.com/project-tsurugi/tateyama/blob/master/docs/config_parameters.md

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
