#!/bin/bash -e

if [ "${TG_VERBOSE_INSTALL}" = "ON" ]; then
  set -x
  export VERBOSE=1
fi

echo -e "\n[Install Tsubakuro Native Library]"
cd ${TG_TSUBAKURO_DIR}
if [ -f "${TG_INSTALL_BASE_DIR}/.install/TSUBAKURO_VERSION" ]; then
  _TSUBAKURO_LIBRARY_VERSION=$(cat "${TG_INSTALL_BASE_DIR}/.install/TSUBAKURO_VERSION")
else
  _TSUBAKURO_LIBRARY_VERSION=$(git -C ${TG_TSUBAKURO_DIR} log --pretty="format:%H" -1 HEAD)
fi
cd modules/ipc/src/main/native
if [ "clean" = "${TG_CLEAN_BUILD}" ]; then
  rm -fr build
fi
mkdir -p build
cd build
cmake -G Ninja -DCMAKE_BUILD_TYPE=${TG_CMAKE_BUILD_TYPE} -DCMAKE_CXX_FLAGS_RELWITHDEBINFO="${TG_CMAKE_CXX_FLAGS_RELWITHDEBINFO}" -DCMAKE_PREFIX_PATH="${TG_INSTALL_DIR}" -DCMAKE_INSTALL_PREFIX="${TG_INSTALL_DIR}" -DTSUBAKURO_LIBRARY_VERSION=${_TSUBAKURO_LIBRARY_VERSION} ${TG_COMMON_CMAKE_BUILD_OPTIONS} ..
cmake --build . --target install --parallel ${TG_CMAKE_BUILD_PARALLEL} -- ${TG_COMMON_BUILD_TOOL_OPTIONS}

if [ "${TG_VERBOSE_INSTALL}" = "ON" ]; then
  set +x
fi

echo "$(basename $0) successful."
