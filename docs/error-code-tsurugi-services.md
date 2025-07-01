# Error Code of Tsurugi Services

Client library (Tsubakuro) version: `1.10.0`.

This document presents a comprehensive list of error codes that can be transmitted from each Tsurugi service to the client.

Each error code comprises a 3-character prefix denoting the service responsible for the error, followed by a 5-digit number that provides a unique identification of the specific error within the service (e.g., `SCD-00401`).
Additionally, error messages may contain explanatory text followed by the error code to provide more detailed information about the cause of the error.

For information, each error code also has a symbolic name (e.g., `SERVICE_NOT_FOUND` for `SCD-00401`).
This name is for programmatic use of various errors in the client library, and is represented as the constant name of the enum in Java.

## `DebugServiceCode`

Debugging service is designed to debug the database itself.

>[!NOTE]
> Please consider disabling this service for regular database use.

### `DBG-00000`

symbolic name: `UNKNOWN`.

unknown error was occurred in the debugging service.

## `KvsServiceCode`

KVS (Key Value Store) service is designed to access the database directly without using SQL.

>[!NOTE]
> This feature is able to use partially, but still under development.

### `KVS-00001`

symbolic name: `NOT_FOUND`.

the target element does not exist in the database.

### `KVS-00002`

symbolic name: `ALREADY_EXISTS`.

the target element attempted to create already exists in the database.

### `KVS-00003`

symbolic name: `USER_ROLLBACK`.

the requested transaction operation was rollbacked by user.

### `KVS-00004`

symbolic name: `WAITING_FOR_OTHER_TRANSACTION`.

the requested transaction operation is waiting for other transaction.

### `KVS-00100`

symbolic name: `UNKNOWN`.

unknown error was occurred in the kvs service.

### `KVS-00102`

symbolic name: `IO_ERROR`.

I/O error was occurred in the server.

### `KVS-00103`

symbolic name: `INVALID_ARGUMENT`.

the service received a request message with an invalid argument.

### `KVS-00104`

symbolic name: `INVALID_STATE`.

the operation was requested in illegal or inappropriate time.

### `KVS-00105`

symbolic name: `UNSUPPORTED`.

the requested operation is not supported.

### `KVS-00106`

symbolic name: `USER_ERROR`.

the transaction operation met an user-defined error.

### `KVS-00107`

symbolic name: `ABORTED`.

the transaction was aborted.

### `KVS-00108`

symbolic name: `ABORT_RETRYABLE`.

the transaction was aborted, but retry might resolve the situation.

### `KVS-00109`

symbolic name: `TIME_OUT`.

the request was timed out.

### `KVS-00110`

symbolic name: `NOT_IMPLEMENTED`.

the requested feature is not yet implemented.

### `KVS-00111`

symbolic name: `ILLEGAL_OPERATION`.

the requested operation is not valid.

### `KVS-00112`

symbolic name: `CONFLICT_ON_WRITE_PRESERVE`.

the requested operation conflicted with a write preserve.

### `KVS-00114`

symbolic name: `WRITE_WITHOUT_WRITE_PRESERVE`.

long transaction issued write operation without a write preserve.

### `KVS-00115`

symbolic name: `INACTIVE_TRANSACTION`.

the transaction is inactive.

>[!NOTE]
> the transaction is inactive because it's already committed or aborted. The request is failed.

### `KVS-00116`

symbolic name: `BLOCKED_BY_CONCURRENT_OPERATION`.

the requested operation was blocked by concurrent operation.

>[!NOTE]
> the request couldn't be fulfilled due to the operation concurrently executed by other transaction. After the blocking transaction completes, re-trying the request may lead to different result.

### `KVS-00117`

symbolic name: `RESOURCE_LIMIT_REACHED`.

the server reached resource limit and the request could not be accomplished.

### `KVS-00118`

symbolic name: `INVALID_KEY_LENGTH`.

key length passed to the API was invalid.

### `KVS-01001`

symbolic name: `RESULT_TOO_LARGE`.

the operation result data was too large.

### `KVS-02001`

symbolic name: `NOT_AUTHORIZED`.

target resource is not authorized to use.

