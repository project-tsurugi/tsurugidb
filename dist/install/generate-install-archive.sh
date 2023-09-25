#!/bin/bash -e

_SCRIPTS_DIR=$(cd "$(dirname $0)" && pwd)
TG_INSTALL_BASE_DIR=$(cd "$(dirname $_SCRIPTS_DIR)"/.. && pwd)

source ./dist/install/install-env.sh $TG_INSTALL_BASE_DIR

cd "$TG_INSTALL_BASE_DIR"

git clean -ffdx
git submodule foreach --recursive git clean -ffdx
mkdir build
mkdir .install

./dist/install/generate-buildinfo.sh > .install/BUILDINFO.md
cp -a .install/BUILDINFO.md .
echo "$(git -C ${TG_TSUBAKURO_DIR} log --pretty="format:%H" -1 HEAD)" > .install/TSUBAKURO_VERSION

TSURUGI_VERSION=$(grep -oP '(?<=^TSURUGI_VERSION:).*' ${TG_INSTALL_BASE_DIR}/BUILDINFO.md)
INSTALL_ARCHIVE_PATH="$TG_INSTALL_BASE_DIR/build/tsurugidb-${TSURUGI_VERSION}.tar.gz"

tar --exclude-vcs --exclude='.github' --exclude='*/third_party/googletest' -czf "${INSTALL_ARCHIVE_PATH}" .install *

rm -fr .install/
cd -

echo "Generated install archive: ${INSTALL_ARCHIVE_PATH}"
