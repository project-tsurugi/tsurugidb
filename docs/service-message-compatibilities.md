# Service Message Version (SMV) Compatibility

## Overview (What is SMV)

When using various service functions provided by the server (tsurugidb process) from the client (an application that uses Tsubakuro to communicate with the server), both parties need to communicate with compatible message versions.
Tsurugi defines this message version as **Service Message Version (SMV)**.

If there are version incompatibilities between the client and the services on the server, then the server will return an error to the client as follows.

```
com.tsurugidb.tsubakuro.exception.CoreServiceException: SCD-00501: inconsistent service message version: see https://github.com/project-tsurugi/tsurugidb/blob/master/docs/service-message-compatibilities.md (client: "sql-0.0", server: "sql-1.0")
```

> [!NOTE]
> Depending on the version of the client, `IOException` may be thrown.

Once the above error occurs, please check the SMVs for each version as described below. Then, migrate the client or server to the appropriate version.

## SMV compatibility list

### Tsurugi Release 1.2.0

SMV             | Tsubakuro version
--------------- | -----------------
`sql-1.3`       | `1.6.0`
`datastore-0.0` | `1.0.1`
`kvs-0.0`       | `1.0.1`
`auth-0.0`      | `1.0.1`
`debug-0.0`     | `1.1.0`

### Tsurugi Release 1.1.0

SMV             | Tsubakuro version
--------------- | -----------------
`sql-1.3`       | `1.6.0`
`datastore-0.0` | `1.0.1`
`kvs-0.0`       | `1.0.1`
`auth-0.0`      | `1.0.1`
`debug-0.0`     | `1.1.0`

### Tsurugi Release 1.0.0

SMV             | Tsubakuro version
--------------- | -----------------
`sql-1.3`       | `1.6.0`
`datastore-0.0` | `1.0.1`
`kvs-0.0`       | `1.0.1`
`auth-0.0`      | `1.0.1`
`debug-0.0`     | `1.1.0`

### Tsurugi Release 1.0.0-BETA6

SMV             | Tsubakuro version
--------------- | -----------------
`sql-1.2`       | `1.5.0`
`datastore-0.0` | `1.0.1`
`kvs-0.0`       | `1.0.1`
`auth-0.0`      | `1.0.1`
`debug-0.0`     | `1.1.0`

### Tsurugi Release 1.0.0-BETA5

SMV             | Tsubakuro version
--------------- | -----------------
`sql-1.1`       | `1.2.0`
`datastore-0.0` | `1.0.1`
`kvs-0.0`       | `1.0.1`
`auth-0.0`      | `1.0.1`
`debug-0.0`     | `1.1.0`

### Tsurugi Release 1.0.0-BETA4

SMV             | Tsubakuro version
--------------- | -----------------
`sql-1.1`       | `1.2.0`
`datastore-0.0` | `1.0.1`
`kvs-0.0`       | `1.0.1`
`auth-0.0`      | `1.0.1`
`debug-0.0`     | `1.1.0`

### Tsurugi Release 1.0.0-BETA3

SMV             | Tsubakuro version
--------------- | -----------------
`sql-1.1`       | `1.2.0`
`datastore-0.0` | `1.0.1`
`kvs-0.0`       | `1.0.1`
`auth-0.0`      | `1.0.1`
`debug-0.0`     | `1.1.0`

### Tsurugi Release 1.0.0-BETA2

SMV             | Tsubakuro version
--------------- | -----------------
`sql-1.0`       | `1.1.0`
`datastore-0.0` | `1.0.1`
`kvs-0.0`       | `1.0.1`
`auth-0.0`      | `1.0.1`
`debug-0.0`     | `1.1.0`

### Tsurugi Release 1.0.0-BETA1

SMV             | Tsubakuro version
--------------- | -----------------
`sql-0.0`       | `1.0.1`
`datastore-0.0` | `1.0.1`
`kvs-0.0`       | `1.0.1`
`auth-0.0`      | `1.0.1`

## SMV schemes

SMV is represented in the version format `<service>`-`<major>`.`<minor>`.

- `<service>` : Symbolic ID of the Service
- `<major>` : major SMV
- `<minor>` : minor SMV

### Symbolic ID

Each Tsurugi service has a unique Symbolic ID.
The following is a list of Symbolic IDs, the corresponding services, and the Tsubakuro service client APIs for each ID.

| Symbolic ID    | Service Client       | Service Name                      |
| -------------- | -------------------- | --------------------------------- |
| sql            | SqlClient            | SQL Service (Jogasaki)            |
| datastore      | DatastoreClient      | Log Datastore Service (Limestone) |
| kvs            | KvsClient            | KVS Service (Icescrew)            |
| auth           | AuthClient           | Authentication Service            |
| debug          | DebugClient          | Debugging Service                 |

### major SMV / minor SMV

Definition of major SMV and minor SMV are shown below.

- Messages are NOT compatible if the major SMVs are different between the server and the client.
  - In this case, the server returns an error to the client as a result of compatibility check.
- Messages are compatible even if only the minor SMVs are different between the server and the client.
  - When the minor SMV is increased, the message may have extra optional fields.
  - If the server's minor SMV is greater than the client's minor SMV, the server will treat the optional fields as default values.
  - If the client's minor SMV is greater than the server's minor SMV, the server will just ignore such the optional fields.
