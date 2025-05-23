# Tsurugi Troubleshooting Guide

- [Fail to install Tsurugi](#fail-to-install-tsurugi)
- [Fail to upgrade Tsurugi](#fail-to-upgrade-tsurugi)
- [Fail to start tsurugidb](#fail-to-start-tsurugidb)
- [Fail to shutdown tsurugidb](#fail-to-shutdown-tsurugidb)
- [Fail to connect to tsurugidb](#fail-to-connect-to-tsurugidb)
- [Fail to  execute query](#fail-to-execute-query)

## Fail to install Tsurugi

This section provides information about troubleshooting the Tsurugi install.

### Fail to install with Clang 19

#### Problem or Error

The installation fails with the following build error.

```
$ CC=clang CXX=clang++ ./install.sh
...
 [Install Mizugaki]
 -- The C compiler identification is Clang 19.1.7
 -- The CXX compiler identification is Clang 19.1.7
 ...
 FAILED: src/CMakeFiles/mizugaki.dir/mizugaki/analyzer/details/analyze_type.cpp.o
 /usr/bin/clang++ -DBOOST_ALL_NO_LIB -DBOOST_ENABLE_ASSERT_DEBUG_HANDLER BOOST_STACKTRACE_BASIC_DYN_LINK -Dmizugaki_EXPORTS -I/tmp/tsurugidb-1.4.0/mizugaki/src -I/tmp/urugidb-1.4.0/mizugaki/build/src -I/tmp/tsurugidb-1.4.0/mizugaki/include -isystem /usr/lib/urugi-1.4.0/include/takatori -isystem /usr/lib/tsurugi-1.4.0/include/yugawara -isystem /usr/b/tsurugi-1.4.0/include -march=native -Wall -Wextra -Werror -O2 -g -std=c++17 -fPIC -MD -MT c/CMakeFiles/mizugaki.dir/mizugaki/analyzer/details/analyze_type.cpp.o -MF src/CMakeFiles/zugaki.dir/mizugaki/analyzer/details/analyze_type.cpp.o.d -o src/CMakeFiles/mizugaki.dir/zugaki/analyzer/details/analyze_type.cpp.o -c /tmp/tsurugidb-1.4.0/mizugaki/src/mizugaki/alyzer/details/analyze_type.cpp
 /tmp/tsurugidb-1.4.0/mizugaki/src/mizugaki/analyzer/details/analyze_type.cpp:375:42: error: template argument list is expected after a name prefixed by the template keyword Wmissing-template-arg-list-after-template-kw]
   375 |         return context_.types().template get(std::forward<Type>(type));
 ...
 ninja: build stopped: subcommand failed.
```

#### Possible Cause or Solution

If you encounter the above error, please take the following steps:

1. Install `gcc-toolset-14-libatomic-devel` using `dnf`
  ```sh
  $ dnf install gcc-toolset-14-libatomic-devel
 ```
2. Execute `install.sh` with `-Wno-missing-template-arg-list-after-template-kw` to the `CXX` environment variable
  ```sh
  $ CC=clang CXX='clang++ -Wno-missing-template-arg-list-after-template-kw' ./install.sh
  ```

#### Compatible Versions of Clang and libatomic

The required version of libatomic to be installed depends on the version of Clang you are using. Please install the appropriate version of libatomic according to your Clang version.

- Clang 18: `gcc-toolset-13-libatomic-devel`
- Clang 19: `gcc-toolset-14-libatomic-devel`

Below are example commands to check the installed versions of Clang and libatomic using `dnf`.

```sh
$ dnf list --installed clang
Installed Packages
clang.x86_64                             19.1.7-2.el9      @appstream

$ dnf list --installed *libatomic-devel
Installed Packages
gcc-toolset-13-libatomic-devel.x86_64    13.3.1-2.3.el9    @appstream
```

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
