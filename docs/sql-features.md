# Available SQL features in Tsurugi

In the latest release, Tsurugi SQL features are very limited.
The planned features are listed [here](#planned-features).

## Definitions (DDL)

* `CREATE TABLE <table> ...`
  * see [Table definition](#table-definition)
* `DROP TABLE <table>`
* `CREATE INDEX <index> ...`
  * see [Index definition](#index-definition)
* `DROP INDEX <index>`

----
note:

Concurrent execution of DML and DDL statements are not fully supported. 
DDL should be issued from single thread when there is no on-going DML processing for the target tables/indices. 

### Table definition

```txt
CREATE TABLE <table-name> (<table-element> [, <table-element> [, ...]])

<table-element>:
  <column-name> <type> [<column-constraints>]
  PRIMARY KEY ( <column-name> [, <column-name> [, ...]] )

<column-constraints>:
  NULL
  NOT NULL
  PRIMARY KEY
  DEFAULT <value>
```

* `<type>` - see [Types](#types)
* `<values>` - see [Literals](#literals)

----
note:

`CREATE TABLE ... AS SELECT ...` is not supported.

### Index definition

```txt
CREATE INDEX <index-name> ON <table-name> (<index-element> [, <index-element> [, ...]])

<index-element>:
  <column-name>
  <column-name> ASC
  <column-name> DESC
```

----
note:

Limitation: the target table must be empty when index is created on it.

## Statements (DML)

* `SELECT ...`
* `INSERT INTO <table> VALUES ...`
* `INSERT OR REPLACE INTO <table> VALUES ...`
  * This will put a row to the table even if the target row already exists (i.e. primary key conflicts)
  * Limitation: the target table must not have any secondary indices
* `INSERT IF NOT EXISTS INTO <table> VALUES ...`
  * This will put a row only if the target row doesn't exists. Unlike INSERT INTO statement, no error occurs even if target row exists.
* `UPDATE <table> SET ... WHERE ...`
* `DELETE FROM <table> WHERE ...`

----
note:

`INSERT INTO ... SELECT ...` is NOT available now. We are working to make this feature is available in nearby versions.

## Queries

* `SELECT [DISTINCT] <column-list>`
* `FROM <table>`
* `JOIN <table>`
  * `INNER JOIN`
  * `CROSS JOIN`
  * `LEFT OUTER JOIN`
  * `RIGHT OUTER JOIN`
* `WHERE <condition>`
* `ORDER BY <column-list>`
* `GROUP BY <column-list>`

----
note:

This version does not support sub-queries.

## Expressions

### Arithmetic expressions

* `a + b`
* `a - b`
* `a * b`
* `a / b`
* `a % b`
* `+a`
* `-a`

### Comparison expressions

* `a = b`
* `a <> b`
* `a < b`
* `a <= b`
* `a > b`
* `a >= b`

### Boolean expressions

* `a AND b`
* `a OR b`
* `NOT a`
* `a IS NULL`
* `a IS NOT NULL`

### Character string expression

* `a || b`

### Aggregation functions

* `COUNT(*)`
* `COUNT([DISTINCT|ALL] <expression>)`
* `SUM(<expression>)`
* `MAX(<expression>)`
* `MIN(<expression>)`
* `AVG(<expression>)`

### Cast conversions

* `(CAST x AS <type>)`
  * see [Types](#types)
  * supported conversions:
    * `CHAR`/`VARCHAR` -> `INT`
    * `CHAR`/`VARCHAR` -> `BIGINT`
    * `CHAR`/`VARCHAR` -> `REAL`
    * `CHAR`/`VARCHAR` -> `DOUBLE`
    * `CHAR`/`VARCHAR` -> `DECIMAL`

## Types

* `INT`
* `BIGINT`
* `REAL`
* `DOUBLE PRECISION` (`DOUBLE`)
* `DECIMAL(p [, s])` ( `p` >= `s` )
  * `p` - number of digits (precision, `1~38` or `*` to use the max precision)
  * `s` - number of decimal places (scale, `0~p` or zero when omitted)
* `CHAR(s)`
  * `s` - number of **octets** in UTF-8
* `VARCHAR(s)`
  * `s` - maximum number of **octets** in UTF-8, or `*` to ensure maximum capacity
* `DATE`
* `TIME`
* `TIME WITH TIME ZONE`
* `TIMESTAMP`
* `TIMESTAMP WITH TIME ZONE`

----
note:

Tsurugi internally handles `DECIMAL` as a floating point decimal number. In cast expressions, you can use DECIMAL with any number of digits by specifying `(CAST x as DECIMAL(*,*))`. On the other hand, the scale (`s`) is required when stored it into tables because it must be recorded as a fixed point number.

## Literals

* integral numbers
* floating point numbers
* `'character string'`
* `NULL`

----
note:

This version does not support temporal value literals (e.g. `TIMESTAMP '2000-01-01'`). You can specify such values using placeholders from Tsubakuro or Iceaxe.

## Planned features

### Highest

* Statements
  * `INSERT INTO ... SELECT ...`
* Queries
  * `LIMIT` clause
  * `HAVING` clause
* Expressions
  * `BETWEEN`
  * `IN`
  * `CURRENT_DATE`
  * `CURRENT_TIME`
  * `CURRENT_TIMESTAMP`

### High

* Queries
  * `UNION ALL`
* Expressions
  * temporal value literals
  * `NULLIF`
  * `COALESCE`
  * `CASE ... WHEN ...`
* Cast/assignment conversions
  * more conversion rules

### Normal

* Queries
  * Sub-queries
* Expressions
  * `LIKE`
  * `EXISTS`
  * `IN` with sub-queries
* Types
  * `BINARY`
  * `BOOLEAN`
  * `TINYINT`/`SMALLINT`
