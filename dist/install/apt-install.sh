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
 libcurl4 \
 libgflags-dev \
 libgoogle-glog-dev \
 libicu-dev \
 libjemalloc-dev \
 libjson-c-dev \
 libjwt-dev \
 libleveldb-dev \
 libmsgpack-dev \
 libnuma-dev \
 libpq-dev \
 libprotobuf-dev \
 librocksdb-dev \
 libssl-dev \
 libtbb-dev \
 lsb-release \
 nlohmann-json3-dev \
 openjdk-17-jdk-headless \
 pkg-config \
 protobuf-compiler \
 ninja-build \
 uuid-dev

apt-get install -y -V libmpdec-dev || true

curl --retry 3 --retry-all-errors -OL https://apache.jfrog.io/artifactory/arrow/"$(lsb_release --id --short | tr 'A-Z' 'a-z')/apache-arrow-apt-source-latest-$(lsb_release --codename --short).deb"
apt-get install -y -V ./apache-arrow-apt-source-latest-"$(lsb_release --codename --short).deb"
apt-get update -y
apt-get install -y -V libparquet-dev=16.1.0-1 libparquet1600=16.1.0-1 libarrow-dev=16.1.0-1 libarrow1600=16.1.0-1
rm -f ./apache-arrow-apt-source-latest-"$(lsb_release --codename --short).deb"

echo "$(basename $0) successful."
