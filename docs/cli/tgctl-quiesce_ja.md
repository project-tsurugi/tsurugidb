# tgctl quiesce

## NAME

`tgctl quiesce` - Tsurugi データベースの静止状態での起動

## SYNOPSIS

```sh
tgctl quiesce [OPTIONS]
```

## DESCRIPTION

`tgctl quiesce` は、Tsurugi データベースを静止状態で起動するコマンドです。

## EXAMPLES

```sh
tgctl quiesce
```

## OPTIONS

このコマンドは以下のオプションをサポートします:

* `--conf </path/to/tsurugi.ini>` : 構成定義ファイルのパス
  * 起動する対象の Tsurugi インスタンスの構成定義ファイル (`tsurugi.ini`) を指定します
  * 未指定の場合は [デフォルトの構成定義ファイル](./tgctl_ja.md#構成定義ファイル) を使用します
* `--label <label>` : この操作のラベル
  * この操作に任意のラベルを付与します
  * 未指定の場合は、ラベルは付与されません

## NOTES

* 本コマンドは、Tsurugi インスタンスが未稼働の状態で利用可能です
* 本コマンドの実行に成功したとしても、必ずしも静止状態での起動が完了したことを意味しません
  * 必要に応じて [tgctl status](./tgctl-status_ja.md) コマンドを利用し、状態を確認してください
* この操作は、静止状態でのバックアップを作成する際に、データベースの一時的な静止状態を作り、他の操作によるバックアップ対象の破損を防ぐために存在します。主な用途は、バックアップの作成やメンテナンスなどです
  * 静止状態のデータベースは、 [`shutdown`](./tgctl-shutdown_ja.md), [`kill`](./tgctl-kill_ja.md), [`status`](./tgctl-status_ja.md) サブコマンドやそれに該当する機能のみ利用可能で、それ以外の操作はすべて禁止されています
  * 静止状態でバックアップを作成する際に、当該サブコマンドを実行します
    * 静止状態で起動中は、他のリストア操作などが一切行えません
    * 静止状態で起動中は、他のプロセスからデータベースを起動することもできないため、排他ロックのような扱いが可能です
  * 静止状態でのバックアップ作成が完了した後に [`shutdown` サブコマンド](./tgctl-shutdown_ja.md) で一度データベースを終了させてから、通常の起動を行ってください

## EXIT STATUS

* `0` : 正常にデータベースを静止状態で起動した
* その他 : エラー等によりTsurugi データベースを静止状態で起動できなかった

## SEE ALSO

* [`tgctl start`](./tgctl-start_ja.md)
* [`tgctl shutdown`](./tgctl-shutdown_ja.md)
* [`tgctl kill`](./tgctl-kill_ja.md)