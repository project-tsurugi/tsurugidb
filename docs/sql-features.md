# Available SQL features in Tsurugi

In the latest release, Tsurugi SQL features are very limited.
The planned features are listed [here](#planned-features).

## Definitions (DDL)

* [CREATE TABLE](#create-table)
* [CREATE INDEX](#create-table)
* [DROP TABLE](#drop-table)
* [DROP INDEX](#drop-table)

```txt
<ddl-statement>:
  <table-definition>
  <index-definition>
  <drop-table>
  <drop-index>
```

----
note:

Concurrent execution of DML and DDL statements are not fully supported.
DDL should be issued from single thread when there is no on-going DML processing for the target tables/indices.

### CREATE TABLE

```txt
<table-definition>:
  CREATE TABLE [<table-definition-option>] <table-name> (<table-element> [, <table-element> [, ...]])

<table-definition-option>:
  IF NOT EXISTS

<table-element>:
  <column-name> <type> [<column-constraint>...]
  PRIMARY KEY ( <column-name> [, <column-name> [, ...]] )

<column-constraint>:
  NULL
  NOT NULL
  PRIMARY KEY
  DEFAULT <default-expression>

<default-expression>:
  <literal>
```

* `<*-name>` - see [Names](#names)
* `<type>` - see [Types](#types)
* `<literal>` - see [Literals](#literals)

----
note:

`CREATE TABLE ... AS SELECT ...` is not supported.

### CREATE INDEX

```txt
<index-definition>
  CREATE INDEX [<index-definition-option>] <index-name> ON <table-name> (<index-element> [, <index-element> [, ...]])

<index-definition-option>:
  IF NOT EXISTS

<index-element>:
  <column-name>
  <column-name> ASC
  <column-name> DESC
```

----
note:

Limitation: the target table must not contain any rows when index is created on it.

Limitation: index name must be specified, and it must not be empty.

### DROP TABLE

```txt
<drop-table>:
  DROP TABLE [<drop-table-option>] <table-name> [<drop-table-behavior>]

<drop-table-option>:
  IF EXISTS

<drop-table-behavior>:
  RESTRICT
```

### DROP INDEX

```txt
<drop-index>:
  DROP INDEX [<drop-index-option>] <index-name> [<drop-index-behavior>]

<drop-index-option>:
  IF EXISTS

<drop-index-behavior>:
  RESTRICT
```

## Statements (DML)

* [SELECT](#select)
* [INSERT](#insert)
* [UPDATE](#update)
* [DELETE](#delete)

```txt
<dml-statement>:
  <select-statement>
  <insert-statement>
  <update-statement>
  <delete-statement>
```

### SELECT

see [Queries](#queries)

```txt
<select-statement>:
  <query-expression>
```

* `<query-expression>` - see [Queries](#queries)

### INSERT

```txt
<insert-statement>:
  INSERT [<insert-option>] INTO <table-name> [(<column-name> [, ...])] VALUES (<value-expression> [, ...]) [, ...]

<insert-option>:
  OR REPLACE
  OR IGNORE
  IF NOT EXISTS
```

* `INSERT OR REPLACE` - replaces the row even if the primary key already exists
* `INSERT OR IGNORE` - does nothing if the primary key already exists
* `INSERT IF NOT EXISTS` - same as `INSERT OR IGNORE`

----
note:

`INSERT INTO ... SELECT ...` is NOT available now. We are working to make this feature available in nearby versions.

### UPDATE

```txt
<update-statement>:
  UPDATE <table-name> SET <set-clause> [, ...] [WHERE <value-expression>]

<set-clause>:
  <column-name> = <value-expression>
```

### DELETE

```txt
<delete-statement>:
  DELETE FROM <table-name> [WHERE <value-expression>]
```

## Queries

```txt
<query-expression>:
  SELECT [<set-quantifier>] <select-element> [, ...]
      FROM <table-reference> [, ...]
      [WHERE <value-expression>]
      [GROUP BY <column-name> [, ...]]
      [HAVING <value-expression>]
      [ORDER BY <order-by-element> [, ...]]
      [LIMIT <integer>]
  TABLE <table-name>

<set-quantifier>:
  ALL
  DISTINCT

<select-element>:
  <value-expression> [[AS] <column-name>]
  *
  <relation-name> .*

<table-reference>:
  <table-name> [[AS] <relation-name>]
  (<query-expression>) [AS] <relation-name>
  <table-reference> CROSS JOIN <table-reference>
  <table-reference> [<join-type>] JOIN <table-reference> <join-specification>

<join-type>:
  INNER
  LEFT [OUTER]
  RIGHT [OUTER]
  FULL [OUTER]

<join-specification>:
  ON <value-expression>
  USING (<column-name> [, ...])

<order-by-element>:
  <value-expression>
  <value-expression> ASC
  <value-expression> DESC
```

----
note:

Limitation: `LIMIT` must be with `ORDER BY`.

## Value expressions

* [Primary expressions](#primary-expressions)
* [Arithmetic expressions](#arithmetic-expressions)
* [Comparison expressions](#comparison-expressions)
* [Boolean expressions](#boolean-expressions)
* [Character string expressions](#character-string-expressions)
* [Aggregation functions](#aggregation-functions)
* [CAST](#cast)
* [Placeholders](#placeholders)

```txt
<value-expression>:
  <primary-expression>
  <arithmetic-expression>
  <comparison-expression>
  <boolean-expression>
  <character-string-expression>
  <aggregation-function>
  <cast-expression>
  <placeholder>
```

### Primary expressions

```txt
<primary-expression>:
  <literal>
  <column-name>
  ( <value-expression> )
```

* `<*-name>` - see [Names](#names)
* `<literal>` - see [Literals](#literals)

### Arithmetic expressions

```txt
<arithmetic-expression>:
  + <value-expression>
  - <value-expression>
  <value-expression> + <value-expression>
  <value-expression> - <value-expression>
  <value-expression> * <value-expression>
  <value-expression> / <value-expression>
  <value-expression> % <value-expression>
```

### Comparison expressions

```txt
<comparison-expression>:
  <value-expression> = <value-expression>
  <value-expression> <> <value-expression>
  <value-expression> < <value-expression>
  <value-expression> <= <value-expression>
  <value-expression> > <value-expression>
  <value-expression> >= <value-expression
```

### Boolean expressions

```txt
<boolean-expression>:
  NOT <value-expression>
  <value-expression> AND <value-expression>
  <value-expression> OR <value-expression>
  <value-expression> IS [NOT] NULL
```

### Character string expressions

```txt
<character-string-expression>:
  <value-expression> || <value-expression>
```

### Aggregation functions

```txt
<aggregation-function>:
  COUNT(*)
  COUNT([<set-quantifier>] <value-expression>)
  SUM(<value-expression>)
  MAX(<value-expression>)
  MIN(<value-expression>)
  AVG(<value-expression>)

<set-quantifier>:
  ALL
  DISTINCT
```

### CAST

```txt
<cast-expression>:
  CAST(<value-expression> AS <type>)
```

* `<type>` - see [Types](#types) and [Conversions](#conversions)

### Placeholders

```txt
<placeholder>:
  : <placeholder-name>

<placeholder-name>:
  <regular-identifier>
```

* `<regular-identifier>` - see [Regular identifiers](#regular-identifiers)

## Types

```txt
<type>:
  INT
  BIGINT
  REAL
  FLOAT
  DOUBLE [PRECISION]
  DECIMAL [(<decimal-precision> [, <decimal-scale>])]
  DECIMAL(*, *)
  CHAR [(<fixed-length>)]
  VARCHAR [(<varying-length>)]
  DATE
  TIME
  TIME WITH TIME ZONE
  TIMESTAMP
  TIMESTAMP WITH TIME ZONE

<decimal-precision>:
  <integer>
  *

<decimal-scale>:
  <integer>

<fixed-length>:
  <integer>

<varying-length>
  <integer>
  *
```

* `<decimal-precision>` must be in [1, 38], or `*` to use the max precision
* `<decimal-scale>` must be in [0, `<decimal-precision>`], or zero when omitted
* `DECIMAL(*, *)` represents floating decimal number, that is, its scale is not fixed
  * `DECIMAL(*, *)` is not allowed as table column type in [table definitions](#create-table)
* `CHAR` and `VARCHAR` length represents the (maximum) number of **octets** in UTF-8
* when `<fixed-length>` is omitted, it is considered as `1`
* when `<varying-length>` is omitted, it is considered as `*`
* `*` in `<varying-length>` means the maximum length of the type
* `WITH TIME ZONE` is currently limited support, it is always considered as UTC time zone

----
note:

Tsurugi internally handles `DECIMAL` as a floating point decimal number. In cast expressions, you can use DECIMAL with any number of digits by specifying `(CAST x as DECIMAL(*,*))`. On the other hand, the scale (`s`) is required when stored it into tables because it must be recorded as a fixed point number.

## Literals

* [Exact numeric literals](#exact-numeric-literals)
* [Approximate numeric literals](#approximate-numeric-literals)
* [Character string literals](#character-string-literals)
* [Boolean literals](#boolean-literals)
* [Null literal](#null-literal)

```txt
<literal>:
  <exact-numeric-literal>
  <approximate-numeric-literal>
  <character-string-literal>
  <boolean-literal>
  <null-literal>
```

----
note:

This version does not support temporal value literals (e.g. `TIMESTAMP '2000-01-01'`). You can specify such values using placeholders from Tsubakuro or Iceaxe.

### Exact numeric literals

```txt
<exact-numeric-literal>:
  [<numeric-sign>] <integer>
  [<numeric-sign>] <decimal-number>

<numeric-sign>:
  +
  -

<integer>:
  <digit> [<digit>...]

<decimal-number>:
  <integer> . <digit> [<digit>...]

<digit>:
  0 .. 9
```

----
note:

Tsurugi interprets exact numeric literals as `BIGINT` or `DECIMAL` type:

* If the number fits into `BIGINT`, it is resolved as `BIGINT` type value
* Otherwise, it is resolved as `DECIMAL` type value with the exact scale

### Approximate numeric literals

```txt
<approximate-numeric-literal>:
  <exact-numeric-literal> <exponential-part>

<exponential-part>:
  E [<numeric-sign>] <integer>
```

----
note:

Tsurugi interpret approximate numeric literals as just `DOUBLE` type.

`E` is the exponent separator, and can be lower case character (e.g. `314e-2`).

### Character string literals

```txt
<character-string-literal>:
  ' <character-string-character>... '
  
<character-string-character>:
  any character except for '
  ''
```

----
note:

`''` in character string literals is considered as a single quote character (`'`).

Tsurugi currently does not support any escape sequences (e.g. `\n`).
We now plan whether to support escape sequences starting with back-slash (`\`) in the future.

### Boolean literals

```txt
<boolean-literal>:
  TRUE
  FALSE
  UNKNOWN
```

----
note:

`UNKNOWN` is considered as `NULL` of boolean type.

### Null literal

```txt
<null-literal>:
  NULL
```

----
note:

The current version of tsurugi allows `NULL` as general literals, but may in the future restrict it to use in only certain places.

## Names

* [Regular identifiers](#regular-identifiers)
* [Delimited identifiers](#delimited-identifiers)

```txt
<*-name>:
  <identifier>
  <identifier> . <identifier> [. ...]

<identifier>:
  <regular-identifier>
  <delimited-identifier>
```

### Regular identifiers

```txt
<regular-identifier>:
  <identifier-character-start> [<identifier-character-body>...]

<identifier-character-start>:
  A-Z
  a-z
  _

<identifier-character-body>:
  A .. Z
  a .. z
  0 .. 9
  _
```

* Regular identifiers cannot match [reserved words](#reserved-words).

----
note:

Identifiers cannot start with two consecutive underscores (`__`), they are reserved for system use.

If `lowercase_regular_identifier=true` in `[sql]` section of `tsurugi.ini`, all regular identifiers becomes lowercase to achieve case-insensitive identifiers.
If the above setting is enabled, existing tables and columns with capital names becomes be inaccessible with using regular identifiers.
You can still access such the tables and columns to use delimited identifier with the capital name.

### Delimited identifiers

```txt
<delimited-identifier>:
  " <delimited-identifier-character>... "
  
<delimited-identifier-character>:
  any character except for "
  ""
```

----
note:

If you want to use a reserved word as an identifier, you can use delimited identifiers.

Identifiers cannot start with two consecutive underscores (`"__..."`), they are reserved for system use.

Tsurugi currently accepts any characters in delimited identifiers.
We now plan to disallow using non-UTF-8 characters and ASCII control characters in the future.

The `sql.lowercase_regular_identifier` does not affect to delimited identifiers in contrast of regular identifiers.

Note that delimited identifiers may not refer the some built-in functions, like `COUNT`.

## Planned features

### Highest

* Statements
  * `INSERT INTO ... SELECT ...`
* Queries
  * `LIMIT` clause without `ORDER BY` clause
* Expressions
  * `BETWEEN`
  * `IN`
  * `CURRENT_DATE`
  * `CURRENT_TIME`
  * `CURRENT_TIMESTAMP`

### High

* Definitions
  * `GENERATED ALWAYS AS IDENTITY` (identity columns)
* Queries
  * `UNION ALL`
* Expressions
  * temporal value literals
  * `NULLIF`
  * `COALESCE`
  * `CASE ... WHEN ...`
* Types
  * `BINARY` / `VARBINARY`

### Normal

* Definitions
  * `GENERATED BY DEFAULT AS IDENTITY` (identity columns)
* Queries
  * Scalar sub-queries
  * `VALUES` as table reference
  * `SELECT` without `FROM` clause
* Expressions
  * `LIKE`
  * `EXISTS`
  * `IN` with sub-queries
* Types
  * `BOOLEAN`
  * `TINYINT`/`SMALLINT`

## Appendix

### Reserved words

The below reserved words are not allowed to use as regular identifiers.

* `A`
  * `ABS`, `ABSOLUTE`, `ACTION`, `ADD`, `ADMIN`, `AFTER`, `ALIAS`, `ALL`, `ALTER`, `ALWAYS`, `AND`, `ANY`, `ARE`, `ARRAY`, `AS`, `ASSERTION`, `ASYMMETRIC`, `AT`, `AUTHORIZATION`, `AVG`
* `B`
  * `BEFORE`, `BEGIN`, `BETWEEN`, `BIGINT`, `BINARY`, `BIT`, `BIT_AND`, `BIT_LENGTH`, `BIT_OR`, `BITVAR`, `BLOB`, `BOOL_AND`, `BOOL_OR`, `BOOLEAN`, `BOTH`, `BY`
* `C`
  * `CALL`, `CARDINALITY`, `CASCADE`, `CASCADED`, `CASE`, `CAST`, `CHAR`, `CHAR_LENGTH`, `CHARACTER`, `CHARACTER_LENGTH`, `CHECK`, `CLASS`, `CLOB`, `CLOSE`, `COALESCE`, `COLLATE`, `COLUMN`, `COMMIT`, `CONNECT`, `CONSTRAINT`, `CONSTRAINTS`, `CONVERT`, `CORRESPONDING`, `COUNT`, `CREATE`, `CROSS`, `CUBE`, `CURRENT`, `CURRENT_DATE`, `CURRENT_PATH`, `CURRENT_ROLE`, `CURRENT_TIME`, `CURRENT_TIMESTAMP`, `CURRENT_USER`, `CURSOR`, `CYCLE`
* `D`
  * `DATE`, `DAY`, `DEALLOCATE`, `DEC`, `DECIMAL`, `DECLARE`, `DEFAULT`, `DELETE`, `DEREF`, `DESCRIBE`, `DETERMINISTIC`, `DISCONNECT`, `DISTINCT`, `DOUBLE`, `DROP`, `DYNAMIC`
* `E`
  * `EACH`, `ELSE`, `END`, `END-EXEC`, `ESCAPE`, `EVERY`, `EXCEPT`, `EXEC`, `EXECUTE`, `EXISTS`, `EXTERNAL`, `EXTRACT`
* `F`
  * `FALSE`, `FETCH`, `FLOAT`, `FOR`, `FOREIGN`, `FROM`, `FULL`, `FUNCTION`
* `G`
  * `GENERATED`, `GET`, `GLOBAL`, `GRANT`, `GROUP`, `GROUPING`
* `H`
  * `HAVING`, `HOUR`
* `I`
  * `IDENTITY`, `IF`, `IN`, `INCLUDE`, `INCREMENT`, `INDEX`, `INDICATOR`, `INNER`, `INOUT`, `INSERT`, `INT`, `INTEGER`, `INTERSECT`, `INTERVAL`, `INTO`, `IS`
* `J`
  * `JOIN`
* `K`
* `L`
  * `LANGUAGE`, `LARGE`, `LATERAL`, `LEADING`, `LEFT`, `LENGTH`, `LIKE`, `LIMIT`, `LOCAL`, `LOCALTIME`, `LOCALTIMESTAMP`, `LOWER`
* `M`
  * `MATCH`, `MAX`, `MAXVALUE`, `MIN`, `MINUTE`, `MINVALUE`, `MOD`, `MODIFIES`, `MODULE`, `MONTH`
* `N`
  * `NATIONAL`, `NATURAL`, `NCHAR`, `NCLOB`, `NEW`, `NEXT`, `NO`, `NONE`, `NOT`, `NULL`, `NULLIF`, `NULLS`, `NUMERIC`
* `O`
  * `OCTET_LENGTH`, `OF`, `OLD`, `ON`, `ONLY`, `OPEN`, `OR`, `ORDER`, `OUT`, `OUTER`, `OVERLAPS`, `OVERLAY`, `OWNED`
* `P`
  * `PARAMETER`, `PLACING`, `POSITION`, `PRECISION`, `PREPARE`, `PRIMARY`, `PROCEDURE`
* `Q`
* `R`
  * `REAL`, `RECURSIVE`, `REF`, `REFERENCES`, `REFERENCING`, `REPLACE`, `RESULT`, `RETURN`, `RETURNS`, `REVOKE`, `RIGHT`, `ROLE`, `ROLLBACK`, `ROLLUP`, `ROW`, `ROWS`
* `S`
  * `SAVEPOINT`, `SCOPE`, `SEARCH`, `SECOND`, `SELECT`, `SESSION_USER`, `SET`, `SIMILAR`, `SMALLINT`, `SOME`, `SPECIFIC`, `SQL`, `SQLEXCEPTION`, `SQLSTATE`, `SQLWARNING`, `START`, `STATIC`, `SUBLIST`, `SUBSTRING`, `SUM`, `SYMMETRIC`, `SYSTEM_USER`
* `T`
  * `TABLE`, `TEMPORARY`, `THEN`, `TIME`, `TIMESTAMP`, `TIMEZONE_HOUR`, `TIMEZONE_MINUTE`, `TINYINT`, `TO`, `TRAILING`, `TRANSLATE`, `TRANSLATION`, `TREAT`, `TRIGGER`, `TRIM`, `TRUE`
* `U`
  * `UNION`, `UNIQUE`, `UNKNOWN`, `UNNEST`, `UPDATE`, `UPPER`, `USER`, `USING`
* `V`
  * `VALUES`, `VARBINARY`, `VARBIT`, `VARCHAR`, `VARYING`, `VIEW`
* `W`
  * `WHEN`, `WHENEVER`, `WHERE`, `WITH`, `WITHOUT`
* `X`
* `Y`
  * `YEAR`
* `Z`
  * `ZONE`

----
note:

The reserved words are case-insensitive.

These reserved word list may change in the future.
The above also includes unnecessary words because of according to the standard SQL definition.

### Comments

Comments are treated as whitespace characters in Tsurugi SQL.

```txt
<comment>:
  <simple-comment>
  <block-comment>

<simple-comment>:
  -- ...

<block-comment>:
  /* ... */
```

### Conversions

When an expression needs to be evaluated with different types for comparisons, arithmetic operations, assignments, etc., type conversions are performed to match the types before processing.

Type conversions can be explicit or implicit.

* Implicit type conversion is done automatically by SQL engine and compiler when the value change is known to be safe.
* Explicit conversions are not necessarily safe and require explicit instructions by CAST expressions.

#### Explicit conversion

Explicit conversion can be done by specifying the destination type with a CAST expression.

CAST expression is possible when the source and target types are one of the following:

* INT
* BIGINT
* REAL
* DOUBLE
* DECIMAL
* CHAR
* VARCHAR

CAST expression chooses appropriate values for successful conversion unless conversion is not possible in principle. For example, values that exceed the range of possible values to be stored in the destination are rounded to the appropriate value near the boundary value.

#### Implicit conversion

##### Binary promotion

When performing arithmetic operations or comparisons between two different types, type conversion is performed beforehand to a wider type that includes both types. The following is a list of the source types and the result type of conversion.

| source type pair | result type |
| --- | --- |
| `INT` and `BIGINT` | `BIGINT` |
| `REAL` and `DOUBLE` | `DOUBLE` |
| one of `INT`/`BIGINT` and `DECIMAL` | `DECIMAL` |
| one of `INT`/`BIGINT` and one of `REAL`/`DOUBLE` | `DOUBLE` |
| `DECIMAL` and one of `REAL`/`DOUBLE`  | `DOUBLE` |

##### Assignment Conversions

When an assignment is made by INSERT/UPDATE statements, etc., the source type is converted to the destination type as long as the precision is not lost. The following is a list of possible assignment source and destination types.

| source type | destination type |
| --- | --- |
| one of INT/BIGINT/DECIMAL | one of INT/BIGINT/DECIMAL/REAL/DOUBLE |
| one of REAL/DOUBLE | one of REAL/DOUBLE |

remark: REAL/DOUBLE to INT/BIGINT/DECIMAL conversions are not performed.

If safe conversion is not possible, for example, values that cannot be stored in the destination type will result in a conversion error at runtime.

###### Special case of assignment Conversions

Additionally to assignment by INSERT/UPDATE statements, assignment conversions are also performed when execution plan conducts point read or range scan targetting to tables/indices. The values given for the search condition of point read or range scan will be converted to the type of index/table key columns. Same rule on source/destination types as above apply to this case.

----
note: 

On BETA5, the assignment conversion for point read/range scan does not yet support conversion from DECIMAL to REAL/DOUBLE. So searching REAL/DOUBLE columns with DECIMAL values can result in runtime error. Casting the DECIMAL values works around the problem. This will be fixed in a future release.
