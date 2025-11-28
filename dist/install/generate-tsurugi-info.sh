#!/bin/bash -e

_BUILD_TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%MZ")

if [ -n "${GITHUB_WORKSPACE}" ]; then
  git config --global --add safe.directory "$GITHUB_WORKSPACE"
fi

_TSURUGIDB_SHORT_SHA=$(git -C ${TG_INSTALL_BASE_DIR} log --pretty="format:%h" -1 HEAD)
_TSURUGIDB_SHA=$(git -C ${TG_INSTALL_BASE_DIR} log --pretty="format:%H" -1 HEAD)
_TSURUGI_URL="${GITHUB_SERVER_URL}/${GITHUB_REPOSITORY}/tree/${_TSURUGIDB_SHA}"

if [ "${TSURUGI_VERSION}" = "" ]; then
  if [[ ${GITHUB_REF} =~ ^refs/tags/* ]]; then
    _TSURUGI_TAG=${GITHUB_REF_NAME}
  else
    _TSURUGI_TAG=$(git tag -l --contains ${_TSURUGIDB_SHA} | tail -1)
  fi
  if [ "${_TSURUGI_TAG}" = "" ]; then
    TSURUGI_VERSION="$(cat ${TG_INSTALL_BASE_DIR}/VERSION)-SNAPSHOT-${_BUILD_TIMESTAMP//[TZ:-]/}-${_TSURUGIDB_SHORT_SHA}"
  else
    TSURUGI_VERSION="${_TSURUGI_TAG}"
  fi
fi

TSURUGIINFO="{
    \"name\": \"tsurugidb\",
    \"version\": \"${TSURUGI_VERSION}\",
    \"date\": \"${_BUILD_TIMESTAMP}\",
    \"url\": \"${_TSURUGI_URL}\"
}
"

echo "${TSURUGIINFO}"
