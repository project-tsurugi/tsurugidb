#!/bin/bash -e

if [ "${TG_VERBOSE_INSTALL}" = "ON" ]; then
  set -x
fi

if ldconfig -p | grep -F --quiet libmpdec++; then
  echo -e "\n[SKIPPED Install_mpdecimal]"
else
  echo -e "\n[Install mpdecimal]"
  if [ ! -f "${TG_INSTALL_BASE_DIR}/third_party/mpdecimal-2.5.1.tar.gz" ]; then
    cd ${TG_INSTALL_BASE_DIR}/third_party
    curl -OL https://www.bytereef.org/software/mpdecimal/releases/mpdecimal-2.5.1.tar.gz
    cd -
  fi
  mkdir build-mpdecimal
  cd build-mpdecimal
  tar xf ${TG_INSTALL_BASE_DIR}/third_party/mpdecimal-2.5.1.tar.gz
  cd mpdecimal-2.5.1
  ./configure --prefix="${TG_INSTALL_DIR}"
  make -j${TG_CMAKE_BUILD_PARALLEL}
  make install
  cd ../..
  rm -fr build-mpdecimal
fi

echo -e "\n[Install Takatori]"
cd "${TG_TAKATORI_DIR}"
if [ "clean" = "${TG_CLEAN_BUILD}" ]; then
  rm -fr build
fi
mkdir -p build
cd build
cmake -G Ninja -DCMAKE_BUILD_TYPE=${TG_CMAKE_BUILD_TYPE} -DCMAKE_CXX_FLAGS_RELWITHDEBINFO="${TG_CMAKE_CXX_FLAGS_RELWITHDEBINFO}" -DBUILD_TESTS=OFF -DBUILD_DOCUMENTS=OFF -DFORCE_INSTALL_RPATH=ON -DCMAKE_PREFIX_PATH="${TG_INSTALL_DIR}" -DCMAKE_INSTALL_PREFIX="${TG_INSTALL_DIR}" ${TG_COMMON_CMAKE_BUILD_OPTIONS} ..
cmake --build . --target install --parallel ${TG_CMAKE_BUILD_PARALLEL} -- ${TG_COMMON_BUILD_TOOL_OPTIONS}

echo -e "\n[Install hopscotch-map]"
cd "${TG_INSTALL_BASE_DIR}/third_party/hopscotch-map"
if [ "clean" = "${TG_CLEAN_BUILD}" ]; then
  rm -fr ../../build-hopscotch-map
fi
mkdir -p ../../build-hopscotch-map
cd ../../build-hopscotch-map
cmake -G Ninja -DCMAKE_BUILD_TYPE=${TG_CMAKE_BUILD_TYPE} -DCMAKE_CXX_FLAGS_RELWITHDEBINFO="${TG_CMAKE_CXX_FLAGS_RELWITHDEBINFO}" -DCMAKE_PREFIX_PATH="${TG_INSTALL_DIR}" -DCMAKE_INSTALL_PREFIX="${TG_INSTALL_DIR}" ${TG_COMMON_CMAKE_BUILD_OPTIONS} ../third_party/hopscotch-map
cmake --build . --target install --parallel ${TG_CMAKE_BUILD_PARALLEL} -- ${TG_COMMON_BUILD_TOOL_OPTIONS}

echo -e "\n[Install Yugawara]"
cd "${TG_YUGAWARA_DIR}"
if [ "clean" = "${TG_CLEAN_BUILD}" ]; then
  rm -fr build
fi
mkdir -p build
cd build
cmake -G Ninja -DCMAKE_BUILD_TYPE=${TG_CMAKE_BUILD_TYPE} -DCMAKE_CXX_FLAGS_RELWITHDEBINFO="${TG_CMAKE_CXX_FLAGS_RELWITHDEBINFO}" -DBUILD_TESTS=OFF -DBUILD_DOCUMENTS=OFF -DFORCE_INSTALL_RPATH=ON -DCMAKE_PREFIX_PATH="${TG_INSTALL_DIR}" -DCMAKE_INSTALL_PREFIX="${TG_INSTALL_DIR}" ${TG_COMMON_CMAKE_BUILD_OPTIONS} ..
cmake --build . --target install --parallel ${TG_CMAKE_BUILD_PARALLEL} -- ${TG_COMMON_BUILD_TOOL_OPTIONS}

