#!/bin/bash -e

if [ "$EUID" -ne 0 ]; then
  echo "This script must be run as root" 1>&2
  exit 1
fi

export DEBIAN_FRONTEND=noninteractive

apt-get update -y
apt-get install -y -V \
 build-essential \
 cmake \
 libboost-system-dev \
 openjdk-11-jdk-headless \
 ninja-build

echo "$(basename $0) successful."
