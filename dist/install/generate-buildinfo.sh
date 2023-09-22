#!/bin/bash -e

PROJECT_URL=https://github.com/project-tsurugi
BUILD_TIMESTAMP=$(TZ=JST-9 date +"%Y%m%d%H%M")

if [[ ${GITHUB_REF} =~ ^refs/tags/* ]]; then
  TSURUGI_VERSION=${GITHUB_REF_NAME}
else
  TSURUGIDB_SHORT_SHA=$(git -C ${TG_INSTALL_BASE_DIR} log --pretty="format:%h" -1 HEAD)
  TSURUGI_VERSION="snapshot-${BUILD_TIMESTAMP}-${TSURUGIDB_SHORT_SHA}"
fi

if [ -n "${GITHUB_WORKSPACE}" ]; then
  git config --global --add safe.directory "$GITHUB_WORKSPACE"
fi

BUILDINFO="#### BUILD_INFO
TSURUGI_VERSION:${TSURUGI_VERSION}
BUILD_TIMESTAMP:${BUILD_TIMESTAMP}

- tateyama-bootstrap $(git -C ${TG_TATEYAMA_BOOTSTRAP_DIR} log --pretty="format:[%h - %s](${PROJECT_URL}/tateyama-bootstrap/commit/%H)" -1 HEAD)
- jogasaki $(git -C ${TG_JOGASAKI_DIR} log --pretty="format:[%h - %s](${PROJECT_URL}/jogasaki/commit/%H)" -1 HEAD)
- ogawayama $(git -C ${TG_OGAWAYAMA_DIR} log --pretty="format:[%h - %s](${PROJECT_URL}/ogawayama/commit/%H)" -1 HEAD)
- limestone $(git -C ${TG_LIMESTONE_DIR} log --pretty="format:[%h - %s](${PROJECT_URL}/limestone/commit/%H)" -1 HEAD)
- shirakami $(git -C ${TG_SHIRAKAMI_DIR} log --pretty="format:[%h - %s](${PROJECT_URL}/shirakami/commit/%H)" -1 HEAD)
- yakushima $(git -C ${TG_YAKUSHIMA_DIR} log --pretty="format:[%h - %s](${PROJECT_URL}/yakushima/commit/%H)" -1 HEAD)
- sharksfin $(git -C ${TG_SHARKSFIN_DIR} log --pretty="format:[%h - %s](${PROJECT_URL}/sharksfin/commit/%H)" -1 HEAD)
- takatori $(git -C ${TG_TAKATORI_DIR} log --pretty="format:[%h - %s](${PROJECT_URL}/takatori/commit/%H)" -1 HEAD)
- yugawara $(git -C ${TG_YUGAWARA_DIR} log --pretty="format:[%h - %s](${PROJECT_URL}/yugawara/commit/%H)" -1 HEAD)
- mizugaki $(git -C ${TG_MIZUGAKI_DIR} log --pretty="format:[%h - %s](${PROJECT_URL}/mizugaki/commit/%H)" -1 HEAD)
- tateyama $(git -C ${TG_TATEYAMA_DIR} log --pretty="format:[%h - %s](${PROJECT_URL}/tateyama/commit/%H)" -1 HEAD)
- shakujo $(git -C ${TG_SHAKUJO_DIR} log --pretty="format:[%h - %s](${PROJECT_URL}/shakujo/commit/%H)" -1 HEAD)
- metadata-manager $(git -C ${TG_METADATA_MANAGER_DIR} log --pretty="format:[%h - %s](${PROJECT_URL}/metadata-manager/commit/%H)" -1 HEAD)
- message-manager $(git -C ${TG_MESSAGE_MANAGER_DIR} log --pretty="format:[%h - %s](${PROJECT_URL}/message-manager/commit/%H)" -1 HEAD)
- tsubakuro $(git -C ${TG_TSUBAKURO_DIR} log --pretty="format:[%h - %s](${PROJECT_URL}/tsubakuro/commit/%H)" -1 HEAD)
- tanzawa $(git -C ${TG_TANZAWA_DIR} log --pretty="format:[%h - %s](${PROJECT_URL}/tanzawa/commit/%H)" -1 HEAD)
- harinoki $(git -C ${TG_HARINOKI_DIR} log --pretty="format:[%h - %s](${PROJECT_URL}/harinoki/commit/%H)" -1 HEAD)
"

echo "${BUILDINFO}"
