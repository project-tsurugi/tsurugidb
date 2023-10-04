# Tsurugi Getting Stared

## Installation Environment

Currently, Tsurugi has been tested only in the following OS environment.

- Ubuntu-22.04

## Installation Instructions

### Installation archive

Tsurugi installation archives are available at GitHub Releases.

- https://github.com/project-tsurugi/tsurugidb/releases

Please open `Assets` of each release on the release page and download `tsurugidb-<version>.tar.gz`.

**Note: The `Source code (zip)` or `Source code (tar.gz)` in `Assets` are automatically generated links by GitHub, and these archives does not contain files needed for installation.**

ダウンロードしたインストールアーカイブを任意のディレクトリで解凍します。
このディレクトリは作業用ディレクトリであり、インストールディレクトリはインストール手順の中で別途指定します。

Please unzip the downloaded installation archive into any directory.
This is a working directory; the installation directory will be specified at another time during the installation procedure.

```sh
tar xf tsurugidb-<version>.tar.gz
```

### Installing libraries for runtime environment (apt package)

You can install the libraries required to install and run Tsurugi using `apt-install.sh`. This is included in the directory where you unzipped the installation package.

```sh
sudo ./apt-install.sh
```

`apt-install.sh` must be run as superuser or via the `sudo` command, in order to install the required packages using `apt-get update` or `apt-get install`.

### Installing Tsurugi

You can create an executable Tsurugi binary by executing the installation script `install.sh` included in the source archive.
If you specify `--prefix=<install_directory>`, the script will install to the specified installation directory, and `--symbolic` will create a symbolic link `tsurugi` on the installation path.

```sh
$ mkdir $HOME/opt
$ ./install.sh --prefix=$HOME/opt --symbolic
...
------------------------------------
[Install Tsurugi successful]
Install Directory: $HOME/opt/tsurugi-1.x.x
------------------------------------
```

If you execute `install.sh` without any arguments, it will put Tsurugi under the default installation path `/usr/lib/tsurugi-<tsurugi-version>`.
In this case, it is usually needed to run with superuser privileges.

```sh
sudo ./install.sh
```

#### Miscellaneous Installation Options

- `--parallel=<jobs>` Specifies the maximum number of parallel jobs for the build process to run during installation.

  If you face problems such as insufficient memory during installation sequence, setting this to a low value may get around the problem. If it is not specified, the value is set to (number of logical cores + 2) of the installation environment.

  ```sh
  ./install.sh --parallel=8
  ```

### Setting the `TSURUGI_HOME` environment variable

After the Tsurugi installation is complete, please set the environment variable `TSURUGI_HOME` to the Tsurugi installation path.
The following is an example of installing Tsurugi into `$HOME/tsurugi`.

```sh
export TSURUGI_HOME="$HOME/opt/tsurugi"
```

The environment variable `TSURUGI_HOME` is used by client libraries and utilities provided by Tsurugi.
If you use them, set `TSURUGI_HOME` to your shell environment and so on.

## Fundamental features of Tsurugi

This section introduces commands that provide fundamental Tsurugi capabilities such as starting/stopping Tsurugi server, executing SQL against Tsurugi server, etc.

The subsequent commands are located in the `bin` directory of the intall directory.

### `tgctl` : Tsurugiサーバ管理コマンド

`tgctl` コマンドはTsurugiの起動・停止・状態確認などを行う管理コマンドです。

`tgctl start` でTsurugiサーバを起動します。

```sh
$ $TSURUGI_HOME/bin/tgctl start
...
successfully launched tsurugidb
```

`tgctl status` でTsurugiサーバを状態を確認できます。

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

```sh
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