### `KVS-12002`

symbolic name: `WRITE_PROTECTED`.

the transaction was aborted by writing out of write preservation, or writing in read only transaction.

### `KVS-20001`

symbolic name: `TABLE_NOT_FOUND`.

the specified table was not found.

### `KVS-20002`

symbolic name: `COLUMN_NOT_FOUND`.

the specified column was not found.

### `KVS-20003`

symbolic name: `COLUMN_TYPE_MISMATCH`.

the column type was inconsistent.

### `KVS-20011`

symbolic name: `MISMATCH_KEY`.

the search key was mismatch for the table or index.

### `KVS-20021`

symbolic name: `INCOMPLETE_COLUMNS`.

several columns were not specified in PUT operation.

### `KVS-30001`

symbolic name: `INTEGRITY_CONSTRAINT_VIOLATION`.

operations was failed by integrity constraint violation.

## `AuthServiceCode`

Authentication service is designed for external use of Tsurugi's authentication mechanism.

>[!NOTE]
> This does not work correct because authentication is not yet available in Tsurugi.

### `AUT-00000`

symbolic name: `UNKNOWN`.

unknown error was occurred in the authentication service.

### `AUT-00101`

symbolic name: `NOT_AUTHENTICATED`.

authentication information is not found in this session.

>[!NOTE]
> Credentials may be not specified when establishing a session.

## `DatastoreServiceCode`

Datastore service provides the capability to manage persistent data, including backup and restore.

### `DSS-00000`

symbolic name: `UNKNOWN`.

unknown error was occurred in the datastore service.

### `DSS-00101`

symbolic name: `BACKUP_EXPIRED`.

the current backup session has been expired.

### `DSS-00601`

symbolic name: `TAG_ALREADY_EXISTS`.

the tag attempted to create already exists in the database.

### `DSS-00602`

symbolic name: `TAG_NAME_TOO_LONG`.

the tag name is too long.

## `SqlServiceCode`

SQL service is designed to access the database with SQL.

### `SQL-00100`

symbolic name: `TARGET_ALREADY_EXISTS_EXCEPTION`.

target already exists for newly creation request

### `SQL-01000`

symbolic name: `SQL_SERVICE_EXCEPTION`.

generic error in SQL service

### `SQL-02000`

symbolic name: `SQL_EXECUTION_EXCEPTION`.

generic error in SQL execution

### `SQL-02001`

symbolic name: `CONSTRAINT_VIOLATION_EXCEPTION`.

constraint Violation

### `SQL-02002`

symbolic name: `UNIQUE_CONSTRAINT_VIOLATION_EXCEPTION`.

unique constraint violation

### `SQL-02003`

symbolic name: `NOT_NULL_CONSTRAINT_VIOLATION_EXCEPTION`.

not-null constraint violation

### `SQL-02004`

symbolic name: `REFERENTIAL_INTEGRITY_CONSTRAINT_VIOLATION_EXCEPTION`.

referential integrity constraint violation

### `SQL-02005`

symbolic name: `CHECK_CONSTRAINT_VIOLATION_EXCEPTION`.

check constraint violation

### `SQL-02010`

symbolic name: `EVALUATION_EXCEPTION`.

error in expression evaluation

### `SQL-02011`

symbolic name: `VALUE_EVALUATION_EXCEPTION`.

error in value evaluation

### `SQL-02012`

symbolic name: `SCALAR_SUBQUERY_EVALUATION_EXCEPTION`.

non-scalar results from scalar subquery

### `SQL-02014`

symbolic name: `TARGET_NOT_FOUND_EXCEPTION`.

SQL operation target is not found

### `SQL-02018`

symbolic name: `INCONSISTENT_STATEMENT_EXCEPTION`.

statement is inconsistent with the request

### `SQL-02020`

symbolic name: `RESTRICTED_OPERATION_EXCEPTION`.

restricted operation was requested

### `SQL-02021`

symbolic name: `DEPENDENCIES_VIOLATION_EXCEPTION`.

deletion was requested for the object with dependencies on others

### `SQL-02022`

symbolic name: `WRITE_OPERATION_BY_RTX_EXCEPTION`.

