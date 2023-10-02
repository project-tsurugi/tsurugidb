#!/bin/bash

start() {
  cd ${TSURUGI_HOME} || exit

  echo 'starting tsurugi...'
  cat BUILDINFO.md

  ./bin/tgctl start --logtostderr ${TG_OPTS}

  if [ -n "${TSURUGI_JWT_SECRET_KEY}" ]; then
    echo 'starting authentication-server...'
    ./bin/authentication-server start
  fi
}

handle_term() {
  cd ${TSURUGI_HOME} || exit

  if [ -n "${TSURUGI_JWT_SECRET_KEY}" ]; then
    echo 'stopping authentication-server...'
    ./bin/authentication-server stop
  fi

  if [[ "${TSURUGI_TGCTL_STOP_COMMAND}" != "kill" ]]; then
    TSURUGI_TGCTL_STOP_COMMAND="shutdown"
  fi

  echo "stopping tsurugi with ${TSURUGI_TGCTL_STOP_COMMAND}..."
  ./bin/tgctl "${TSURUGI_TGCTL_STOP_COMMAND}"
  _RET=$?

  exit ${_RET}
}
trap handle_term TERM

start
while :
do
  sleep 1
done
