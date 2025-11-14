# Tsurugi - next generation RDB for the new era

Tsurugi is an open-source relational database system designed for modern computer architectures that have hundreds of CPU cores and huge memory capacity.
It focuses on the following features:

1. Designed for a Many-Core/In-Memory Environment
2. Ensuring Consistency
3. Simultaneous Use of Multiple Interfaces
4. Component-Based Architecture
5. Excellence in Batch Processing and Long Transactions
6. Developed as Open Source

* More: [about.md](about.md)
* More: Detailed Information is offered in the Handbook (only in Japanese)
  * https://nkbp.jp/lin-tsurugi

## Getting started

* Installation
  * [Tsurugi Getting Started](docs/getting-started.md) ([日本語版](docs/getting-started_ja.md))
* Use official Docker Image
  * [Tsurugi Docker User Guide](docs/docker-tsurugi.md) ([日本語版](docs/docker-tsurugi_ja.md))

## Client Libraries

* **Java - Tsurugi-specific API**
  * [Iceaxe](https://github.com/project-tsurugi/iceaxe) - High-Level Java API
  * [Tsubakuro](https://github.com/project-tsurugi/tsubakuro) - Low-Level Java API
* **Java - JDBC Driver**
  * [Tsurugi JDBC](https://github.com/project-tsurugi/tsurugi-jdbc) - JDBC Driver
* **Java - ORM Integration**
  * [Tsurugi Hibernate](https://github.com/project-tsurugi/tsurugi-jdbc/tree/master/modules/tsurugi-hibernate) - Hibernate ORM Dialect
* **Rust**
  * [tsubakuro-rust-core](https://github.com/project-tsurugi/tsubakuro-rust/tree/master/tsubakuro-rust-core) - Rust API ([crates.io](https://crates.io/crates/tsubakuro-rust-core))
* **C**
  * [tsubakuro-rust-ffi](https://github.com/project-tsurugi/tsubakuro-rust/tree/master/tsubakuro-rust-ffi) - C API (Rust FFI bindings to C)
* **ODBC Driver**
  * [Tsurugi ODBC Driver](https://github.com/project-tsurugi/tsubakuro-rust/tree/master/tsubakuro-rust-odbc) - ODBC Driver ([Installer](https://github.com/project-tsurugi/tsubakuro-rust/releases))

## Tools and Integrations

* **Basic CLI**
  * [tgctl](docs/cli/tgctl_ja.md) - Database management tool for Tsurugi
  * [tgsql](docs/cli/tgsql_ja.md) - SQL console for Tsurugi
  * [tgdump](docs/cli/tgdump_ja.md) - Database dump tool for Tsurugi
* **UDF**
  * Coming soon...
* **Web Admin API**
  * [Belayer Web-API](https://github.com/project-tsurugi/belayer-webapi) - Web Administration API for Tsurugi
* **PostgreSQL Integration**
  * [tsurugi-fdw](https://github.com/project-tsurugi/tsurugi_fdw) - PostgreSQL Foreign Data Wrapper for Tsurugi
* **MCP**
  * [Tsurugi MCP Server](https://github.com/project-tsurugi/tsurugi-mcp-server) - MCP Server for Tsurugi

## Documentation

* Runtime Environments
  * [Supported Platforms](docs/supported-platforms.md)
* Supported SQL
  * [Available SQL features in Tsurugi](docs/sql-features.md)
* Configuration
  * [Configuration file parameters](docs/config-parameters.md)
* Authentication and Authorization
  * [Tsurugi User Authentication and Table Permissions (ja)](docs/auth-overview_ja.md)
* Additional Resources
  * [docs](docs/) directory contains more documents.
  * [GitHub Discussions](https://github.com/project-tsurugi/tsurugidb/discussions) provides release information and additional guidance documents for release features.
  * [Sub projects](#sub-projects) have their own `docs` directories with detailed information for each component.

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

### Peripherals

* [harinoki](https://github.com/project-tsurugi/harinoki)
  Tiny authentication service

## Resources

* [Tsurugi Community Site (ja)](https://www.tsurugidb.com/)
* [note (ja)](https://note.com/n_technologies/m/m88508b206159)

## Contributing

* Please report any issues to [repository for issue tracking](https://github.com/project-tsurugi/tsurugidb/issues)

* For any other questions or feedback, please post to [tsurugidb discussions forum](https://github.com/project-tsurugi/tsurugidb/discussions)

* This repository is a collection of submodules of each [Sub projects](#sub-projects). Therefore, please send Pull Request to the repository of [Sub projects](#sub-projects), not to this repository.

## License

* [Apache License, Version 2.0](http://www.apache.org/licenses/LICENSE-2.0)