echo -e "\n[Install Shakujo]"
cd "${TG_SHAKUJO_DIR}"
if [ "clean" = "${TG_CLEAN_BUILD}" ]; then
  rm -fr build
fi
mkdir -p build
cd build
cmake -G Ninja -DCMAKE_BUILD_TYPE=${TG_CMAKE_BUILD_TYPE} -DCMAKE_CXX_FLAGS_RELWITHDEBINFO="${TG_CMAKE_CXX_FLAGS_RELWITHDEBINFO}" -DBUILD_TESTS=OFF -DBUILD_DOCUMENTS=OFF -DBUILD_EXAMPLES=OFF -DFORCE_INSTALL_RPATH=ON -DCMAKE_PREFIX_PATH="${TG_INSTALL_DIR}" -DCMAKE_INSTALL_PREFIX="${TG_INSTALL_DIR}" ${TG_COMMON_CMAKE_BUILD_OPTIONS} ..
cmake --build . --target install --parallel ${TG_CMAKE_BUILD_PARALLEL} -- ${TG_COMMON_BUILD_TOOL_OPTIONS}

echo -e "\n[Install Mizugaki]"
cd "${TG_MIZUGAKI_DIR}"
if [ "clean" = "${TG_CLEAN_BUILD}" ]; then
  rm -fr build
fi
mkdir -p build
cd build
cmake -G Ninja -DCMAKE_BUILD_TYPE=${TG_CMAKE_BUILD_TYPE} -DCMAKE_CXX_FLAGS_RELWITHDEBINFO="${TG_CMAKE_CXX_FLAGS_RELWITHDEBINFO}" -DBUILD_TESTS=OFF -DBUILD_DOCUMENTS=OFF -DBUILD_EXAMPLES=OFF -DFORCE_INSTALL_RPATH=ON -DCMAKE_PREFIX_PATH="${TG_INSTALL_DIR}" -DCMAKE_INSTALL_PREFIX="${TG_INSTALL_DIR}" ${TG_COMMON_CMAKE_BUILD_OPTIONS} ..
cmake --build . --target install --parallel ${TG_CMAKE_BUILD_PARALLEL} -- ${TG_COMMON_BUILD_TOOL_OPTIONS}

echo -e "\n[Install Limestone]"
cd "${TG_LIMESTONE_DIR}"
if [ "clean" = "${TG_CLEAN_BUILD}" ]; then
  rm -fr build
fi
mkdir -p build
cd build
cmake -G Ninja -DCMAKE_BUILD_TYPE=${TG_CMAKE_BUILD_TYPE} -DCMAKE_CXX_FLAGS_RELWITHDEBINFO="${TG_CMAKE_CXX_FLAGS_RELWITHDEBINFO}" -DBUILD_TESTS=OFF -DBUILD_DOCUMENTS=OFF -DBUILD_EXAMPLES=OFF -DFORCE_INSTALL_RPATH=ON -DCMAKE_PREFIX_PATH="${TG_INSTALL_DIR}" -DCMAKE_INSTALL_PREFIX="${TG_INSTALL_DIR}" -DRECOVERY_SORTER_KVSLIB=ROCKSDB -DRECOVERY_SORTER_PUT_ONLY=ON ${TG_COMMON_CMAKE_BUILD_OPTIONS} ..
cmake --build . --target install --parallel ${TG_CMAKE_BUILD_PARALLEL} -- ${TG_COMMON_BUILD_TOOL_OPTIONS}

echo -e "\n[Install Yakushima]"
cd "${TG_YAKUSHIMA_DIR}"
if [ "clean" = "${TG_CLEAN_BUILD}" ]; then
  rm -fr build
