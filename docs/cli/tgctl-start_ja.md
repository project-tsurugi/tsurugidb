# tgctl start

## NAME

`tgctl start` - Tsurugi データベースの起動

## SYNOPSIS

```sh
tgctl start [OPTIONS]
```

## DESCRIPTION

`tgctl start` は、Tsurugi データベースを起動するコマンドです。

## EXAMPLES

```sh
tgctl start
```

## OPTIONS

このコマンドは以下のオプションをサポートします:

* `--conf </path/to/tsurugi.ini>` : 構成定義ファイルのパス
  * 操作対象の Tsurugi インスタンスの構成定義ファイル (`tsurugi.ini`) を指定します
  * 未指定の場合は [デフォルトの構成定義ファイル](./tgctl_ja.md#構成定義ファイル) を使用します
* `--timeout <value>` : タイムアウト時間（秒）
  * データベースプロセスの起動を確認するまでの時間を指定します
  * 指定した時間内にデータベースの起動が確認できない場合、コマンドはエラーを返します (データベースの起動は継続して行われます)
  * `0` を指定すると、対象データベースの起動が成功するか、起動に失敗するまで制御を返しません
  * 未指定の場合、 `10` 秒に設定されます

<!--
-  [--recovery|--no-recovery]は未実装
-->

## NOTES

* 本コマンドは、Tsurugi インスタンスが未稼働の状態で利用可能です
* 本コマンドの実行に成功したとしても、必ずしもデータベースの起動に成功したことを意味しません
  * 必要に応じて [`tgctl status`](./tgctl-status_ja.md) コマンドを利用し、状態を確認してください
* データベース起動時にリカバリ操作が必要であれば自動的に行います

## EXIT STATUS

* `0` : 正常にTsurugi データベースを起動した
* その他 : エラー等によりTsurugi データベースを起動できなかった

## SEE ALSO

* [`tgctl shutdown`](./tgctl-shutdown_ja.md)
* [`tgctl kill`](./tgctl-kill_ja.md)
