FROM alpine:latest as builder
LABEL maintainer George Parremore <github@gop.id.au>
ENV LANG="en_US.UTF-8" \
    VERSION="develop"

RUN set -x \
 && apk add --no-cache \
    autoconf \
    automake \
    bsd-compat-headers \
    build-base \
    curl \
    jansson \
    jansson-dev \
    libidn2-dev \
    libmilter-dev \
    libtool \
    make \
    musl-dev \
    openssl-dev \
    pkgconfig

#ADD https://github.com/trusteddomainproject/OpenARC/archive/rel-openarc-1-0-0-Beta3.tar.gz /OpenARC

RUN set -x \
 && mkdir /openarc \
 && curl -sSL https://github.com/trusteddomainproject/OpenARC/archive/${VERSION}.tar.gz | tar zxvf - -C /openarc --strip-components 1 \
 && curl -sSL https://raw.githubusercontent.com/brightspark3/docker-openarc/refs/heads/master/openarc.conf.sample -o /tmp/openarc.conf \
 && cd /openarc \
 && autoreconf -fiv \
 && ./configure --prefix=/usr \
 && make \
 && make install

FROM alpine:latest
LABEL maintainer George Parremore <github@gop.id.au>
ENV LANG="en_US.UTF-8"

COPY --from=builder /usr/sbin/openarc /usr/sbin/
COPY --from=builder /usr/lib/libopenarc.so.0 /usr/lib/
COPY --from=builder /usr/share/doc/openarc /usr/share/doc/
COPY --from=builder /tmp/openarc.conf /etc/openarc/openarc.conf

RUN set -x \
 && apk add --no-cache \
    curl \
    libmilter \
    jansson

RUN set -x \
 && addgroup -g 101 -S opendkim \
 && adduser -h /run/opendkim -s /sbin/nologin -D -S -u 100 -g openarc -G opendkim opendkim \
 && addgroup opendkim mail

EXPOSE 8891/tcp
VOLUME ["/etc/openarc","/etc/dkimkeys"]

CMD set -x; \
    /usr/sbin/openarc -n -u opendkim -c /etc/openarc/openarc.conf \
 && /usr/sbin/openarc -p inet:8891@127.0.0.1 -u opendkim -A -f -vvvv -c /etc/openarc/openarc.conf
