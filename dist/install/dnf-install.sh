#!/bin/bash -e

if [ "$EUID" -ne 0 ]; then
  echo "This script must be run as root" 1>&2
  exit 1
fi

dnf install -y \
 bison \
 boost-devel \
 clang \
 cmake \
 doxygen \
 flex \
 gcc-c++ \
 gcc-toolset-13-libatomic-devel \
 glog-devel \
 icu \
 java-11-openjdk-devel \
 jemalloc-devel \
 mpdecimal-devel \
 ninja-build \
 numactl-devel \
 protobuf-devel \
 rocksdb-devel \
 tbb-devel \
 uuid-devel

dnf install -y https://apache.jfrog.io/artifactory/arrow/almalinux/"$(cut -d: -f5 /etc/system-release-cpe | cut -d. -f1)"/apache-arrow-release-latest.rpm
dnf install -y \
 arrow-devel-16.1.0-1.el9.x86_64 \
 parquet-devel-16.1.0-1.el9.x86_64

echo "$(basename $0) successful."
