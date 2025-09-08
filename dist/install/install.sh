#!/bin/bash -e

_SCRIPTS_DIR=$(cd "$(dirname $0)" && pwd)
TG_INSTALL_BASE_DIR=$(cd "$(dirname $_SCRIPTS_DIR)"/.. && pwd)
export TG_INSTALL_BASE_DIR

while (( $# > 0 ))
do
  if [[ "$1" =~ "--prefix=" ]]; then
    _INSTALL_PREFIX=${1#--prefix=}
  elif [[ "$1" =~ "--buildtype=" ]]; then
    _BUILD_TYPE=${1#--buildtype=}
  elif [[ "$1" =~ "--parallel=" ]]; then
    _PARALLEL=${1#--parallel=}
  elif [[ "$1" == "--symbolic" ]]; then
    _SYMBOLIC=ON
  elif [[ "$1" =~ "--skip=" ]]; then
    _SKIP=${1#--skip=}
  elif [[ "$1" == "--verbose" ]]; then
    _VERBOSE=ON
  elif [[ "$1" =~ "--replaceconfig=" ]]; then
    _REPLACE_CONFIG=${1#--replaceconfig=}
  else
    echo "[ERROR] invalid option: $1" 1>&2
    exit 1
  fi
  shift
done

if [ "${_INSTALL_PREFIX}" = "" ]; then
  _INSTALL_PREFIX="/usr/lib"
fi
if [[ ! "$_INSTALL_PREFIX" = /* ]]; then
  echo "[ERROR] --prefix=path must be an absolute path." 1>&2
  exit 1
fi
if [ ! -d "${_INSTALL_PREFIX}" ]; then
  echo "[ERROR] --prefix=${_INSTALL_PREFIX} is not exist" 1>&2
  exit 1
fi

if [ "${_BUILD_TYPE}" = "" ]; then
  _BUILD_TYPE="RelWithDebInfo"
fi

export TG_CMAKE_BUILD_TYPE=${_BUILD_TYPE}
export TG_CMAKE_BUILD_PARALLEL=${_PARALLEL}
export TG_SKIP_INSTALL=${_SKIP}
export TG_VERBOSE_INSTALL=${_VERBOSE}

source ${_SCRIPTS_DIR}/install-util.sh

source ${_SCRIPTS_DIR}/install-env.sh ${TG_INSTALL_BASE_DIR}
if [ -f "${TG_INSTALL_BASE_DIR}/.install/BUILDINFO.md" ]; then
  cp -a "${TG_INSTALL_BASE_DIR}/.install/BUILDINFO.md" "${TG_INSTALL_BASE_DIR}/"
else
  ${_SCRIPTS_DIR}/generate-buildinfo.sh > ${TG_INSTALL_BASE_DIR}/BUILDINFO.md
fi
if [ "${TSURUGI_VERSION}" = "" ]; then
  TSURUGI_VERSION=$(grep -oP '(?<=^TSURUGI_VERSION:).*' ${TG_INSTALL_BASE_DIR}/BUILDINFO.md)
  export TSURUGI_VERSION
fi
export TG_INSTALL_DIR=${_INSTALL_PREFIX}/tsurugi-${TSURUGI_VERSION}

export TSURUGI_BASE=${TG_INSTALL_DIR}/var
if [ -d ${TSURUGI_BASE} ]; then
  export MAKE_TSURUGI_BASE=false
else
  export MAKE_TSURUGI_BASE=true
fi

export TG_COMMON_CMAKE_BUILD_OPTIONS="${TG_COMMON_CMAKE_BUILD_OPTIONS}"
export TG_COMMON_BUILD_TOOL_OPTIONS="${TG_COMMON_BUILD_TOOL_OPTIONS}"

if [ ! -v CXXFLAGS ]; then
  export CXXFLAGS="-march=native"
fi
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

_INSTALL_WARNING_MESSAGES=""

echo -e "\n[Install Tsurugi]"
echo "------------------------------------"
cat ${TG_INSTALL_BASE_DIR}/BUILDINFO.md
echo "------------------------------------"

mkdir -p "${TG_INSTALL_DIR}"
cp --preserve=timestamps "${TG_INSTALL_BASE_DIR}/BUILDINFO.md" ${TG_INSTALL_DIR}/

if [[ ! ${TG_SKIP_INSTALL} == *"server"* ]]; then
  if "${MAKE_TSURUGI_BASE}"; then
    mkdir -p "${TSURUGI_BASE}/etc"
    cp --preserve=timestamps "${_SCRIPTS_DIR}/conf/tsurugi.ini" ${TSURUGI_BASE}/etc/
    replace_config "${TSURUGI_BASE}/etc/tsurugi.ini" session.zone_offset="$(date +%:z),${_REPLACE_CONFIG}"

    mkdir -p "${TSURUGI_BASE}/data"
    if [ "$EUID" -eq 0 ]; then
      chmod -R o+w "${TSURUGI_BASE}/data"
    fi
  fi

  ${_SCRIPTS_DIR}/install-server.sh

  mkdir -p "${TG_INSTALL_DIR}/lib"
  if [ -f "${TG_INSTALL_BASE_DIR}/.install/tsurugi-info.json" ]; then
    cp -a "${TG_INSTALL_BASE_DIR}/.install/tsurugi-info.json" "${TG_INSTALL_DIR}/lib/"
  else
    ${_SCRIPTS_DIR}/generate-tsurugi-info.sh > "${TG_INSTALL_DIR}/lib/tsurugi-info.json"
  fi

  if [[ 1777 != $(stat --format=%a /var/lock/) ]]; then
    _WARNMSG=$(cat <<'EOF'

[WARNING] /var/lock/ is not set to 1777.
Tsurugi uses /var/lock/ as the default location to create the lock file at startup.
However, the permissions on /var/lock/ are currently not set to 1777, which prevents non-privileged users from writing to this directory.
If you are starting tsurugidb process as a non-privileged user, edit the system.pid_directory parameter in var/etc/tsurugi.ini accordingly.
EOF
  )
  _INSTALL_WARNING_MESSAGES="${_INSTALL_WARNING_MESSAGES}${_WARNMSG}"
  fi
fi

if [[ ! ${TG_SKIP_INSTALL} == *"nativelib"* ]]; then
  ${_SCRIPTS_DIR}/install-nativelib.sh
fi

if [[ ! ${TG_SKIP_INSTALL} == *"tanzawa"* ]]; then
  ${_SCRIPTS_DIR}/install-tanzawa-cli.sh
fi

if [[ ! ${TG_SKIP_INSTALL} == *"harinoki"* ]]; then
  ${_SCRIPTS_DIR}/install-harinoki.sh
fi

if [ -f "${_SCRIPTS_DIR}/install-dist-java.sh" ]; then
  ${_SCRIPTS_DIR}/install-dist-java.sh
fi

if [ -d "${TG_INSTALL_DIR}/bin" ]; then
  chmod +x ${TG_INSTALL_DIR}/bin/*
fi

if [ "${_SYMBOLIC}" = "ON" ]; then
  cd "${_INSTALL_PREFIX}"
  ln -nfs "tsurugi-${TSURUGI_VERSION}" "tsurugi"
  cd $OLDPWD
fi

echo "------------------------------------"
echo -e "[Install Tsurugi successful]"
echo "Install Directory: ${TG_INSTALL_DIR}"

if [ "${_INSTALL_WARNING_MESSAGES}" != "" ]; then
  echo "${_INSTALL_WARNING_MESSAGES}"
fi

echo "------------------------------------"
echo ""
