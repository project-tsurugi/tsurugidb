# Tsurugi Getting Started

## Installation Environment

The following document describes the requirements for the environment in which Tsurugi is installed.

* [Supported Platforms](./supported-platforms.md)

## Installation Instructions

### Downloading the Installation archive

Tsurugi installation archives are available at GitHub Releases.

- https://github.com/project-tsurugi/tsurugidb/releases

Please open `Assets` of each release on the release page and download `tsurugidb-<version>.tar.gz`.

**Note: The `Source code (zip)` or `Source code (tar.gz)` in `Assets` are automatically generated links by GitHub, and these archives does not contain files needed for installation.**

Please extract the downloaded installation archive into any directory.
This is a working directory; the installation directory will be specified at another time during the installation procedure.

```sh
tar xf tsurugidb-<version>.tar.gz
cd tsurugidb-<version>
```

### Running the Installer (Ubuntu)

This section describes the installation procedure on Ubuntu.

#### Running the apt package installation script

You can install the libraries required to install and run Tsurugi using `apt-install.sh`. This is included in the directory where you extracted the installation package.

```sh
sudo ./apt-install.sh
```

`apt-install.sh` must be run as superuser or via the `sudo` command, in order to install the required packages using `apt-get update` or `apt-get install`.

#### Running the Tsurugi installation script

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

### Running the Installer (AlmaLinux, Rocky Linux)

This section describes the installation procedure on AlmaLinux and Rocky Linux.

> [!IMPORTANT]
> Currently, support for AlmaLinux and Rocky Linux is provided as an experimental feature.

#### Enabling the EPEL Repository

Some packages required for installation on AlmaLinux and Rocky Linux are installed from the EPEL repository.
Therefore, you must first enable the EPEL repository.

If the EPEL repository is not enabled in your environment, run `dist/install/dnf-enable-epel.sh` included in the root of the extracted installation package to enable it.

Since `dnf-enable-epel.sh` uses `dnf update` and `dnf install` to install the required packages, it must be run as a superuser or via the `sudo` command.
Also, the settings enabled by this script will remain after installation.
Because this may affect your installation environment, it is strongly recommended to review the script contents before executing it.

```sh
sudo ./dist/install/dnf-enable-epel.sh
```

For more information about the EPEL repository, refer to your OS documentation.
For AlmaLinux, see:
- https://wiki.almalinux.org/repos/Extras.html#epel

#### Running the dnf package installation script

Use the `dist/install/dnf-install.sh` script included in the root of the extracted installation package to install the libraries required to install and run Tsurugi.

```sh
sudo ./dist/install/dnf-install.sh
```

Since `dnf-install.sh` uses `dnf update` and `dnf install` to install the required packages, it must be run as a superuser or via the `sudo` command.
Because this may affect your installation environment, it is strongly recommended to review the script contents before executing it.

#### Running the Tsurugi installation script

> [!IMPORTANT]
> Currently, Tsurugi has been tested on AlmaLinux and Rocky Linux version 9 series, but due to known issues with GCC included in these distributions, performance problems may occur if Tsurugi is installed using GCC.
> Therefore, it is recommended to use Clang for installation on AlmaLinux and Rocky Linux. The following instructions describe installation using Clang.

Run the installation script `install.sh` included in the source archive to build the executable binary and install it to the directory specified by `--prefix=<install_directory>`.
The `--symbolic` option creates a symbolic link `tsurugi` in the installation path.

As described above, since installation on AlmaLinux and Rocky Linux should use Clang, specify the environment variables for Clang when running the installation script.

```sh
$ mkdir $HOME/opt
$ CC=clang CXX=clang++ ./install.sh --prefix=$HOME/opt --symbolic
...
------------------------------------
[Install Tsurugi successful]
Install Directory: $HOME/opt/tsurugi-1.x.x
------------------------------------

[WARNING] /var/lock/ is not set to 1777.
Tsurugi uses /var/lock/ as the default location to create the lock file at startup.
However, the permissions on /var/lock/ are currently not set to 1777, which prevents non-privileged users from writing to this directory.
If you are starting tsurugidb process as a non-privileged user, edit the system.pid_directory parameter in var/etc/tsurugi.ini accordingly.
```

If you install as a non-privileged user, you may see a warning at the end of installation if the `/var/lock/` directory permissions are not set to 1777 (this is the default on AlmaLinux and Rocky Linux).
If this warning appears, refer to the section "Changing the `pid_directory` setting" below and update the Tsurugi configuration accordingly.

