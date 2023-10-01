FROM ubuntu:latest as base

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=UTC
ENV TERM=xterm-256color

ARG OWNTONE_UID=1208
ARG OWNTONE_GID=1301

ARG OWNTONE_VERSION
ENV OWNTONE_VERSION=${OWNTONE_VERSION}

COPY deb/dependencies-apt.txt /tmp/dependencies-apt.txt
RUN set -x && \
    groupadd -g ${OWNTONE_GID} owntone && \
    useradd -u ${OWNTONE_UID} -g ${OWNTONE_GID} -ms /bin/bash owntone && \
    apt-get -y update && \
    apt-get install -y $(sed 's/\n/ /g' /tmp/dependencies-apt.txt)


FROM base as builder
RUN set -x && \
    apt-get install -y \
        build-essential git autotools-dev autoconf automake libtool gettext gawk \
        gperf bison flex libconfuse-dev libunistring-dev libsqlite3-dev \
        libavcodec-dev libavformat-dev libavfilter-dev libswscale-dev libavutil-dev \
        libasound2-dev libmxml-dev libgcrypt20-dev libavahi-client-dev zlib1g-dev \
        libevent-dev libplist-dev libsodium-dev libjson-c-dev libwebsockets-dev \
        libcurl4-openssl-dev libprotobuf-c-dev libpulse-dev libgnutls*-dev \
        ruby ruby-dev rubygems \
        tree && \
    gem install --no-document fpm && \
    chown -R owntone:owntone /usr/local/src/

USER owntone

COPY --chown=owntone:owntone owntone-server/ /usr/local/src/owntone-server/
COPY build/compile-owntone.sh /usr/local/bin/compile-owntone.sh
WORKDIR /usr/local/src/owntone-server/
RUN set -x && \
    mkdir -pv /usr/local/src/target /usr/local/src/dist && \
    /usr/local/bin/compile-owntone.sh

COPY deb/package-owntone.sh /usr/local/bin/package-owntone.sh
COPY deb/after-install.sh /usr/local/src/after-install.sh
WORKDIR /usr/local/src/
RUN set -x && \
    /usr/local/bin/package-owntone.sh


FROM base as final

COPY --from=builder /usr/local/src/dist/owntone-server_${OWNTONE_VERSION}_amd64.deb /tmp/
RUN set -x && \
    echo usermod -u 1001 owntone && \
    dpkg -i /tmp/owntone-server_${OWNTONE_VERSION}_amd64.deb && \
    apt-get clean && \
    rm /tmp/owntone-server_*_amd64.deb

# RUN ldd /usr/sbin/owntone && dpkg-deb -c /tmp/owntone_0.1.0_amd64.deb && ls -ld /var/cache/owntone
COPY etc/owntone.conf /etc/owntone.conf
COPY entrypoint.sh /usr/local/bin/entrypoint.sh

USER owntone
WORKDIR /home/owntone
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["-f"]

