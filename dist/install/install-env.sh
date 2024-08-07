#!/bin/bash -e

TG_INSTALL_BASE_DIR=$1
export TG_INSTALL_BASE_DIR

if [ "${TG_RELEASE_TSURUGI_VERSION}" != "" ]; then
  export TSURUGI_VERSION="${TG_RELEASE_TSURUGI_VERSION}"
fi

_TATEYAMA_BOOTSTRAP_DIR="${TG_INSTALL_BASE_DIR}/tateyama-bootstrap"
_JOGASAKI_DIR="${TG_INSTALL_BASE_DIR}/jogasaki"
_OGAWAYAMA_DIR="${TG_INSTALL_BASE_DIR}/ogawayama"
_TATEYAMA_DIR="${TG_INSTALL_BASE_DIR}/tateyama"
_SHARKSFIN_DIR="${TG_INSTALL_BASE_DIR}/sharksfin"
_SHIRAKAMI_DIR="${TG_INSTALL_BASE_DIR}/shirakami"
_YAKUSHIMA_DIR="${TG_INSTALL_BASE_DIR}/yakushima"
_LIMESTONE_DIR="${TG_INSTALL_BASE_DIR}/limestone"
_MIZUGAKI_DIR="${TG_INSTALL_BASE_DIR}/mizugaki"
_YUGAWARA_DIR="${TG_INSTALL_BASE_DIR}/yugawara"
_TAKATORI_DIR="${TG_INSTALL_BASE_DIR}/takatori"

_TSUBAKURO_DIR="${TG_INSTALL_BASE_DIR}/tsubakuro"
_TANZAWA_DIR="${TG_INSTALL_BASE_DIR}/tanzawa"
_HARINOKI_DIR="${TG_INSTALL_BASE_DIR}/harinoki"

if [ "${TG_TATEYAMA_BOOTSTRAP_DIR}" = "" ]; then
  export TG_TATEYAMA_BOOTSTRAP_DIR="${_TATEYAMA_BOOTSTRAP_DIR}"
fi
if [ ! -d "${TG_TATEYAMA_BOOTSTRAP_DIR}" ]; then
  echo "TG_TATEYAMA_BOOTSTRAP_DIR (${TG_TATEYAMA_BOOTSTRAP_DIR}) is not exist" 1>&2
  exit 1
fi
if [ ! -f "${TG_TATEYAMA_BOOTSTRAP_DIR}"/CMakeLists.txt ]; then
  echo "${TG_TATEYAMA_BOOTSTRAP_DIR}/CMakeLists.txt is not exist" 1>&2
  echo "Perhaps you have not checkout the submodules in this repository"
  echo "Try to: git submodule update --init --recursive"
  exit 1
fi


if [ "${TG_JOGASAKI_DIR}" = "" ]; then
  export TG_JOGASAKI_DIR="${_JOGASAKI_DIR}"
fi
if [ ! -d "${TG_JOGASAKI_DIR}" ]; then
  echo "TG_JOGASAKI_DIR (${TG_JOGASAKI_DIR}) is not exist" 1>&2
  exit 1
fi

if [ "${TG_OGAWAYAMA_DIR}" = "" ]; then
  export TG_OGAWAYAMA_DIR="${_OGAWAYAMA_DIR}"
fi
if [ ! -d "${TG_OGAWAYAMA_DIR}" ]; then
  echo "TG_OGAWAYAMA_DIR (${TG_OGAWAYAMA_DIR}) is not exist" 1>&2
  exit 1
fi

if [ "${TG_TATEYAMA_DIR}" = "" ]; then
  export TG_TATEYAMA_DIR="${_TATEYAMA_DIR}"
fi
if [ ! -d "${TG_TATEYAMA_DIR}" ]; then
  echo "TG_TATEYAMA_DIR (${TG_TATEYAMA_DIR}) is not exist" 1>&2
  exit 1
