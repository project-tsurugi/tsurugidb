# Tsurugi Docker User Guide

This document describes how to use Tsurugi's Docker images.

## Overview of Tsurugi Docker image

The "Tsurugi Docker image" is a Docker image in which the Tsurugi server is installed.

The Tsurugi server runs along with starting and stopping Docker containers.
If you start the Tsurugi Docker image as a Docker container, the Tsurugi server will be started at the container's entry point.
Stopping the Docker container also stops the Tsurugi server.

Tsurugi server logs are mapped to the Docker container logs via standard error output.
So you can find the Tsurugi server's logs from the Docker container's logs.

## How to get Tsurugi Docker images

Tsurugi Docker images are available on GitHub Container Registry.
Please refer below for the image URL and release tag information:

- https://github.com/project-tsurugi/tsurugidb/pkgs/container/tsurugidb

## How to use Tsurugi Docker Container

The following is an example of how to use the Tsurugi Docker container.
You can use Tsurugi Docker containers in other ways (e.g. on docker-compose).

### Starting a Docker container

Start the Docker container with `docker container run`.
The example below exposes the TCP port `12345` of the Tsurugi server as the host side port `12345`.

```sh
$ docker container run -d -p 12345:12345 --name tsurugi ghcr.io/project-tsurugi/tsurugidb
```

### Checking Docker container status

Use `docker container ls` to check the status of Docker containers.

```sh
$ docker container ls -a
CONTAINER ID   IMAGE                               COMMAND                  CREATED          STATUS                    PORTS                                           NAMES
4b9d9866c8f0   ghcr.io/project-tsurugi/tsurugidb   "docker-entrypoint.sh"   13 seconds ago   Up 8 seconds              0.0.0.0:12345->12345/tcp, :::12345->12345/tcp   tsurugi
```

### Retrieve Tsurugi server logs

Display the Tsurugi server logs with `docker container logs`.

```sh
$ docker container logs -f tsurugi
starting tsurugi...
#### BUILD_INFO
TSURUGI_VERSION:1.X.X
...
```

### Stopping Docker containers

Stop the Docker container with `docker container stop`.

```sh
$ docker container stop tsurugi
tsurugi
```

## Connecting to Docker containers

There are two main ways to connect to a Tsurugi server from a client

- Connecting from inside the container
- Connecting from outside the container

### Connecting from inside a container

To connect from inside a Docker container (i.e., a local connection), you should connect via an IPC connection. It will provide high speed communication via shared memory.

The Tsurugi SQL console (the `tgsql` command) is bundled as a standard client application on the Docker container. You can execute SQL, etc. using the `tgsql` command.

```sh
$ docker container exec -it tsurugi bash
tsurugi@xxxxxx:/usr/lib/tsurugi-1.x.x$ tgsql -c ipc:tsurugi
[main] INFO com.tsurugidb.console.core.ScriptRunner - establishing connection: ipc:tsurugi
[main] INFO com.tsurugidb.console.core.ScriptRunner - start repl
tgsql> BEGIN;
transaction started. option=[
  type: OCC
]
Time: 59.087 ms
tgsql>
...
```

To execute other client applications via an IPC connection, you will need to deploy the full application runtime environment on the Docker container.

> [!IMPORTANT]
> IPC connections use the operating system's shared memory area (`/dev/shm`) for communication. Typically each session consumes approximately **20MB** of shared memory.
> In Docker, the default shared memory size for containers is limited to **64MB**. Therefore, if you use multiple IPC sessions with Tsurugi Server, it may run out of memory and failing to establish sessions.
>
> The shared memory size when launching a Docker container can be specified with the `--shm-size` option. Please adjust the shared memory size and related Tsurugi configuration settings as needed. For example, to specify a shared memory size of 2GB, use the following command:
> ```docker container run --shm-size=2g```
>
> For more details on the shared memory usage for IPC connections, refer to the following documentation:
> - https://github.com/project-tsurugi/tateyama/blob/master/docs/internal/shared-memory-usage_ja.md

### Connecting from outside a container

To connect from outside the Docker container, you should connect via a TCP connection.
You can also connect from a remote host when using a TCP connection.

When running the Docker image as a container, you need to map the port of the Tsubakuro server's TCP connection endpoint to any port on the host machine.

To connect from external Java clients (applications that use Tsubakuro or Iceaxe APIs), please specify Tsurugi's TCP endpoint via the Docker container in the API that establishes connection sessions.

## Various ways to run Tsurugi Docker containers

### Configuring Tsurugi's log level settings

Start the Docker container with log settings via `GLOG_xx` environment variables.

```sh
$ docker container run -d -p 12345:12345 --name tsurugi -e GLOG_v=30 ghcr.io/project-tsurugi/tsurugidb
```

### Specify a configuration file

In the Docker container, the Tsurugi server is installed under `/usr/lib/tsurugi` on the container.
To start Tsurugi server with another configuration file, you can mount the directory including its configuration file.

```sh
$ docker container run -d -v $HOME/tsurugi-conf:/usr/lib/tsurugi/var/etc --name tsurugi ghcr.io/project-tsurugi/tsurugidb
```
