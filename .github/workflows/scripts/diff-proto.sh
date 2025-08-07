#!/bin/bash

diff_pairs=(
  "jogasaki/src/jogasaki/proto/sql tsubakuro/modules/proto/src/main/protos/jogasaki/proto/sql"
  "jogasaki/src/tateyama/proto/kvs tsubakuro/modules/kvs/src/main/proto/tateyama/proto/kvs"
  "tateyama/src/tateyama/proto/diagnostics.proto tsubakuro/modules/proto/src/main/protos/tateyama/proto/diagnostics.proto"
  "tateyama/src/tateyama/proto/diagnostics.proto tateyama-bootstrap/src/tateyama/proto/diagnostics.proto"
  "tateyama/src/tateyama/proto/auth tsubakuro/modules/proto/src/main/protos/tateyama/proto/auth"
  "tateyama/src/tateyama/proto/auth tateyama-bootstrap/src/tateyama/proto/auth"
  "tateyama/src/tateyama/proto/core tsubakuro/modules/proto/src/main/protos/tateyama/proto/core"
  "tateyama/src/tateyama/proto/core tateyama-bootstrap/src/tateyama/proto/core"
  "tateyama/src/tateyama/proto/endpoint tsubakuro/modules/proto/src/main/protos/tateyama/proto/endpoint"
  "tateyama/src/tateyama/proto/endpoint tateyama-bootstrap/src/tateyama/proto/endpoint"
  "tateyama/src/tateyama/proto/framework tsubakuro/modules/proto/src/main/protos/tateyama/proto/framework"
  "tateyama/src/tateyama/proto/framework tateyama-bootstrap/src/tateyama/proto/framework"
  "tateyama/src/tateyama/proto/datastore tsubakuro/modules/proto/src/main/protos/tateyama/proto/datastore"
  "tateyama/src/tateyama/proto/datastore tateyama-bootstrap/src/tateyama/proto/datastore"
  "tateyama/src/tateyama/proto/metrics tateyama-bootstrap/src/tateyama/proto/metrics"
  "tateyama/src/tateyama/proto/session tateyama-bootstrap/src/tateyama/proto/session"
  "tateyama/src/tateyama/proto/altimeter tateyama-bootstrap/src/tateyama/proto/altimeter"
  "tateyama/src/tateyama/proto/debug tsubakuro/modules/debug/src/main/proto/tateyama/proto/debug"
)

_result=0
for pair in "${diff_pairs[@]}"; do
  IFS=' ' read -r dir1 dir2 <<< "$pair"
  echo "diff: $dir1 $dir2"
  diff -urs "$dir1" "$dir2"
  if [ "$?" -ne 0 ]; then
    _result=1
  fi
done

exit $_result
