#!/bin/bash -e

echo -e "\n[Install Tanzawa CLI]"

cd ${TG_TSUBAKURO_DIR}
./gradlew clean PublishToMavenLocal -PskipBuildNative -x javadoc

cd ${TG_TANZAWA_DIR}
./gradlew clean tgsql:cli:shadowDistTar tgdump:cli:shadowDistTar -PmavenLocal

cd ${TG_INSTALL_DIR}
tar xf ${TG_TANZAWA_DIR}/modules/tgsql/cli/build/distributions/tgsql-*-shadow.tar.gz --strip-components 1
tar xf ${TG_TANZAWA_DIR}/modules/tgdump/cli/build/distributions/tgdump-*-shadow.tar.gz --strip-components 1

echo "$(basename $0) successful."
