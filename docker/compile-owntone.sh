#!/bin/bash

set -e

autoreconf -i

# --enable-static  --disable-shared
# -enable-prefairplay2

# --with-avahi
# --without-avahi

./configure \
    --with-pulseaudio \
    --enable-chromecast \
    --enable-lastfm \
    --prefix=/usr \
    --sysconfdir=/etc \
    --localstatedir=/var

make

set -x
DESTDIR=$(pwd)/../target make install
