#!/bin/bash -e

_SCRIPTS_DIR=$(cd "$(dirname $0)" && pwd)
TG_INSTALL_BASE_DIR=$(cd "$(dirname $_SCRIPTS_DIR)"/.. && pwd)
export TG_INSTALL_BASE_DIR

while (( $# > 0 ))
do
  if [[ "$1" =~ "--prefix=" ]]; then
    _INSTALL_PREFIX=${1#--prefix=}
  fi
  if [[ "$1" =~ "--buildtype=" ]]; then
    _BUILD_TYPE=${1#--buildtype=}
  fi
  if [[ "$1" =~ "--parallel=" ]]; then
    _PARALLEL=${1#--parallel=}
  fi
  if [[ "$1" == "--symbolic" ]]; then
    _SYMBOLIC=ON
  fi

  if [[ "$1" =~ "--skip=" ]]; then
    _SKIP=${1#--skip=}
  fi

  shift
done

if [ "${_INSTALL_PREFIX}" = "" ]; then
  _INSTALL_PREFIX="/usr/lib"
fi

if [ "${_BUILD_TYPE}" = "" ]; then
  _BUILD_TYPE="RelWithDebInfo"
fi

export TG_CMAKE_BUILD_TYPE=${_BUILD_TYPE}
export TG_CMAKE_BUILD_PARALLEL=${_PARALLEL}
export TG_SKIP_INSTALL=${_SKIP}

source ${_SCRIPTS_DIR}/install-env.sh ${TG_INSTALL_BASE_DIR}
if [ -f "${TG_INSTALL_BASE_DIR}/.install/BUILDINFO.md" ]; then
  cp -a "${TG_INSTALL_BASE_DIR}/.install/BUILDINFO.md" "${TG_INSTALL_BASE_DIR}"
else
  ${_SCRIPTS_DIR}/generate-buildinfo.sh > ${TG_INSTALL_BASE_DIR}/BUILDINFO.md
fi

TSURUGI_VERSION=$(grep -oP '(?<=^TSURUGI_VERSION:).*' ${TG_INSTALL_BASE_DIR}/BUILDINFO.md)
export TSURUGI_VERSION
export TG_INSTALL_DIR=${_INSTALL_PREFIX}/tsurugi-${TSURUGI_VERSION}

export TSURUGI_BASE=${TG_INSTALL_DIR}/var
if [ -d ${TSURUGI_BASE} ]; then
  export MAKE_TSURUGI_BASE=false
else
  export MAKE_TSURUGI_BASE=true
fi

export TG_COMMON_CMAKE_BUILD_OPTIONS="${TG_COMMON_CMAKE_BUILD_OPTIONS}"
export TG_COMMON_BUILD_TOOL_OPTIONS="${TG_COMMON_BUILD_TOOL_OPTIONS}"

if [ "${TG_CMAKE_CXX_FLAGS_RELWITHDEBINFO}" = "" ]; then
  export TG_CMAKE_CXX_FLAGS_RELWITHDEBINFO="-O2 -g"
else
  export TG_CMAKE_CXX_FLAGS_RELWITHDEBINFO="${TG_CMAKE_CXX_FLAGS_RELWITHDEBINFO}"
fi

if [ "${TG_CLEAN_BUILD}" = "" ]; then
  export TG_CLEAN_BUILD="clean"
else
  export TG_CLEAN_BUILD="${TG_CLEAN_BUILD}"
fi

if [ "${TG_ENABLE_JEMALLOC}" = "" ]; then
  export TG_ENABLE_JEMALLOC="ON"
else
  export TG_ENABLE_JEMALLOC="${TG_ENABLE_JEMALLOC}"
fi

export TG_SHIRAKAMI_OPTIONS="${TG_SHIRAKAMI_OPTIONS}"

echo -e "\n[Install Tsurugi]"
echo "------------------------------------"
cat ${TG_INSTALL_BASE_DIR}/BUILDINFO.md
echo "------------------------------------"

mkdir -p "${TG_INSTALL_DIR}"
cp --preserve=timestamps "${TG_INSTALL_BASE_DIR}/BUILDINFO.md" ${TG_INSTALL_DIR}

if "${MAKE_TSURUGI_BASE}"; then
  mkdir -p "${TSURUGI_BASE}/etc"
  cp --preserve=timestamps "${_SCRIPTS_DIR}/conf/tsurugi.ini" ${TSURUGI_BASE}/etc

  mkdir -p "${TSURUGI_BASE}/data"
  if [ "$EUID" -eq 0 ]; then
    chmod -R o+w "${TSURUGI_BASE}/data"
  fi
fi

${_SCRIPTS_DIR}/install-server.sh

if [[ ! ${TG_SKIP_INSTALL} == *"tanzawa"* ]]; then
  ${_SCRIPTS_DIR}/install-tanzawa-cli.sh
fi

if [[ ! ${TG_SKIP_INSTALL} == *"harinoki"* ]]; then
  ${_SCRIPTS_DIR}/install-harinoki.sh
fi

if [ -f "${_SCRIPTS_DIR}/install-dist-java.sh" ]; then
  ${_SCRIPTS_DIR}/install-dist-java.sh
fi

chmod +x ${TG_INSTALL_DIR}/bin/*

if [ "${_SYMBOLIC}" = "ON" ]; then
  cd "${_INSTALL_PREFIX}"
  ln -nfs "tsurugi-${TSURUGI_VERSION}" "tsurugi"
  cd -
fi

echo "------------------------------------"
echo -e "[Install Tsurugi successful]"
echo "Install Directory: ${TG_INSTALL_DIR}"
echo "------------------------------------"
