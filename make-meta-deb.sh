#! /bin/sh

if [ -z "$TG_INSTALL_DIR" ]; then
    echo 'set $TG_INSTALL_DIR' >&2
    exit 1
fi
if [ -z "$TSURUGI_VERSION" ]; then
    TSURUGI_VERSION=`sed -n '/TSURUGI_VERSION:/{;s///;p;}' $TG_INSTALL_DIR/BUILDINFO.md`
    if [ -z "$TSURUGI_VERSION" ]; then
       echo 'cannot detect TSURUGI_VERSION' >&2
       exit 1
    fi
fi

mkdir build-deb
cd build-deb

packagename=tsurugidb-dependencies-$TSURUGI_VERSION
mkdir debian

cat << EOF > debian/control
Source: tsurugidb
Maintainer: Nobuhiro Ban <ban@nautilus-technologies.com>

Package: $packagename
Architecture: any
Section: admin
Depends: \${shlibs:Depends}
Description: tsurugidb dep packages holder
 This meta package depends library packages used by tsurugidb binary
 installed under $TG_INSTALL_DIR .
EOF

cat << EOF > debian/changelog
tsurugidb (0) UNRELEASED; urgency=low

  * Generated from $0

 -- `whoami` <`whoami`@`hostname`>  `date -R`
EOF

mkdir -p debian/tmp/DEBIAN
mkdir -p debian/tmp/usr/share/doc/$packagename

dpkg-shlibdeps $TG_INSTALL_DIR/lib*/*.so $TG_INSTALL_DIR/libexec/* $TG_INSTALL_DIR/bin/*
dpkg-gencontrol
gzip -c < debian/changelog > debian/tmp/usr/share/doc/$packagename/changelog.gz
dpkg-deb --root-owner-group --build debian/tmp .
