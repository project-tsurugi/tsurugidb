#!/bin/bash -e

echo -e "\n[Install Tsurugi Authentication Server]"

JETTY_VERSION="12.0.25"

_SCRIPTS_DIR=$(cd "$(dirname $0)" && pwd)
JETTY_HOME="${TG_INSTALL_DIR}/lib/jetty"

if [ ! -f "${TG_INSTALL_BASE_DIR}/third_party/jetty-home-${JETTY_VERSION}.tar.gz" ]; then
  cd ${TG_INSTALL_BASE_DIR}/third_party
  curl --retry 3 --retry-all-errors -OL "https://repo1.maven.org/maven2/org/eclipse/jetty/jetty-home/${JETTY_VERSION}/jetty-home-${JETTY_VERSION}.tar.gz"
  cd $OLDPWD
fi

mkdir -p ${JETTY_HOME}
cd ${JETTY_HOME}
tar xf "${TG_INSTALL_BASE_DIR}/third_party/jetty-home-${JETTY_VERSION}.tar.gz" --strip-components 1
cd $OLDPWD

JETTY_BASE="${TSURUGI_BASE}/auth"
mkdir -p ${JETTY_BASE}

if "${MAKE_TSURUGI_BASE}"; then
  cd ${JETTY_BASE}
  mkdir -p "${JETTY_BASE}/webapps"

  mkdir -p "${JETTY_BASE}/etc"
  chmod 700 "${JETTY_BASE}/etc"

  mkdir -p "${JETTY_BASE}/logs"
  if [ "$EUID" -eq 0 ]; then
    chmod -R o+w "${JETTY_BASE}/logs"
  fi

  java -jar $JETTY_HOME/start.jar --add-module=http,ee9-deploy,console-capture,jaas

  openssl genpkey -quiet -algorithm RSA -pkeyopt rsa_keygen_bits:2048 -out "${JETTY_BASE}/etc/harinoki.pem"

  cp --preserve=timestamps "${_SCRIPTS_DIR}"/harinoki/conf/* ${JETTY_BASE}/etc

  chmod 600 ${JETTY_BASE}/etc/*
fi

cd ${TG_HARINOKI_DIR}
./gradlew clean assemble

cp -a ${TG_HARINOKI_DIR}/build/libs/harinoki.war ${TSURUGI_BASE}/auth/webapps

mkdir -p ${TG_INSTALL_DIR}/bin
cp --preserve=timestamps "${_SCRIPTS_DIR}/harinoki/bin/authentication-server" ${TG_INSTALL_DIR}/bin

echo "$(basename $0) successful."
