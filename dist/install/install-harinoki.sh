#!/bin/bash -e

echo -e "\n[Install Tsurugi Authentication Server]"

_SCRIPTS_DIR=$(cd "$(dirname $0)" && pwd)
JETTY_HOME="${TG_INSTALL_DIR}/lib/jetty"

if [ ! -f "${TG_INSTALL_BASE_DIR}/third_party/jetty-home-11.0.16.tar.gz" ]; then
  cd ${TG_INSTALL_BASE_DIR}/third_party
  curl -OL https://repo1.maven.org/maven2/org/eclipse/jetty/jetty-home/11.0.16/jetty-home-11.0.16.tar.gz
  cd -
fi

mkdir -p ${JETTY_HOME}
cd ${JETTY_HOME}
tar xf ${TG_INSTALL_BASE_DIR}/third_party/jetty-home-*.tar.gz --strip-components 1
cd -

JETTY_BASE="${TSURUGI_BASE}/auth"
mkdir -p ${JETTY_BASE}

if "${MAKE_TSURUGI_BASE}"; then
  cd ${JETTY_BASE}
  mkdir -p "${JETTY_BASE}/webapps"
  mkdir -p "${JETTY_BASE}/etc"
  mkdir -p "${JETTY_BASE}/logs"

  java -jar $JETTY_HOME/start.jar --add-module=http,deploy,console-capture,jaas

  cat <<EOF > $JETTY_BASE/etc/jaas-login-service.xml
<?xml version="1.0"?>
<!DOCTYPE Configure PUBLIC "-//Jetty//Configure//EN" "https://www.eclipse.org/jetty/configure_10_0.dtd">
<Configure id="Server" class="org.eclipse.jetty.server.Server">
    <Call name="addBean">
    <Arg>
        <New class="org.eclipse.jetty.jaas.JAASLoginService">
        <Set name="name">harinoki</Set>
        <Set name="LoginModuleName">harinoki-login</Set>
        </New>
    </Arg>
    </Call>
</Configure>
EOF

cat <<EOF > $JETTY_BASE/etc/login.conf
harinoki-login {
    org.eclipse.jetty.jaas.spi.PropertyFileLoginModule required
    file="etc/harinoki-users.props";
};
EOF

cat <<EOF > $JETTY_BASE/etc/harinoki-users.props
tsurugi: password,harinoki-user
EOF

fi

cd ${TG_HARINOKI_DIR}
./gradlew clean assemble

cp -a ${TG_HARINOKI_DIR}/build/libs/harinoki.war ${TSURUGI_BASE}/auth/webapps

cp -r --preserve=timestamps "${_SCRIPTS_DIR}/bin/authentication-server" ${TG_INSTALL_DIR}/bin

echo "$(basename $0) successful."
