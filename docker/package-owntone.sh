#!/bin/bash
#
# Packaging the compiled owntone into a .deb package
set -e
shopt -s expand_aliases

alias ls='ls --color=always'
alias grep='grep --color=always'

NAME="owntone-server"
ARCH=$(dpkg --print-architecture)

tar -C ${DISTDIR}/target/ -czf ${DISTDIR}/${NAME}_${OWNTONE_VERSION}_${ARCH}.tar.gz ${DISTDIR}/target/

if [[ "${OWNTONE_VERSION}" =~ "^[0-9].*$" ]]; then
    echo "environment var is set: 'OWNTONE_VERSION'"
    echo "OWNTONE_VERSION: ${OWNTONE_VERSION}"
else
    echo "environment var not set: 'OWNTONE_VERSION'"
    VERSION=$(./target/usr/sbin/owntone --version | cut -d' ' -f2)
    echo "owntone --version: '${VERSION}'"
fi

DEPS=""
while read -r dep; do
    DEPS="${DEPS} -d $dep"
done </tmp/dependencies-apt.txt

# create empto logfile, so its included in the package with ownership set correctly
touch target/var/log/owntone.log
ls -l target/var/log/owntone.log

set -x
fpm \
    -t deb $DEPS\
    --deb-systemd target/etc/systemd/system/owntone.service \
    --config-files /etc/owntone.conf \
    --deb-user owntone \
    --after-install /usr/local/src/after-install.sh \
    -n ${NAME} \
    -v ${VERSION} \
    -a ${ARCH} \
    -s dir target/=/


dpkg -I owntone-server_${VERSION}_${ARCH}.deb



