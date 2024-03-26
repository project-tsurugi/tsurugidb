#!/bin/bash -e

ARCHIVE_OUTPUT_DIR=$1
if [ "${ARCHIVE_OUTPUT_DIR}" = "" ]; then
  ARCHIVE_OUTPUT_DIR="."
fi

_SCRIPTS_DIR=$(cd "$(dirname $0)" && pwd)
TG_INSTALL_BASE_DIR=$(cd "$(dirname $_SCRIPTS_DIR)"/.. && pwd)

source ./dist/install/install-env.sh $TG_INSTALL_BASE_DIR

cd "$TG_INSTALL_BASE_DIR"

git clean -ffdx
git submodule foreach --recursive git clean -ffdx
mkdir .install

./dist/install/generate-buildinfo.sh > .install/BUILDINFO.md
./dist/install/generate-tsurugi-info.sh > .install/tsurugi-info.json

cp -a .install/BUILDINFO.md .
echo "$(git -C ${TG_TSUBAKURO_DIR} log --pretty="format:%H" -1 HEAD)" > .install/TSUBAKURO_VERSION
if [ "${TSURUGI_VERSION}" = "" ]; then
  TSURUGI_VERSION=$(grep -oP '(?<=^TSURUGI_VERSION:).*' ${TG_INSTALL_BASE_DIR}/BUILDINFO.md)
fi

BUILD_WORK_DIR="$TG_INSTALL_BASE_DIR/.build"
ARCHIVE_FILE_NAME="tsurugidb-${TSURUGI_VERSION}.tar.gz"

mkdir "$BUILD_WORK_DIR"
INSTALL_ARCHIVE_PATH="$BUILD_WORK_DIR/$ARCHIVE_FILE_NAME"

tar --exclude-vcs --exclude='.github' --exclude='*/third_party/googletest' -czf "${INSTALL_ARCHIVE_PATH}" .install *

rm -fr .install/
cd $OLDPWD

mkdir -p "$ARCHIVE_OUTPUT_DIR"
cp "$INSTALL_ARCHIVE_PATH" "$ARCHIVE_OUTPUT_DIR"

rm -fr "$BUILD_WORK_DIR"

echo "Generated install archive: $ARCHIVE_OUTPUT_DIR/$ARCHIVE_FILE_NAME"
