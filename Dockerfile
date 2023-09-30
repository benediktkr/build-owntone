FROM ubuntu:latest as base

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=UTC
ENV TERM=xterm-256color

ARG UID=1208
ARG GID=1301

COPY /builder/deps.txt /tmp/deps.txt
RUN set -x && \
    groupadd -g ${GID} owntone && \
    useradd -u ${UID} -g ${GID} -ms /bin/bash owntone && \
    apt-get -y update && \
    apt-get install -y $(sed 's/\n/ /g' /tmp/deps.txt)

FROM base as builder
RUN set -x && \
    apt-get install -y \
    build-essential git autotools-dev autoconf automake libtool gettext gawk \
    gperf bison flex libconfuse-dev libunistring-dev libsqlite3-dev \
    libavcodec-dev libavformat-dev libavfilter-dev libswscale-dev libavutil-dev \
    libasound2-dev libmxml-dev libgcrypt20-dev libavahi-client-dev zlib1g-dev \
    libevent-dev libplist-dev libsodium-dev libjson-c-dev libwebsockets-dev \
    libcurl4-openssl-dev libprotobuf-c-dev libpulse-dev libgnutls*-dev \
    ruby ruby-dev rubygems && \
    gem install --no-document fpm && \
    chown -R owntone:owntone /usr/local/src/


USER owntone
ENV DISTDIR=/usr/local/src/dist
RUN mkdir ${DISTDIR}

COPY --chown=owntone:owntone owntone-apt/ /usr/local/src/owntone-apt/
COPY --chown=owntone:owntone owntone-server/ /usr/local/src/owntone-server/
COPY --chown=owntone:owntone builder/build-owntone.sh /usr/local/bin/build-owntone.sh
WORKDIR /usr/local/src/owntone-server/
# TODO: figure out how to override at runtime
# https://owntone.github.io/owntone-server/clients/web-interface/
# https://github.com/owntone/owntone-server/blob/master/web-src/vite.config.js

RUN /usr/local/bin/build-owntone.sh

ARG LATEST_GIT_TAG
ENV LATEST_GIT_TAG=${LATEST_GIT_TAG}
COPY --chown=owntone:owntone builder/package-owntone.sh /usr/local/bin/package-owntone.sh
COPY --chown=owntone:owntone builder/after-install.sh /usr/local/src/after-install.sh
COPY --chown=owntone:owntone builder/dark-reader.sh /usr/local/src/dark-reader.sh

# copy css file from dark-reader (firefox extension) and a modified index.html
COPY --chown=owntone:owntone dark-reader/ /usr/local/src/dark-reader/

WORKDIR /usr/local/src/dist

RUN /usr/local/bin/package-owntone.sh


FROM base as final
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=UTC
ENV TERM=xterm-256color

COPY --from=builder /usr/local/src/dist/owntone.tar.gz /tmp/
COPY --from=builder /usr/local/src/dist/owntone_*_amd64.deb /tmp/
RUN dpkg -i /tmp/owntone_*_amd64.deb && \
    apt-get clean && \
    chown owntone:owntone /var/cache/owntone && \
    rm /tmp/owntone.tar.gz  && \
    rm /tmp/owntone_*_amd64.deb && \
    echo touch /var/log/owntone.log && \
    echo chown  owntone:owntone /var/log/owntone.log

# RUN ldd /usr/sbin/owntone && dpkg-deb -c /tmp/owntone_0.1.0_amd64.deb && ls -ld /var/cache/owntone
COPY docker/owntone.conf /etc/owntone.conf
COPY docker/entrypoint.sh /usr/local/bin/entrypoint.sh
#USER owntone
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["-f"]
