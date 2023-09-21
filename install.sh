#!/bin/bash -ex

_SCRIPTS_DIR=$(cd "$(dirname $0)" && pwd)
${_SCRIPTS_DIR}/dist/install/install.sh "$@"