fi
mkdir -p build
cd build
cmake -G Ninja -DCMAKE_BUILD_TYPE=${TG_CMAKE_BUILD_TYPE} -DCMAKE_CXX_FLAGS_RELWITHDEBINFO="${TG_CMAKE_CXX_FLAGS_RELWITHDEBINFO}" -DBUILD_TESTS=OFF -DBUILD_DOCUMENTS=OFF -DBUILD_BENCHMARK=OFF -DFORCE_INSTALL_RPATH=ON -DCMAKE_PREFIX_PATH="${TG_INSTALL_DIR}" -DCMAKE_INSTALL_PREFIX="${TG_INSTALL_DIR}" ${TG_COMMON_CMAKE_BUILD_OPTIONS} ..
cmake --build . --target install --parallel ${TG_CMAKE_BUILD_PARALLEL} -- ${TG_COMMON_BUILD_TOOL_OPTIONS}

echo -e "\n[Install Shirakami]"
cd "${TG_SHIRAKAMI_DIR}"
if [ "clean" = "${TG_CLEAN_BUILD}" ]; then
  rm -fr build
fi
if [ "Debug" = "${TG_CMAKE_BUILD_TYPE}" ]; then
  _TSURUGI_FAST_SHUTDOWN=OFF
else
  _TSURUGI_FAST_SHUTDOWN=ON
fi
mkdir -p build
cd build
cmake -G Ninja -DCMAKE_BUILD_TYPE=${TG_CMAKE_BUILD_TYPE} -DCMAKE_CXX_FLAGS_RELWITHDEBINFO="${TG_CMAKE_CXX_FLAGS_RELWITHDEBINFO}" -DBUILD_TESTS=OFF -DBUILD_DOCUMENTS=OFF -DBUILD_BENCHMARK=OFF -DTSURUGI_FAST_SHUTDOWN=${_TSURUGI_FAST_SHUTDOWN} -DFORCE_INSTALL_RPATH=ON -DCMAKE_PREFIX_PATH="${TG_INSTALL_DIR}" -DCMAKE_INSTALL_PREFIX="${TG_INSTALL_DIR}" "${TG_SHIRAKAMI_OPTIONS}" ${TG_COMMON_CMAKE_BUILD_OPTIONS} ..
cmake --build . --target install --parallel ${TG_CMAKE_BUILD_PARALLEL} -- ${TG_COMMON_BUILD_TOOL_OPTIONS}

echo -e "\n[Install Sharksfin]"
cd "${TG_SHARKSFIN_DIR}"
if [ "clean" = "${TG_CLEAN_BUILD}" ]; then
  rm -fr build
fi
mkdir -p build
cd build
cmake -G Ninja -DCMAKE_BUILD_TYPE=${TG_CMAKE_BUILD_TYPE} -DCMAKE_CXX_FLAGS_RELWITHDEBINFO="${TG_CMAKE_CXX_FLAGS_RELWITHDEBINFO}" -DBUILD_TESTS=OFF -DBUILD_DOCUMENTS=OFF -DBUILD_EXAMPLES=OFF -DFORCE_INSTALL_RPATH=ON -DCMAKE_PREFIX_PATH="${TG_INSTALL_DIR}" -DCMAKE_INSTALL_PREFIX="${TG_INSTALL_DIR}" ${TG_COMMON_CMAKE_BUILD_OPTIONS} ..
cmake --build . --target install --parallel ${TG_CMAKE_BUILD_PARALLEL} -- ${TG_COMMON_BUILD_TOOL_OPTIONS}

echo -e "\n[Install moodycamel::ConcurrentQueue]"
cd "${TG_INSTALL_BASE_DIR}/third_party/concurrentqueue"
if [ "clean" = "${TG_CLEAN_BUILD}" ]; then
  rm -fr ../../build-concurrentqueue
