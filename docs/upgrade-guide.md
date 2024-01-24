# Tsurugi Upgrade Guide

This is a generic guide for upgrading across versions of Tsurugi.

## Upgrading instructions

### 1. Stop old version of Tsurugi clients and server

- Stop tsurugi client applications and client tools (ex. Tsurugi SQL Console).
- Stop Tsurugi Server (tsurugidb process) by run `tgctl shutdown`.

### 2. Install a new version of Tsurugi server

- Install the new version of Tsurugi by following document.
  - [Tsurugi Getting Started - Installation Instructions](https://github.com/project-tsurugi/tsurugidb/blob/master/docs/getting-started.md#installation-instructions)
  - The installer places Tsurugi into different directories for each version, so that previous versions will never be changed.
  - If `--symbolic` option is specified and a symbolic link for the old version already exists in that location, it will be changed to link to the new version.

### 3. Update version of client library

- Updating the server version may break the message compatibility between the server and the client library (Tsubakuro).
- Please refer to the following document and update Tsubakuro used by client applications if necessary.
  - [Service Message Version (SMV) Compatibility](https://github.com/project-tsurugi/tsurugidb/blob/master/docs/service-message-compatibilities.md)

### 4. Migrate configuration file of Tsurugi server

- Apply the configuration items (changed from the default settings) in the old version of the configuration file ( `var/etc/tsurugi.ini` ) to the new version of that.
- It is NOT RECOMMENDED to directly substitute the old configuration file with the new one.
  - Newer versions of the configuration file may have new items, or the default settings may have changed.

### 5. Migrate transaction log files of Tsurugi server

- Copy the old version of the transaction log data directory ( `var/data` ) to the new version of that.
- Log data migration possibly requires additional procedures. Please check the release notes.
  - In such the cases, the database will fail on startup because the restore operation cannot be performed correctly.

### 6. Start new version of Tsurugi server and clients

- Start Tsurugi Server (tsurugidb process) by run `tgctl start`.
- Start tsurugi client applications or client tools (ex. Tsurugi SQL Console)
- Check client applications execution and migrated data.

## Trouble shooting

### Issue: No response from the server <a name="no-response"></a>

If there is no response from the server when a client connects, the possible causes are as follows:

- There is a problem on the network path.
- Incorrect version/edition combination of the client and server.

Please ensure the client library version (Tsubakuro) aligns with the recommended by the Tsurugi server you have installed.

### Issue: "SCD-00402: unsupported service message" <a name="service-not-registered"></a>

If you encounter the error message "SCD-00402: unsupported service message: the destination service (ID=X) is not registered." while connecting from the client or executing requests, it may be attributed to an incorrect version/edition combination of the client and server.

This error signifies that the service responsible for handling the client's request does not exist on the Tsurugi server. Each service wii be introduced through Tsurugi server version upgrades, and the available services may vary based on the Tsurugi server build settings.

The "ID=X" segment of the error message contains the numeric service ID of the target service. Refer to the following list for existing services and their corresponding IDs:

| service name           | numeric service ID | note |
|:-----------------------|-------------------:|:-----|
| Routing service        |                `0` | Dispatches messages from clients to each service
| Endpoint               |                `1` | Establishes and maintains client sessions
| Datastore service      |                `2` | Supports backup/restore operations
| SQL service            |                `3` | Accepts SQL operations
| PostgreSQL FDW service |                `4` | Communicates with PostgreSQL
| Remote KVS service     |                `5` | Accepts KVS operations
| Debug service          |                `6` | Debugging support

Please match the service ID in the error message with the corresponding service ID in the list above to identify the specific service causing the issue.

### Issue: "SCD-00501: inconsistent service message version" <a name="inconsistent-message"></a>

If you encounter the error message "SCD-00501: inconsistent service message version: see https://github.com/project-tsurugi/tsurugidb/blob/master/docs/service-message-compatibilities.md (client: X, server: Y)" while executing requests from clients, it may be attributed to an incorrect version/edition combination of the client and server.

Please see the document [Service Message Version (SMV) Compatibility](service-message-compatibilities.md).
