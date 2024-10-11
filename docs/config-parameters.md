# Configuration file parameters

The Tsurugi configuration parameters can be set in the following ini file format.

```
[section]
parameter=value
```

Below is a list of parameters supported for each section.

## `datastore` section

Target component
  - Data store
  - Transactional KVS (shirakami)

| Parameter name | Type | Value | Remarks |
|---:| :---: | :--- |---|
| `log_location` | String | Path to the directory where the log is stored | This is a required parameter, and if it is not set, DB fails to start. |

## `cc` section

Target component
  - Transactional KVS (shirakami)

| Parameter name | Type | Value | Remarks |
|---:| :---: | :--- |---|
| `epoch_duration` | Integer | Length of the epoch (us). The default is 3000. |
| `waiting_resolver_threads` | Integer | Number of threads that process the waiting and pre-commit of the LTXs in the waiting list. Default is 2. |

## `sql` section

Target component
  - SQL Service Resource (jogasaki)

| Parameter name | Type | Value | Remarks |
|---:| :---: | :--- |---|
| `commit_response` | String | Default value for commit waiting. Select one of the following: (`ACCEPTED`, `AVAILABLE`, `STORED`, `PROPAGATED`). The default is `STORED`. These symbols indicate the point in time until when the server delays notifying client of commit result. <ul><li>`ACCEPTED`: commit operation has been accepted, and then the transaction will never abort except system errors. </li><li>`AVAILABLE`: commit data has been visible for others. </li><li>`STORED`: commit data has been saved on the local disk. </li><li>`PROPAGATED`: commit data has been propagated to the all suitable nodes.</ul> | By explicitly specifying it at commit from the client, the above setting can be overwritten for each transaction. |
| `default_partitions` | Integer | Number of partitions when data is divided for parallelizable relational operators. The default value is 5. |
| `lowercase_regular_identifiers` | Boolean (true/false) | Whether to convert table and column names into lowercase internally. The default value is false.||
| `stealing_enabled` | Boolean (true/false) | Whether the scheduler steals tasks to utilize idle CPU cores. The default value is true. |
| `thread_pool_size` | Integer | Number of threads used by the task scheduler in the SQL service. The default value is set according to the environment by the following formula. <ul><li>`MIN(<default worker coefficient> * <number of physical cores>, <maximum default worker count>)` </li><li>If the result is less than 1, it is set to 1. </li><li>the `<default worker coefficient>` is 0.8 </li><li>the `<maximum default worker count>` is 32.</ul> |
| `scan_block_size` | Integer | The maximum number of scan operator records processed before yielding to other tasks. The default limit is 100 records. If set to 0, this limit is removed. The scan operator processes either the entire table or a specific range of data. This parameter is intended to prevent the thread from becoming unresponsive when the number of scan operator records is too large. |
| `scan_yield_interval` | Integer | The maximum millisecond time of scan operator processing records before yielding to other tasks. The default is 1. If the value of this option is set to 0, the decision to split will rely solely on the value of scan_block_size. When using this option, it is recommended to keep the scan_block_size at its default value. If the scan_block_size is set to an extremely large value, the actual split occur after a time that significantly exceeds the specified value. |

## `ipc_endpoint` section

Target component
  - ipc_endpoint(tateyama)

| Parameter name | Type | Value | Remarks |
|---:| :---: | :--- |---|
| `admin_sessions` | Integer | Number of sessions for management commands (`tgctl`). The default value is 1. | The maximum number of sessions for management commands that can be specified is 255, which is separate from the normal maximum number of sessions specified in threads.
| `database_name` | String | Database name in the IPC endpoint URI (`ipc:<database-name>`). The default value is `tsurugi`. | This string is used as a prefix for the file created in `/dev/shm`. |
| `datachannel_buffer_size` | Integer | Buffer size of data channel, used for transferring result sets of queries, in KB. The default value is 64. | The maximum raw size that can be handled by ipc is datachannel_buffer_size-4B. |
| `max_datachannel_buffers` | Integer | Number of writers that can be used simultaneously in one session. The default value is 256. | This parameter is the upper limit for the session, not the entire system (database instance).
| `threads` | Integer | Maximum number of simultaneous connections to ipc_endpoint. The default value is 104. |

## `stream_endpoint` section

Target component
  - stream_endpoint(tateyama)

| Parameter name | Type | Value | Remarks |
|---:| :---: | :--- |---|
| `enabled` | Boolean (true/false) | Enable or disable stream_endpoint when tsurugidb starts. The default value is false (disabled at start).
| `port` | Integer | TCP port number to connect to stream_endpoint. The default value is 12345. |
| `threads` | Integer | Maximum number of simultaneous connections to stream_endpoint. The default value is 104. |

## `session` section

Target component
  - All tateyama components that use sessions

| Parameter name | Type | Value | Remarks |
|---:| :---: | :--- |---|
| `enable_timeout` | Boolean (true/false) | Enable or disable automatic session timeout. The default value is true (enabled). |
| `max_refresh_timeout` | Integer | Maximum value of the lifetime extension time of the session by explicit request (seconds). The default value is 10800. |
| `refresh_timeout` | Integer | Lifetime extension time (seconds) of the session by communication. The default value is 300. |
| `zone_offset` | String | An ISO8601-defined string specifying the default time zone offset for the session (in the format `±hh:[mm]`, `Z`, etc.) The default value is a string indicating UTC. |


## `system` section

Target component
  - tateyama-bootstrap

| Parameter name | Type | Value | Remarks |
|---:| :---: | :--- |---|
| `pid_directory` | String | Temporary directory location to create lock files such as .pid files (see [process mutex](https://github.com/project-tsurugi/tateyama/blob/master/docs/process-mutex-ja.md)). The default value is /var/lock. | If you run multiple tsurugidb instances on the same server, you need to set the same value for this parameter in the configuration file of all tsurugidb instances. |

## `glog` section

Target component
  - glog (logger)

| Parameter name | Type | Value | Remarks |
|---:| :---: | :--- |---|
| `logbuflevel` | Number | Threshold of log level to buffer. Logs with level below this value are buffered. The default value is 0 (equivalent to INFO). |
| `logtostderr` | Boolean (true/false) | Output all messages to standard error output instead of the log file. The default value is false. |
| `log_dir` | String | Directory where log files are output. The default is unspecified (output to the default directory of glog). |
| `max_log_size` | Integer | Maximum size of log file (unit MB). The default value is 1800. |
| `minloglevel` | Integer | Log level to output. The default value is 0 (equivalent to INFO). |
| `stderrthreshold` | Integer | Threshold of log level to output to standard error output. The default value is 2 (equivalent to ERROR). |
| `v` | Number | Level of detailed logs to output. The default value is 0 (do not output). |

The default values of parameters that can be set in the glog section are the same as the default values of glog.

## specifying relative path for directory parameters

If a relative path is set in the parameter that specifies the directory, it is resolved as a relative path from the environment variable `TSURUGI_HOME`.
If the environment variable `TSURUGI_HOME` is not set, the relative path cannot be resolved, and the tsurugidb startup fails.
If all directories are specified by absolute paths, the setting of the environment variable `TSURUGI_HOME` does not affect the startup of tsurugidb.
