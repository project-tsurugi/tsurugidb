#!/bin/bash -e

if [ "$EUID" -ne 0 ]; then
  echo "This script must be run as root" 1>&2
  exit 1
fi

export DEBIAN_FRONTEND=noninteractive

apt-get update -y
apt-get install -y -V \
 bison \
 build-essential \
 cmake \
 curl \
 doxygen \
 flex \
 libboost-container-dev \
 libboost-filesystem-dev \
 libboost-serialization-dev \
 libboost-stacktrace-dev \
 libboost-system-dev \
 libboost-thread-dev \
 libgflags-dev \
 libgoogle-glog-dev \
 libicu-dev \
 libjemalloc-dev \
 libleveldb-dev \
 libmsgpack-dev \
 libnuma-dev \
 libpq-dev \
 libprotobuf-dev \
 librocksdb-dev \
 libssl-dev \
 libtbb-dev \
 lsb-release \
 openjdk-11-jdk \
 pkg-config \
 protobuf-compiler \
 ninja-build \
 uuid-dev

apt-get install -y -V libmpdec-dev || true

curl -OL https://apache.jfrog.io/artifactory/arrow/"$(lsb_release --id --short | tr 'A-Z' 'a-z')/apache-arrow-apt-source-latest-$(lsb_release --codename --short).deb"
apt-get install -y -V ./apache-arrow-apt-source-latest-"$(lsb_release --codename --short).deb"
apt-get update -y
apt-get install -y -V libparquet-dev=14.0.1-1 libparquet-glib-dev=14.0.1-1 libarrow-dev=14.0.1-1 libarrow-glib-dev=14.0.1-1 libarrow-acero-dev=14.0.1-1 gir1.2-parquet-1.0=14.0.1-1 gir1.2-arrow-1.0=14.0.1-1
rm -f ./apache-arrow-apt-source-latest-"$(lsb_release --codename --short).deb"

echo "$(basename $0) successful."