fi
mkdir -p ../../build-concurrentqueue
cd ../../build-concurrentqueue
cmake -G Ninja -DCMAKE_BUILD_TYPE=${TG_CMAKE_BUILD_TYPE} -DCMAKE_CXX_FLAGS_RELWITHDEBINFO="${TG_CMAKE_CXX_FLAGS_RELWITHDEBINFO}" -DCMAKE_PREFIX_PATH="${TG_INSTALL_DIR}" -DCMAKE_INSTALL_PREFIX="${TG_INSTALL_DIR}" ${TG_COMMON_CMAKE_BUILD_OPTIONS} ../third_party/concurrentqueue
cmake --build . --target install --parallel ${TG_CMAKE_BUILD_PARALLEL} -- ${TG_COMMON_BUILD_TOOL_OPTIONS}

echo -e "\n[Install Tateyama]"
cd "${TG_TATEYAMA_DIR}"
if [ "clean" = "${TG_CLEAN_BUILD}" ]; then
  rm -fr build
fi
mkdir -p build
cd build
cmake -G Ninja -DCMAKE_BUILD_TYPE=${TG_CMAKE_BUILD_TYPE} -DCMAKE_CXX_FLAGS_RELWITHDEBINFO="${TG_CMAKE_CXX_FLAGS_RELWITHDEBINFO}" -DBUILD_TESTS=OFF -DBUILD_DOCUMENTS=OFF -DBUILD_BENCHMARK=OFF -DBUILD_EXAMPLES=OFF -DPERFORMANCE_TOOLS=OFF -DFORCE_INSTALL_RPATH=ON -DCMAKE_PREFIX_PATH="${TG_INSTALL_DIR}" -DCMAKE_INSTALL_PREFIX="${TG_INSTALL_DIR}" -DSHARKSFIN_IMPLEMENTATION=shirakami ${TG_COMMON_CMAKE_BUILD_OPTIONS} ..
cmake --build . --target install --parallel ${TG_CMAKE_BUILD_PARALLEL} -- ${TG_COMMON_BUILD_TOOL_OPTIONS}

echo -e "\n[Install Jogasaki]"
cd "${TG_JOGASAKI_DIR}"
if [ "clean" = "${TG_CLEAN_BUILD}" ]; then
  rm -fr build-shirakami
fi
mkdir -p build-shirakami
cd build-shirakami
cmake -G Ninja -DCMAKE_BUILD_TYPE=${TG_CMAKE_BUILD_TYPE} -DCMAKE_CXX_FLAGS_RELWITHDEBINFO="${TG_CMAKE_CXX_FLAGS_RELWITHDEBINFO}" -DBUILD_TESTS=OFF -DBUILD_DOCUMENTS=OFF -DBUILD_EXAMPLES=OFF -DPERFORMANCE_TOOLS=OFF -DFORCE_INSTALL_RPATH=ON -DCMAKE_PREFIX_PATH="${TG_INSTALL_DIR}" -DCMAKE_INSTALL_PREFIX="${TG_INSTALL_DIR}" -DSHARKSFIN_IMPLEMENTATION=shirakami ${TG_COMMON_CMAKE_BUILD_OPTIONS} ..
cmake --build . --target install --parallel ${TG_CMAKE_BUILD_PARALLEL} -- ${TG_COMMON_BUILD_TOOL_OPTIONS}

if [[ ! ${TG_SKIP_INSTALL} == *"ogawayama"* ]]; then
OPT_OGAWAYAMA=ON

echo -e "\n[Install Metadata Manager]"
cd "${TG_METADATA_MANAGER_DIR}"
if [ "clean" = "${TG_CLEAN_BUILD}" ]; then
  rm -fr build
