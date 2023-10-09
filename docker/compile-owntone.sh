#!/bin/bash
#
# Compile the OwnTone source
#
# Runs on container build time

set -e
set -x

autoreconf -i

# --with-avahi
# --without-avahi
#
# None of these work, the Makefile probably needs to be edited (if its possible at all)
# --enable-static
# --disable-shared
# ./configure LDFLAGS=-static
#

./configure \
    --enable-webinterface \
    --with-pulseaudio \
    --enable-chromecast \
    --enable-lastfm \
    --enable-preferairplay2 \
    --prefix=/usr \
    --sysconfdir=/etc \
    --localstatedir=/var

make

ldd src/owntone

DESTDIR=$(pwd)/../target make install