fi

if [ "${TG_SHARKSFIN_DIR}" = "" ]; then
  export TG_SHARKSFIN_DIR="${_SHARKSFIN_DIR}"
fi
if [ ! -d "${TG_SHARKSFIN_DIR}" ]; then
  echo "TG_SHARKSFIN_DIR (${TG_SHARKSFIN_DIR}) is not exist" 1>&2
  exit 1
fi

if [ "${TG_SHIRAKAMI_DIR}" = "" ]; then
  export TG_SHIRAKAMI_DIR="${_SHIRAKAMI_DIR}"
fi
if [ ! -d "${TG_SHIRAKAMI_DIR}" ]; then
  echo "TG_SHIRAKAMI_DIR (${TG_SHIRAKAMI_DIR}) is not exist" 1>&2
  exit 1
fi

if [ "${TG_YAKUSHIMA_DIR}" = "" ]; then
  export TG_YAKUSHIMA_DIR="${_YAKUSHIMA_DIR}"
fi
if [ ! -d "${TG_YAKUSHIMA_DIR}" ]; then
  echo "TG_YAKUSHIMA_DIR (${TG_YAKUSHIMA_DIR}) is not exist" 1>&2
  exit 1
fi

if [ "${TG_LIMESTONE_DIR}" = "" ]; then
  export TG_LIMESTONE_DIR="${_LIMESTONE_DIR}"
fi
if [ ! -d "${TG_LIMESTONE_DIR}" ]; then
  echo "TG_LIMESTONE_DIR (${TG_LIMESTONE_DIR}) is not exist" 1>&2
  exit 1
fi

if [ "${TG_MIZUGAKI_DIR}" = "" ]; then
  export TG_MIZUGAKI_DIR="${_MIZUGAKI_DIR}"
fi
if [ ! -d "${TG_MIZUGAKI_DIR}" ]; then
  echo "TG_MIZUGAKI_DIR (${TG_MIZUGAKI_DIR}) is not exist" 1>&2
  exit 1
fi

if [ "${TG_YUGAWARA_DIR}" = "" ]; then
  export TG_YUGAWARA_DIR="${_YUGAWARA_DIR}"
fi
if [ ! -d "${TG_YUGAWARA_DIR}" ]; then
  echo "TG_YUGAWARA_DIR (${TG_YUGAWARA_DIR}) is not exist" 1>&2
  exit 1
fi

if [ "${TG_TAKATORI_DIR}" = "" ]; then
  export TG_TAKATORI_DIR="${_TAKATORI_DIR}"
fi
if [ ! -d "${TG_TAKATORI_DIR}" ]; then
  echo "TG_TAKATORI_DIR (${TG_TAKATORI_DIR}) is not exist" 1>&2
  exit 1
fi

if [ "${TG_TSUBAKURO_DIR}" = "" ]; then
  export TG_TSUBAKURO_DIR="${_TSUBAKURO_DIR}"
fi
if [ ! -d "${TG_TSUBAKURO_DIR}" ]; then
  echo "TG_TSUBAKURO_DIR (${TG_TSUBAKURO_DIR}) is not exist" 1>&2
  exit 1
fi

if [ "${TG_TANZAWA_DIR}" = "" ]; then
  export TG_TANZAWA_DIR="${_TANZAWA_DIR}"
fi
if [ ! -d "${TG_TANZAWA_DIR}" ]; then
  echo "TG_TANZAWA_DIR (${TG_TANZAWA_DIR}) is not exist" 1>&2
  exit 1
fi

if [ "${TG_HARINOKI_DIR}" = "" ]; then
  export TG_HARINOKI_DIR="${_HARINOKI_DIR}"
fi
if [ ! -d "${TG_HARINOKI_DIR}" ]; then
  echo "TG_HARINOKI_DIR (${TG_HARINOKI_DIR}) is not exist" 1>&2
  exit 1
fi