fi
mkdir -p build
cd build
cmake -G Ninja -DCMAKE_BUILD_TYPE=${TG_CMAKE_BUILD_TYPE} -DCMAKE_CXX_FLAGS_RELWITHDEBINFO="${TG_CMAKE_CXX_FLAGS_RELWITHDEBINFO}" -DBUILD_TESTS=OFF -DFORCE_INSTALL_RPATH=ON -DCMAKE_PREFIX_PATH="${TG_INSTALL_DIR}" -DCMAKE_INSTALL_PREFIX="${TG_INSTALL_DIR}" -DDATA_STORAGE=postgresql ${TG_COMMON_CMAKE_BUILD_OPTIONS} ..
cmake --build . --target install --parallel ${TG_CMAKE_BUILD_PARALLEL} -- ${TG_COMMON_BUILD_TOOL_OPTIONS}

echo -e "\n[Install Message Manager]"
cd "${TG_MESSAGE_MANAGER_DIR}"
if [ "clean" = "${TG_CLEAN_BUILD}" ]; then
  rm -fr build
fi
mkdir -p build
cd build
cmake -G Ninja -DCMAKE_BUILD_TYPE=${TG_CMAKE_BUILD_TYPE} -DCMAKE_CXX_FLAGS_RELWITHDEBINFO="${TG_CMAKE_CXX_FLAGS_RELWITHDEBINFO}" -DBUILD_TESTS=OFF -DFORCE_INSTALL_RPATH=ON -DCMAKE_PREFIX_PATH="${TG_INSTALL_DIR}" -DCMAKE_INSTALL_PREFIX="${TG_INSTALL_DIR}" ${TG_COMMON_CMAKE_BUILD_OPTIONS} ..
cmake --build . --target install --parallel ${TG_CMAKE_BUILD_PARALLEL} -- ${TG_COMMON_BUILD_TOOL_OPTIONS}

echo -e "\n[Install Ogawayama]"
cd ${TG_OGAWAYAMA_DIR}
if [ "clean" = "${TG_CLEAN_BUILD}" ]; then
  rm -fr build
fi
mkdir -p build
cd build
cmake -G Ninja -DCMAKE_BUILD_TYPE=${TG_CMAKE_BUILD_TYPE} -DCMAKE_CXX_FLAGS_RELWITHDEBINFO="${TG_CMAKE_CXX_FLAGS_RELWITHDEBINFO}" -DBUILD_TESTS=OFF -DSHARKSFIN_IMPLEMENTATION=shirakami -DFORCE_INSTALL_RPATH=ON -DCMAKE_PREFIX_PATH="${TG_INSTALL_DIR}" -DCMAKE_INSTALL_PREFIX="${TG_INSTALL_DIR}" -DCMAKE_MODULE_PATH="${TG_INSTALL_DIR}" ${TG_COMMON_CMAKE_BUILD_OPTIONS} ..
cmake --build . --target install --parallel ${TG_CMAKE_BUILD_PARALLEL} -- ${TG_COMMON_BUILD_TOOL_OPTIONS}

else
OPT_OGAWAYAMA=OFF
fi

echo -e "\n[Install Tateyama Bootstrap]"
cd ${TG_TATEYAMA_BOOTSTRAP_DIR}
if [ "clean" = "${TG_CLEAN_BUILD}" ]; then
  rm -fr build
fi
mkdir -p build
cd build
cmake -G Ninja -DCMAKE_BUILD_TYPE=${TG_CMAKE_BUILD_TYPE} -DCMAKE_CXX_FLAGS_RELWITHDEBINFO="${TG_CMAKE_CXX_FLAGS_RELWITHDEBINFO}" -DBUILD_TESTS=OFF -DSHARKSFIN_IMPLEMENTATION=shirakami -DOGAWAYAMA=${OPT_OGAWAYAMA} -DFORCE_INSTALL_RPATH=ON -DCMAKE_PREFIX_PATH="${TG_INSTALL_DIR}" -DCMAKE_INSTALL_PREFIX="${TG_INSTALL_DIR}" -DENABLE_JEMALLOC=${TG_ENABLE_JEMALLOC} ${TG_COMMON_CMAKE_BUILD_OPTIONS} ..
cmake --build . --target install --parallel ${TG_CMAKE_BUILD_PARALLEL} -- ${TG_COMMON_BUILD_TOOL_OPTIONS}

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
