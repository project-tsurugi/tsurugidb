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
