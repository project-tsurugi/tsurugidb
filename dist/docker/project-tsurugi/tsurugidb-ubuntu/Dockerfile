ARG UBUNTU_VERSION=22.04

FROM ubuntu:${UBUNTU_VERSION}

ARG SRC_DIR=/usr/local/src/tsurugidb
WORKDIR ${SRC_DIR}
COPY tsurugidb*.tar.gz ${SRC_DIR}/tsurugidb.tar.gz
COPY docker-entrypoint.sh /usr/local/bin

WORKDIR /tmp/tsurugidb
RUN set -eux \
 && tar xf "${SRC_DIR}/tsurugidb.tar.gz" --strip-components 1 \
 && ./apt-install.sh \
 && ./install.sh --symbolic --replaceconfig=enabled=true,allow_blob_privileged=true,log_location=/opt/tsurugi/var/data/log \
 && rm -fr /tmp/tsurugidb

ARG TSURUGI_HOME="/usr/lib/tsurugi"
ARG TSURUGI_USER="tsurugi"

RUN set -eux \
 && adduser "${TSURUGI_USER}" --gecos '' --disabled-login \
 && chown -R "${TSURUGI_USER}:${TSURUGI_USER}" "${TSURUGI_HOME}"* \
 && mkdir -p /opt/tsurugi/var/data/log \
 && chown -R "${TSURUGI_USER}:${TSURUGI_USER}" /opt/tsurugi

ENV TSURUGI_HOME=${TSURUGI_HOME}
ENV PATH="${TSURUGI_HOME}/bin:${PATH}"
USER ${TSURUGI_USER}
WORKDIR ${TSURUGI_HOME}

ENTRYPOINT ["docker-entrypoint.sh"]
