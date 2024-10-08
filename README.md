# Tsurugi - next generation RDB for the new era

Tsurugi is an open-source relational database system designed for modern computer architectures that have hundreds of CPU cores and huge memory capacity.
It focused for the following features:

1. Designed for a Many-Core/In-Memory Environment
2. Ensuring Consistency
3. Simultaneous Use of Multiple Interfaces
4. Component-Based Architecture
5. Excellence in Batch Processing and Long Transactions
6. Developed as Open Source

- More: [about.md](about.md)
- More : Detailed Information is offered in the Handbook (only in Japanese)
  - https://nkbp.jp/lin-tsurugi

## Getting started

* Installation
  * [Tsurugi Getting Started](docs/getting-started.md)
    * [Tsurugi Getting Started (ja)](docs/getting-started_ja.md)
* Use official Docker Image
  * [Tsurugi Docker User Guide](docs/docker-tsurugi.md)
    * [Tsurugi Dockerユーザガイド (ja)](docs/docker-tsurugi_ja.md)

## Documentation

* Runtime Environments
  * [Supported Platforms](docs/supported-platforms.md)
* Support SQL
  * [Available SQL features in Tsurugi](docs/sql-features.md)
* External Interfaces
  * [External interfaces for Tsurugi](docs/getting-started.md#external-interfaces-for-tsurugi)
    * [Tsurugiが提供する外部インターフェース群 (ja)](docs/getting-started_ja.md#tsurugiが提供する外部インターフェース群)
* Miscellaneous
  * You can find more documents in the [docs](docs/) directory.
  * The `docs` directory of the [Sub projects](#sub-projects) contains detailed information for each component.

## Limitations

This includes the below significant limitations as below:

* User control does not work, including authentications and authorizations.

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

* [harinoki](https://github.com/project-tsurugi/harinoki)

  Tiny authentication service

## Resources

* [Tsurugi Community Site (ja)](https://www.tsurugidb.com/)
* [note (ja)](https://note.com/n_technologies/m/m88508b206159)

## Contributing

* Please report any issues to [repository for issue tracking](https://github.com/project-tsurugi/tsurugidb/issues)

* For any other questions or feedback, please post to [tsurugidb discussions forum](https://github.com/project-tsurugi/tsurugidb/discussions)

* This repository is a collection of submodules of each [Sub Project](#sub-projects). Therefore, please send Pull Reuqeset to the repository of [Sub project](#sub-projects), not to this repository.

## License

* [Apache License, Version 2.0](http://www.apache.org/licenses/LICENSE-2.0)
