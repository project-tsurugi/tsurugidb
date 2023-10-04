# Tsurugi - next generation RDB for the new era

Tsurugi is an open-source relational database system designed for modern computer architectures that have hundreds of CPU cores and huge memory capacity.
It focused for the following features:

1. Designed for a Many-Core/In-Memory Environment
2. Ensuring Consistency
3. Simultaneous Use of Multiple Interfaces
4. Component-Based Architecture
5. Excellence in Batch Processing and Long Transactions
6. Developed as Open Source

More: [about.md](about.md)

## Limitations

The latest version is **BETA** release.
This includes the below significant limitations as below:

* Default commit setting does not guarantee the committed data are durable, they will be saved to disks a short time after (about tens to hundreds of milliseconds)

  * You can change this setting ([tsurugi.ini](dist/install/conf/tsurugi.ini)) by `commit_response` in `[sql]` section. The current setting is `AVAILABLE` (committed data is visible for other transactions), and we planed it to be `STORED` (committed data has been saved on the local disk).

* Available SQL features are very limited, please see [available feature list](docs/sql-features.md).
* User control does not work, including authentications and authorizations.

## Getting started

See [getting-started.md](docs/getting-started.md).

## Sub projects

### Transaction engine

* [shirakami](https://github.com/project-tsurugi/shirakami)

  Concurrency control system

* [yakushima](https://github.com/project-tsurugi/yakushima)

  In-memory index

* [limestone](https://github.com/project-tsurugi/limestone)

  Data store for transaction logs

* [sharksfin](https://github.com/project-tsurugi/sharksfin)

  KVS adapter for transaction engine

### SQL execution engine

* [jogasaki](https://github.com/project-tsurugi/jogasaki)

  SQL job scheduler and interpreter

* [mizugaki](https://github.com/project-tsurugi/mizugaki)

  SQL compiler front-end including SQL parser

* [yugawara](https://github.com/project-tsurugi/yugawara)

  SQL semantic analyzer and optimizer

* [takatori](https://github.com/project-tsurugi/takatori)

  SQL intermediate representations and utilities

* [shakujo](https://github.com/project-tsurugi/shakujo)

  Legacy implementation of SQL compiler

### Database framework

* [tateyama](https://github.com/project-tsurugi/tateyama)

  Database component framework including messaging service

* [tateyama-bootstrap](https://github.com/project-tsurugi/tateyama-bootstrap)

  Database service bootstrap

### Database clients

* [tsubakuro](https://github.com/project-tsurugi/tsubakuro)

  Client library (Java)

* [tanzawa](https://github.com/project-tsurugi/tanzawa)

  SQL console (Java)
  
* [ogawayama](https://github.com/project-tsurugi/ogawayama)

  Communication library for PostgreSQL

### Peripherals

* [message-manager](https://github.com/project-tsurugi/message-manager)

  A message broker between PostgreSQL and Tsurugi, using ogawayama

* [metadata-manager](https://github.com/project-tsurugi/metadata-manager)

  Manages Tsurugi meta-data in PostgreSQL

* [harinoki](https://github.com/project-tsurugi/harinoki)

  Tiny authentication service

## Resources

* [Tsurugi Community Site (ja)](https://www.tsurugidb.com/)

## Bug reports

* Please report any issues to [repository for issue tracking](https://github.com/project-tsurugi/tsurugidb/issues)

## License

* [Apache License, Version 2.0](http://www.apache.org/licenses/LICENSE-2.0)
