# Tsurugi Dockerユーザーガイド

本書ではTsurugiのDockerイメージの利用方法について説明します。

## Tsurugi Dockerイメージの概要

Tsurugi DockerイメージはTsurugiサーバがインストールされたDockerイメージです。

Dockerコンテナの起動・停止と連動してTsurugiサーバが動作します。
Tsurugi DockerイメージをDockerコンテナとして起動すると、コンテナのエントリポイントでTsurugiサーバを起動します。
Dockerコンテナを停止すると、Tsurugiサーバも停止します。

Tsurugiサーバのログは、標準エラー出力経由でDockerコンテナのログにマッピングされます。
Tsurugiサーバのログを確認したい場合、Dockerコンテナのログから確認することができます。

## Tsurugi Dockerイメージの入手方法

Tsurugi DockerイメージはGitHub Container Registry上で公開しています。
イメージURLやリリースのタグ情報などは以下のURLを参照してください。

- https://github.com/project-tsurugi/tsurugidb/pkgs/container/tsurugidb


## Tsurugi Dockerコンテナの利用方法

以下、Tsurugi Dockerコンテナの実行例です。
ここで紹介する方法以外 ( docker-compose 上で利用するなど ) で利用しても問題ありません。

#### Dockerコンテナの起動

* `docker container run` でDockerコンテナを起動

```
$ docker container run -d -p 12345:12345 --name tsurugi ghcr.io/project-tsurugi/tsurugidb
```

* オプション
  * `-d`: フォアグラウンドモードでは起動した後ターミナルが操作不能になるため、デタッチドモードを指定してください。
  * `-p 12345:12345`: TsurugiサーバのデフォルトTCPポート `12345` をホスト側にポート `12345` として公開します。
  * `--name tsurugi`: コンテナ名に `tsurugi`を指定

#### Dockerコンテナの状態確認

* `docker container ls` でDockerコンテナの状態を確認

```sh
$ docker container ls -a
$ sudo docker container ls -a
CONTAINER ID   IMAGE                               COMMAND                  CREATED          STATUS                    PORTS                                           NAMES
4b9d9866c8f0   ghcr.io/project-tsurugi/tsurugidb   "docker-entrypoint.sh"   13 seconds ago   Up 8 seconds              0.0.0.0:12345->12345/tcp, :::12345->12345/tcp   tsurugi
```

#### Tsurugiサーバのログを確認

* `docker container logs` でDockerコンテナの状態を表示、 `-f` オプションで追跡

```sh
$ docker container logs -f tsurugi
starting tsurugi...
#### BUILD_INFO
TSURUGI_VERSION:1.X.X
...
```

#### Dockerコンテナを停止とクリーンアップ

* `docker container stop` でDockerコンテナを停止

```
$ docker container stop tsurugi
tsurugi
```

#### Dockerコンテナへの接続

Tsurugiサーバに対してクライアントから接続する方法は主に以下の2つの形式があります。
* コンテナの内部から接続する
* コンテナの外部から接続する

### コンテナの内部から接続

Dockerコンテナの内部から接続（つまりローカル接続）する場合は、IPC接続経由で接続してください。IPC接続は共有メモリを介した高速が通信環境を提供します。

Dockerコンテナ上には標準のクライアントとして Tsurugi CLI (`tgsql` コマンド) が同梱されています。

```sh
$ docker container exec -it tsurugi bash
tsurugi@xxxxxx:/usr/lib/tsurugi-1.x.x$ tgsql -c ipc:tsurugi
[main] INFO com.tsurugidb.console.core.ScriptRunner - establishing connection: ipc:tsurugi
[main] INFO com.tsurugidb.console.core.ScriptRunner - start repl
tgsql> BEGIN;
transaction started. option=[
  type: OCC
]
Time: 59.087 ms
tgsql>
...
```

その他のクライアントアプリケーションをIPC接続経由で実行する場合は、Dockerコンテナ上にアプリケーションの実行環境一式を配置する必要があります。


### コンテナの外部から接続

Dockerコンテナの外部から接続する場合は、TCP接続経由で接続してください。
TCP接続経由の場合、リモートホストからの接続も可能です。

Dockerイメージをコンテナとして実行する際に、TsurugiサーバのTCP接続エンドポイントのポートを、ホストマシンの任意のポートにマッピングして起動する必要があります。

外部のJavaクライアント(TsubakuroやIceaxeのAPIを利用するアプリケーション)からは、接続セッションを構築するAPIで指定するエンドポイントにDockerコンテナのホストとポートを指定して接続してください。

### Tsurugi Dockerコンテナの様々な実行方法

#### Tsurugiのログレベル指定

環境変数 GLOG_xx 経由でログ設定を指定して起動します。

```sh
$ docker container run -d -p 12345:12345 --name tsurugi -e GLOG_v=30 ghcr.io/project-tsurugi/tsurugidb
```

#### 設定ファイルを指定

TsurugiサーバはDockerコンテナ上の `/usr/lib/tsurugi` 配下にインストールされています。
構成ファイルを指定して起動する場合、ホスト環境に用意した構成ファイルのディレクトリをボリュームマウントして起動します。

```sh
$ docker container run -d -v $HOME/tsurugi-conf:/usr/lib/tsurugi/var/etc --name tsurugi ghcr.io/project-tsurugi/tsurugidb
```
