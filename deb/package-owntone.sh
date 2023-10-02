#!/bin/bash
#
# Packaging the compiled owntone into a .deb package
set -e
shopt -s expand_aliases

alias ls='ls --color=always'
alias grep='grep --color=always'

# ensure that we owntone has been compiled and is where we expect it
if [[ ! -d ./target/usr ]]; then
    echo "Has owntone been compiled?"
    set -x
    ls -l ./target/
    exit 3
fi

ARCH=$(dpkg --print-architecture)

# -C ${TARGETDIR}
# -C ./target/
# -C $(pwd)/target/
# -C /usr/local/src/target/

tar \
    -C ./target \
    -czf dist/owntone-server_${OWNTONE_VERSION}_${ARCH}.tar.gz \
    ./

if [[ ! "${OWNTONE_VERSION}" =~ "^[0-9].*$" ]]; then
    echo "environment var is set: 'OWNTONE_VERSION'"
    echo "OWNTONE_VERSION: ${OWNTONE_VERSION}"
    VERSION=${OWNTONE_VERSION}
else
    echo "environment var not version or not set: 'OWNTONE_VERSION'"
    VERSION=$(./target/usr/sbin/owntone --version | cut -d' ' -f2)
    echo "owntone --version: '${VERSION}'"
fi

DEPS=""
while read -r dep; do
    DEPS="${DEPS} -d $dep"
done </tmp/dependencies-apt.txt

# create empto logfile, so its included in the package with ownership set correctly
touch ./target/var/log/owntone.log
ls -l ./target/var/log/owntone.log

pwd
ls -l

set -x
# TODO: this should maybe have '--deb-group media'?
fpm \
    -t deb $DEPS\
    --deb-systemd ./target/etc/systemd/system/owntone.service \
    --deb-systemd ./target/etc/systemd/system/owntone@.service \
    --deb-user owntone \
    --deb-group owntone \
    --config-files /etc/owntone.conf \
    --deb-user owntone \
    --after-install ./after-install.sh \
    --directories /var/cache/owntone \
    --maintainer "sudo.is <pkg@sudo.is>" \
    --vendor "OwnTone (https://github.com/owntone), package by sudo.is" \
    --url "https://git.sudo.is/ben/build-owntone" \
    --license "GPLv2" \
    --description "OwnTone builds for sudo.is" \
    -p ./dist/ \
    -n owntone-server \
    -v ${VERSION} \
    -a ${ARCH} \
    -s dir target/=/

echo "OWNTONE_SERVER_DEB=owntone-server_${VERSION}_${ARCH}.deb ; export OWNTONE_SERVER_DEB" >> ./owntone-build.env
dpkg -I dist/owntone-server_${VERSION}_${ARCH}.deb
#dpkg -c dist/owntone-server_${VERSION}_${ARCH}.deb > dist/owntone-server_${VERSION}_${ARCH}.filelist.txt

if [[ -d ./target/owntone-web ]]; then
    fpm \
        -t deb \
        --deb-user owntone \
        --deb-group owntone \
        --maintainer "sudo.is <pkg@sudo.is>" \
        --vendor "OwnTone (https://github.com/owntone), package by sudo.is" \
        --url "https://git.sudo.is/ben/build-owntone" \
        --license "GPLv2" \
        --description "OwnTone builds for sudo.is" \
        -p ./dist/ \
        -n owntone-web \
        -v ${VERSION} \
        -a all \
        -s dir target/owntone-web/=/usr/share/owntone/htdocs/

    echo "OWNTONE_WEB_DEB=owntone-web_${VERSION}_all.deb ; export OWNTONE_WEB_DEB" >> ./owntone-build.env
    dpkg -I dist/owntone-web_${VERSION}_all.deb
    #dpkg -c dist/owntone-web_${VERSION}_all.deb > dist/owntone-web_${VERSION}.filelist.txt

    fpm \
        -t deb \
        -d owntone-server \
        -d ownone-web \
        --maintainer "sudo.is <pkg@sudo.is>" \
        --vendor "OwnTone (https://github.com/owntone), package by sudo.is" \
        --url "https://git.sudo.is/ben/build-owntone" \
        --license "GPLv2" \
        --description "OwnTone builds for sudo.is" \
        -p ./dist/ \
        -n owntone-full \
        -v $VERSION \
        -a $ARCH \
        -s empty

    echo "OWNTONE_FULL_DEB=owntone-full_${VERSION}_${ARCH}.deb ; export OWNTONE_FULL_DEB" >> ./owntone-build.env
fi

#tree target/ > dist/owntone-server_${VERSION}_${ARCH}.filetree.txt

sha256sum dist/*.deb > dist/sha256sums.txt
cat dist/sha256sums.txt


