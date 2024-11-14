#!/bin/bash -x

# jogasaki sql
diff -ur jogasaki/src/jogasaki/proto/sql tsubakuro/modules/proto/src/main/protos/jogasaki/proto/sql
diff -ur jogasaki/src/jogasaki/proto/sql ogawayama/src/jogasaki/proto/sql

# tateyama kvs
diff -ur jogasaki/src/tateyama/proto/kvs tsubakuro/modules/kvs/src/main/proto/tateyama/proto/kvs

# tateyama diagnostics
diff -ur tateyama/src/tateyama/proto/diagnostics.proto tsubakuro/modules/proto/src/main/protos/tateyama/proto/diagnostics.proto
diff -ur tateyama/src/tateyama/proto/diagnostics.proto tateyama-bootstrap/src/tateyama/proto/diagnostics.proto
diff -ur tateyama/src/tateyama/proto/diagnostics.proto ogawayama/src/tateyama/proto/diagnostics.proto

# tateyama auth
diff -ur tateyama/src/tateyama/proto/auth tsubakuro/modules/proto/src/main/protos/tateyama/proto/auth
diff -ur tateyama/src/tateyama/proto/auth tateyama-bootstrap/src/tateyama/proto/auth
diff -ur tateyama/src/tateyama/proto/auth ogawayama/src/tateyama/proto/auth

# tateyama core
diff -ur tateyama/src/tateyama/proto/core tsubakuro/modules/proto/src/main/protos/tateyama/proto/core
diff -ur tateyama/src/tateyama/proto/core tateyama-bootstrap/src/tateyama/proto/core
diff -ur tateyama/src/tateyama/proto/core ogawayama/src/tateyama/proto/core

# tateyama endpoint
diff -ur tateyama/src/tateyama/proto/endpoint tsubakuro/modules/proto/src/main/protos/tateyama/proto/endpoint
diff -ur tateyama/src/tateyama/proto/endpoint tateyama-bootstrap/src/tateyama/proto/endpoint
diff -ur tateyama/src/tateyama/proto/endpoint ogawayama/src/tateyama/proto/endpoint

# tateyama framework
diff -ur tateyama/src/tateyama/proto/framework tsubakuro/modules/proto/src/main/protos/tateyama/proto/framework
diff -ur tateyama/src/tateyama/proto/framework tateyama-bootstrap/src/tateyama/proto/framework
diff -ur tateyama/src/tateyama/proto/framework ogawayama/src/tateyama/proto/framework

# tateyama datastore
diff -ur tateyama/src/tateyama/proto/datastore tsubakuro/modules/proto/src/main/protos/tateyama/proto/datastore
diff -ur tateyama/src/tateyama/proto/datastore tateyama-bootstrap/src/tateyama/proto/datastore

# tateyama metrics
diff -ur tateyama/src/tateyama/proto/metrics tateyama-bootstrap/src/tateyama/proto/metrics

# tateyama session
diff -ur tateyama/src/tateyama/proto/session tateyama-bootstrap/src/tateyama/proto/session

# tateyama altimeter
diff -ur tateyama/src/tateyama/proto/altimeter tateyama-bootstrap/src/tateyama/proto/altimeter

# tateyama debug
diff -ur tateyama/src/tateyama/proto/debug tsubakuro/modules/debug/src/main/proto/tateyama/proto/debug