If you run `install.sh` without any arguments, it will install under the default installation path `/usr/lib/tsurugi-<tsurugi-version>`. In this case, you usually need to run it with superuser privileges.

> [!Note]
> If the installation fails with a build error like the example below, see the following document for how to resolve this:
> - https://github.com/project-tsurugi/tsurugidb/blob/master/docs/troubleshooting-guide.md#fail-to-install-with-clang-19
> ```
>  [Install Mizugaki]
>  -- The C compiler identification is Clang 19.1.7
>  -- The CXX compiler identification is Clang 19.1.7
>  ...
>  FAILED: src/CMakeFiles/mizugaki.dir/mizugaki/analyzer/details/analyze_type.cpp.o
>  /usr/bin/clang++ -DBOOST_ALL_NO_LIB -DBOOST_ENABLE_ASSERT_DEBUG_HANDLER -DBOOST_STACKTRACE_BASIC_DYN_LINK -Dmizugaki_EXPORTS -I/tmp/tsurugidb-1.4.0/mizugaki/src -I/tmp/tsurugidb-1.4.0/mizugaki/build/src -I/tmp/tsurugidb-1.4.0/mizugaki/include -isystem /usr/lib/tsurugi-1.4.0/include/takatori -isystem /usr/lib/tsurugi-1.4.0/include/yugawara -isystem /usr/lib/tsurugi-1.4.0/include -march=native -Wall -Wextra -Werror -O2 -g -std=c++17 -fPIC -MD -MT src/CMakeFiles/mizugaki.dir/mizugaki/analyzer/details/analyze_type.cpp.o -MF src/CMakeFiles/mizugaki.dir/mizugaki/analyzer/details/analyze_type.cpp.o.d -o src/CMakeFiles/mizugaki.dir/mizugaki/analyzer/details/analyze_type.cpp.o -c /tmp/tsurugidb-1.4.0/mizugaki/src/mizugaki/analyzer/details/analyze_type.cpp
>  /tmp/tsurugidb-1.4.0/mizugaki/src/mizugaki/analyzer/details/analyze_type.cpp:375:42: error: a template argument list is expected after a name prefixed by the template keyword [-Wmissing-template-arg-list-after-template-kw]
>    375 |         return context_.types().template get(std::forward<Type>(type));
>  ...
>  ninja: build stopped: subcommand failed.
> ```

#### Changing the `pid_directory` setting

Tsurugi creates a process lock file in the directory specified by the `pid_directory` setting in the Tsurugi configuration file `tsurugi.ini` for process monitoring and preventing multiple instances.

The default value of `pid_directory` is `/var/lock/`, but with the default permissions on AlmaLinux and Rocky Linux, general users cannot create lock files in this directory.
If you want to run Tsurugi as a non-privileged user, you need to change the value of `pid_directory`.

To change the value of `pid_directory`, edit the configuration file `var/etc/tsurugi.ini` under the Tsurugi installation directory.
Uncomment the `pid_directory` line and specify any directory as an absolute path.

```ini
[system]
    pid_directory=/opt/tsurugi/var/lock
```

Then, change the permissions so that the user running Tsurugi has write access to `/opt/tsurugi/var/lock`.

```sh
sudo mkdir -p /opt/tsurugi/var/lock
sudo chmod 1777 /opt/tsurugi/var/lock
```

#### Installation Options for troubleshooting

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
tgsql> INSERT INTO tb1(pk, c1) VALUES(1,100);
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
# https://github.com/project-tsurugi/tsurugidb/blob/master/docs/config-parameters.md

[datastore]
    log_location=var/data/log

[cc]
    #epoch_duration=3000
    #waiting_resolver_threads=2
    ...
```

After editing the settings, you need to restart the Tsurugi server for the settings to take effect.
Please refer to the following for each setting item.

- Configuration file parameters
  - https://github.com/project-tsurugi/tsurugidb/blob/master/docs/config-parameters.md

## External interfaces for Tsurugi

Tsurugi provides various external interface mechanisms such as programming APIs, REST interfaces, and other database integration.

### `Iceaxe` Java API for application development

[Iceaxe](https://github.com/project-tsurugi/iceaxe) is a Java API for developing client applications using Tsurugi.
It is designed to facilitate the use of Tsurugi-specific functions with an API structure that is different from the JDBC interface.

- Iceaxe:
  - https://github.com/project-tsurugi/iceaxe
- Iceaxe Examples:
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
- Tsubakuro Examples:
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
