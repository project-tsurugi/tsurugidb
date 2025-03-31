#!/bin/bash -e

if [ "$EUID" -ne 0 ]; then
  echo "This script must be run as root" 1>&2
  exit 1
fi

dnf update -y
dnf install -y epel-release
dnf config-manager --set-enabled epel crb

echo "$(basename $0) successful."
