#!/bin/bash

set -e

autoreconf -i

# --enable-static  --disable-shared
# -enable-prefairplay2
./configure --with-pulseaudio --with-avahi \
  --enable-chromecast --enable-lastfm \
  --prefix=/usr --sysconfdir=/etc --localstatedir=/var \

make

mkdir ${DISTDIR}/target
DESTDIR=${DISTDIR}/target make install
