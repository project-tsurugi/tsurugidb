#!/bin/bash -e

echo -e "\n[Install Tanzawa CLI]"

cd ${TG_TSUBAKURO_DIR}
./gradlew clean PublishMavenJavaPublicationToMavenLocal -PskipBuildNative

cd ${TG_TANZAWA_DIR}
./gradlew clean tgsql:cli:assemble tgdump:cli:assemble -PmavenLocal

cd ${TG_INSTALL_DIR}
tar xf ${TG_TANZAWA_DIR}/modules/tgsql/cli/build/distributions/cli-shadow-*.tar --strip-components 1
tar xf ${TG_TANZAWA_DIR}/modules/tgdump/cli/build/distributions/cli-shadow-*.tar --strip-components 1

echo "$(basename $0) successful."