write operation was requested using RTX

### `SQL-02023`

symbolic name: `LTX_WRITE_OPERATION_WITHOUT_WRITE_PRESERVE_EXCEPTION`.

LTX write operation was requested outside of write preserve

### `SQL-02024`

symbolic name: `READ_OPERATION_ON_RESTRICTED_READ_AREA_EXCEPTION`.

read operation was requested on restricted read area

### `SQL-02025`

symbolic name: `INACTIVE_TRANSACTION_EXCEPTION`.

operation was requested using transaction that had already committed or aborted

### `SQL-02027`

symbolic name: `PARAMETER_EXCEPTION`.

error on parameters or placeholders

### `SQL-02028`

symbolic name: `UNRESOLVED_PLACEHOLDER_EXCEPTION`.

requested statement has unresolved placeholders

### `SQL-02030`

symbolic name: `LOAD_FILE_EXCEPTION`.

error on files for load

### `SQL-02031`

symbolic name: `LOAD_FILE_NOT_FOUND_EXCEPTION`.

target load file is not found

### `SQL-02032`

symbolic name: `LOAD_FILE_FORMAT_EXCEPTION`.

unexpected load file format

### `SQL-02033`

symbolic name: `DUMP_FILE_EXCEPTION`.

error on files for dump

### `SQL-02034`

symbolic name: `DUMP_DIRECTORY_INACCESSIBLE_EXCEPTION`.

dump directory is not accessible

### `SQL-02036`

symbolic name: `SQL_LIMIT_REACHED_EXCEPTION`.

the requested operation reached the SQL limit

### `SQL-02037`

symbolic name: `TRANSACTION_EXCEEDED_LIMIT_EXCEPTION`.

the number of running transactions exceeded the maximum limit allowed, and new transaction failed to start

### `SQL-02039`

symbolic name: `SQL_REQUEST_TIMEOUT_EXCEPTION`.

SQL request timed out

### `SQL-02041`

symbolic name: `DATA_CORRUPTION_EXCEPTION`.

detected data corruption

### `SQL-02042`

symbolic name: `SECONDARY_INDEX_CORRUPTION_EXCEPTION`.

detected secondary index data corruption

### `SQL-02044`

symbolic name: `REQUEST_FAILURE_EXCEPTION`.

request failed before starting processing (e.g. due to pre-condition not fulfilled)

### `SQL-02045`

symbolic name: `TRANSACTION_NOT_FOUND_EXCEPTION`.

requested transaction is not found (or already released)

### `SQL-02046`

symbolic name: `STATEMENT_NOT_FOUND_EXCEPTION`.

requested statement is not found (or already released)

### `SQL-02048`

symbolic name: `INTERNAL_EXCEPTION`.

detected internal error

### `SQL-02050`

symbolic name: `UNSUPPORTED_RUNTIME_FEATURE_EXCEPTION`.

unsupported runtime feature was requested

### `SQL-02052`

symbolic name: `BLOCKED_BY_HIGH_PRIORITY_TRANSACTION_EXCEPTION`.

tried to execute operations with priority to higher priority transactions

### `SQL-02054`

symbolic name: `INVALID_RUNTIME_VALUE_EXCEPTION`.

invalid value was used in runtime

### `SQL-02056`

symbolic name: `VALUE_OUT_OF_RANGE_EXCEPTION`.

value out of allowed range was used

### `SQL-02058`

symbolic name: `VALUE_TOO_LONG_EXCEPTION`.

variable length value was used exceeding the allowed maximum length

### `SQL-02060`

symbolic name: `INVALID_DECIMAL_VALUE_EXCEPTION`.

used value was not valid for the decimal type

### `SQL-03000`

symbolic name: `COMPILE_EXCEPTION`.

compile error

### `SQL-03001`

symbolic name: `SYNTAX_EXCEPTION`.

syntax error

### `SQL-03002`

symbolic name: `ANALYZE_EXCEPTION`.

analyze error

### `SQL-03003`

symbolic name: `TYPE_ANALYZE_EXCEPTION`.

error on types

### `SQL-03004`

symbolic name: `SYMBOL_ANALYZE_EXCEPTION`.

