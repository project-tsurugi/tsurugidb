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

### Too many open files

`tgctl start` fails, and the server log shows the following messages.

```sh

$ $TSURUGI_HOME/bin/tgctl start
E... sortdb_wrapper.h:86] /:limestone:api:sortdb_wrapper:put sortdb put error, status: IO error: While open a file for appending: /path/to/tsurugi/var/data/log/sorting/000082.sst: Too many open files
I... dblog_scan.cpp:216] /:limestone catch runtime_error(error in sortdb put)
I... datastore_snapshot.cpp:115] /:limestone:internal:create_sortdb_from_wals failed to scan pwal files: error in sortdb put
E... datastore_snapshot.cpp:116] /:limestone recover process failed. (cause: corruption detected in transaction log data directory), see https://github.com/project-tsurugi/tsurugidb/blob/master/docs/troubleshooting-guide.md
E... datastore_snapshot.cpp:118] /:limestone dblogdir (transaction log directory): "/path/to/tsurugi/var/data/log"
E... transactional_kvs_resource.cpp:89] opening database failed
E... server.cpp:98] Server application framework setup phase failed.
E... backend.cpp:176] Starting server failed due to errors in setting up server application framework.
could not launch tsurugidb, as tsurugidb exited due to some error.

```

#### Possible Cause or Solution

When starting tsurugidb, a large number of files may be temporarily created if the transaction log is very large.
If the maximum number of open files in the OS configuration is exceeded, the startup will fail with the error described above.

To resolve this, set the maximum number of open files in the OS to an appropriate value. This can be set using the `ulimit` command, `limits.conf` or by changing the systemd configuration.
For more information, refer to the documentation of the operating system you are using.

## Fail to shutdown tsurugidb

This section provides information about troubleshooting when tsurugidb failed to shutdown or shutdown does not finish.

*To be written.*

## Fail to connect to tsurugidb

This section provides information about troubleshooting on failed connections from client libraries and client CLI tools.

*To be written.*

## Fail to execute query

### Buffer overflow in IPC endpoint

#### Problem or Error

SELECT query fails with the following error message:

```
com.tsurugidb.tsubakuro.sql.exception.SqlExecutionException:
SQL-02000: an error occurred in writing output records, possibly due to buffer overflow in endpoint
```

#### Possible Cause or Solution

For communication on the IPC endpoint, the maximum size of the Resultset, which stores the data resulting from the execution of the SELECT clause, is limited by the `ipc_endpoint.datachannel_buffer_size` (KB) in `tsurugi.ini`.

- https://github.com/project-tsurugi/tsurugidb/blob/master/docs/config-parameters.md

If the size of the Resultset exceeds the value of `ipc_endpoint.datachannel_buffer_size`, the error occurs with message above.

To resolve this issue, increase the `ipc_endpoint.datachannel_buffer_size` in `tsurugi.ini` to a value sufficient to store the Resultset and restart tsurugidb.

Note that an IPC-connected session statically consumes approximately the amount of shared memory determined by the product of `ipc_endpoint.datachannel_buffer_size` and `ipc_endpoint.max_datachannel_buffers`; see the following document for more information on shared memory consumption when using IPC endpoints.

- https://github.com/project-tsurugi/tateyama/blob/master/docs/internal/shared-memory-usage_ja.md (ja)
