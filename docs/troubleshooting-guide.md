# Tsurugi Troubleshooting Guide

- [Fail to install Tsurugi](#fail-to-install-tsurugi)
- [Fail to upgrade Tsurugi](#fail-to-upgrade-tsurugi)
- [Fail to start tsurugidb](#fail-to-start-tsurugidb)
- [Fail to shutdown tsurugidb](#fail-to-shutdown-tsurugidb)
- [Fail to connect to tsurugidb](#fail-to-connect-to-tsurugidb)

## Fail to install Tsurugi

This section provides information about troubleshooting the Tsurugi install.

*To be written.*

## Fail to upgrade Tsurugi

Please see the following documentation.

- https://github.com/project-tsurugi/tsurugidb/blob/master/docs/upgrade-guide.md#trouble-shooting

## Fail to start tsurugidb

This section provides information about troubleshooting when tsurugidb failed to start.

### Corrupted transaction log

#### Problem or Error

 `tgctl start` command fails with the following error message:

```sh

$ $TSURUGI_HOME/bin/tgctl start
E... dblog_scan.cpp:92] /:limestone:internal:log_error_and_throw this pwal file is broken: unknown log_entry type 0
E... datastore_snapshot.cpp:120] /:limestone recover process failed. (cause: corruption detected in transaction log data directory), see https://github.com/project-tsurugi/tsurugidb/blob/master/docs/troubleshooting-guide.md
E... datastore_snapshot.cpp:122] /:limestone dblogdir (transaction log directory): "/path/to/tsurugi/var/data/log"
E... transactional_kvs_resource.cpp:89] opening database failed
E... server.cpp:98] Server application framework setup phase failed.
E... backend.cpp:176] Starting server failed due to errors in setting up server application framework.
could not launch tsurugidb, as tsurugidb exited due to some error.

```

#### Possible Cause or Solution

The transaction log may have been corrupted because tsurugidb did not shut down properly. To repair the transaction log, run the  `tglogutil repair` command with dblogdir that is shown in the error log on the line with `/:limestone dblogdir (transaction log directory):`.

```sh
$ $TSURUGI_HOME/bin/tglogutil repair /path/to/tsurugi/var/data/log
dblogdir: "var/data/log/"
durable-epoch: 9083
status: OK
```

If `tglogutil repair` succeeds, tsurugidb can be started by `tgctl start`.

For more information of `tglogutil repair`, please see the following documentation.
- https://github.com/project-tsurugi/limestone/blob/master/docs/tglogutil-repair-man.md

## Fail to shutdown tsurugidb

This section provides information about troubleshooting when tsurugidb failed to shutdown or shutdown does not finish.

*To be written.*

## Fail to connect to tsurugidb

This section provides information about troubleshooting on failed connections from client libraries and client CLI tools.

*To be written.*