error on symbols

### `SQL-03005`

symbolic name: `VALUE_ANALYZE_EXCEPTION`.

error on values

### `SQL-03010`

symbolic name: `UNSUPPORTED_COMPILER_FEATURE_EXCEPTION`.

unsupported feature/syntax was requested

### `SQL-04000`

symbolic name: `CC_EXCEPTION`.

error in CC serialization

### `SQL-04001`

symbolic name: `OCC_EXCEPTION`.

OCC aborted

### `SQL-04003`

symbolic name: `LTX_EXCEPTION`.

LTX aborted

### `SQL-04005`

symbolic name: `RTX_EXCEPTION`.

RTX aborted

### `SQL-04007`

symbolic name: `BLOCKED_BY_CONCURRENT_OPERATION_EXCEPTION`.

request was blocked by the other operations executed concurrently

### `SQL-04010`

symbolic name: `OCC_READ_EXCEPTION`.

OCC aborted due to its read

### `SQL-04011`

symbolic name: `OCC_WRITE_EXCEPTION`.

OCC aborted due to its write

### `SQL-04013`

symbolic name: `LTX_READ_EXCEPTION`.

LTX aborted due to its read

### `SQL-04014`

symbolic name: `LTX_WRITE_EXCEPTION`.

LTX aborted due to its write

### `SQL-04015`

symbolic name: `CONFLICT_ON_WRITE_PRESERVE_EXCEPTION`.

OCC (early) aborted because it read other LTX's write preserve

## `CoreServiceCode`

diagnostics of the service infrastructure.

### `SCD-00000`

symbolic name: `UNKNOWN`.

unknown error was occurred in the server.

### `SCD-00001`

symbolic name: `UNRECOGNIZED`.

the server received an unrecognized message.

### `SCD-00100`

symbolic name: `SYSTEM_ERROR`.

the server system is something wrong.

### `SCD-00101`

symbolic name: `UNSUPPORTED_OPERATION`.

the requested operation is not supported.

### `SCD-00102`

symbolic name: `ILLEGAL_STATE`.

operation was requested in illegal or inappropriate time.

* references
  * [Issue: "SCD-00102: handshake operation is required to establish sessions"](upgrade-guide.md#handshake-required)

### `SCD-00103`

symbolic name: `IO_ERROR`.

I/O error was occurred in the server.

### `SCD-00104`

symbolic name: `OUT_OF_MEMORY`.

the server is out of memory.

### `SCD-00105`

symbolic name: `RESOURCE_LIMIT_REACHED`.

the server reached resource limit.

### `SCD-00201`

symbolic name: `AUTHENTICATION_ERROR`.

authentication was failed.

### `SCD-00202`

symbolic name: `PERMISSION_ERROR`.

request is not permitted.

### `SCD-00203`

symbolic name: `ACCESS_EXPIRED`.

access right has been expired.

### `SCD-00204`

symbolic name: `REFRESH_EXPIRED`.

refresh right has been expired.

### `SCD-00205`

symbolic name: `BROKEN_CREDENTIAL`.

credential information is broken.

### `SCD-00301`

symbolic name: `SESSION_CLOSED`.

the current session is already closed.

### `SCD-00302`

symbolic name: `SESSION_EXPIRED`.

the current session is expired.

### `SCD-00401`

symbolic name: `SERVICE_NOT_FOUND`.

the destination service was not found.

### `SCD-00402`

symbolic name: `SERVICE_UNAVAILABLE`.

the destination service was not found.

* references
  * [Issue: "SCD-00402: unsupported service message"](upgrade-guide.md#service-not-registered)

### `SCD-00403`

symbolic name: `OPERATION_CANCELED`.

operation was canceled by user or system.

### `SCD-00404`

symbolic name: `OPERATION_DENIED`.

the service has denied the request to conduct.

* references
  * [Issue: "SCD-00404: operation denied"](upgrade-guide.md#operation-denied)

### `SCD-00501`

symbolic name: `INVALID_REQUEST`.

the service received a request message with invalid payload.

* references
  * [Issue: "SCD-00501: inconsistent service message version"](upgrade-guide.md#inconsistent-message)

