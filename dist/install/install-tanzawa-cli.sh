#!/bin/bash -e

echo -e "\n[Install Tsurugi SQL Console]"

cd ${TG_TSUBAKURO_DIR}
./gradlew clean PublishMavenJavaPublicationToMavenLocal -PskipBuildNative

cd ${TG_TANZAWA_DIR}
./gradlew clean tanzawa-cli:assemble -PmavenLocal

cd ${TG_INSTALL_DIR}
tar xf ${TG_TANZAWA_DIR}/modules/cli/build/distributions/tanzawa-cli-shadow-*.tar --strip-components 1

echo "$(basename $0) successful."
