# Tsurugi Getting Started

## Installation Environment

Currently, Tsurugi has been tested only in the following OS environment.

- Ubuntu-22.04
- Ubuntu-24.04 (Experimental support)

## Installation Instructions

### Installation archive

Tsurugi installation archives are available at GitHub Releases.

- https://github.com/project-tsurugi/tsurugidb/releases

Please open `Assets` of each release on the release page and download `tsurugidb-<version>.tar.gz`.

**Note: The `Source code (zip)` or `Source code (tar.gz)` in `Assets` are automatically generated links by GitHub, and these archives does not contain files needed for installation.**

Please extract the downloaded installation archive into any directory.
This is a working directory; the installation directory will be specified at another time during the installation procedure.

```sh
tar xf tsurugidb-<version>.tar.gz
```

### Installing libraries for runtime environment (apt package)

You can install the libraries required to install and run Tsurugi using `apt-install.sh`. This is included in the directory where you extracted the installation package.

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

If you execute `install.sh` without any arguments, it will put Tsurugi under the default installation path `/usr/lib/tsurugi-<tsurugi-version>`. In this case, it is usually needed to run with superuser privileges.

#### Miscellaneous Installation Options

- `--parallel=<jobs>` Specifies the maximum number of parallel jobs for the build process to run during installation.

  If you face problems such as insufficient memory during installation sequence, setting this to a low value may get around the problem. If it is not specified, the value is set to (number of logical cores + 2) of the installation environment.

  ```sh
  ./install.sh --parallel=8
  ```

### Setting the `TSURUGI_HOME` environment variable

After the Tsurugi installation is complete, please set the environment variable `TSURUGI_HOME` to the Tsurugi installation path.
If you installed with the previous example of running the installation script (`. /install.sh --prefix=$HOME/opt --symbolic`), set `TSURUGI_HOME` as follows.

```sh
export TSURUGI_HOME="$HOME/opt/tsurugi"
```

The environment variable `TSURUGI_HOME` is used by client libraries and utilities provided by Tsurugi.
If you use them, set `TSURUGI_HOME` to your shell environment and so on.

## Fundamental features of Tsurugi

This section introduces commands that provide fundamental Tsurugi capabilities such as starting/stopping Tsurugi server, executing SQL against Tsurugi server, etc.

The subsequent commands are located in the `bin` directory of the install directory.

### `tgctl` : Tsurugi server administration command

The `tgctl` command is an administration command to start, stop, and check the status of the Tsurugi server.

`tgctl start` starts Tsurugi server.

```sh
$ $TSURUGI_HOME/bin/tgctl start
...
successfully launched tsurugidb
```

You can check the status of the Tsurugi server with `tgctl status`.

```sh
$ $TSURUGI_HOME/bin/tgctl status
Tsurugi OLTP database is RUNNING
```

`tgctl shutdown` will stop the Tsurugi server.

```sh
$ $TSURUGI_HOME/bin/tgctl shutdown
...
successfully shutdown tsurugidb
```

### `tgsql` Tsurugi SQL console

The `tgsql` command is a CLI tool for submitting queries to Tsurugi.
Using this, you can connect to Tsurugi using one of the following connection protocols.

- IPC connections: relatively fast, but only from the same computer as the Tsurugi server.
- TCP connections: relatively slow, but can be connected from a remote computer.

An example of using an IPC connection is described below:

```sh
$ $TSURUGI_HOME/bin/tgctl start
successfully launched tsurugidb

$ $TSURUGI_HOME/bin/tgsql -c ipc:tsurugi

[main] INFO com.tsurugidb.console.core.ScriptRunner - establishing connection: ipc:tsurugi
[main] INFO com.tsurugidb.console.core.ScriptRunner - start repl
tgsql>
```

`tgsql>` prompt will appear, and you can enter any query here:

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

### Tsurugi Server Configuration

The Tsurugi server configuration is described in the "configuration file" located in `var/etc/tsurugi.ini` under the Tsurugi installation directory.

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

After editing the settings, you need to restart the Tsurugi server for the settings to take effect.
Please refer to the following for each setting item.

- Configuration file parameters
  - https://github.com/project-tsurugi/tateyama/blob/master/docs/config_parameters.md

## External interfaces for Tsurugi

Tsurugi provides various external interface mechanisms such as programming APIs, REST interfaces, and other database integration.

### `Iceaxe` Java API for application development

[Iceaxe](https://github.com/project-tsurugi/iceaxe) is a Java API for developing client applications using Tsurugi.
It is designed to facilitate the use of Tsurugi-specific functions with an API structure that is different from the JDBC interface.

- Iceaxe:
  - https://github.com/project-tsurugi/iceaxe
- Iceaxe Exmaples:
  - https://github.com/project-tsurugi/iceaxe/tree/master/modules/iceaxe-examples/src/main/java/com/tsurugidb/iceaxe/example

We have also published batch applications developed with Iceaxe for benchmarking purposes:

- Cost Accounting Benchmark:
  - https://github.com/project-tsurugi/cost-accounting-benchmark
- Phone Bill Benchmark
  - https://github.com/project-tsurugi/phone-bill-benchmark

### `Tsubakuro` low-level Java API

[Tsubakuro](https://github.com/project-tsurugi/tsubakuro) is a low-level Java API to maximize Tsurugi's capabilities.
Most of them are provided as asynchronous APIs, which are not convenient APIs but useful for development that needs to maximize Tsurugi's performance.

- Tsubakuro:
  - https://github.com/project-tsurugi/tsubakuro
- Tsubakuro Exmaples:
  - https://github.com/project-tsurugi/tsubakuro-examples

### `Belayer` Operations Management Interface

[Belayer](https://github.com/project-tsurugi/belayer-webapi) provides administrative functions through a REST interface, such as backup, restore, data dump, and data load.
We also provide GUI, command line tools, etc. as proprietary add-on modules.

- Belayer:
  - https://github.com/project-tsurugi/belayer-webapi
- Belayer Web API:
  - https://github.com/project-tsurugi/belayer-webapi/blob/master/docs/belayer_if_webapi-ja.md

### `Tsurugi_FDW` PostgreSQL Collaboration Interface

[Tsurugi_FDW](https://github.com/project-tsurugi/tsurugi_fdw) works with [PostgreSQL](https://www.postgresql.org/) by using PostgreSQL's foreign data wrapper functions.
This enables database operations on Tsurugi via utilities and interfaces provided by PostgreSQL, such as `psql`.

- Tsurugi_FDW:
  - https://github.com/project-tsurugi/tsurugi_fdw

### `Tanzawa` Tsurugi SQL Console

This module provides the `tgsql` command mentioned above.
It is bundled with Tsurugi installer and also provided as a stand-alone release archive. You can also install this on another computer and operate Tsurugi via a TCP connection.

- Tanzawa:
  - https://github.com/project-tsurugi/tanzawa
