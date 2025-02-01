# with `FROM docker.io/alpine:3.16.1`:
# > $ apk add --no-cache \
# >     --repository=http://dl-cdn.alpinelinux.org/alpine/edge/testing \
# >     dma=0.13-r3
# > [...]
# > ERROR: unable to select packages:
# >   so:libcrypto.so.3 (no such package):
# >     required by: dma-0.13-r3[so:libcrypto.so.3]
# >   so:libssl.so.3 (no such package):
# >     required by: dma-0.13-r3[so:libssl.so.3]
FROM docker.io/alpine:20250108

# https://git.alpinelinux.org/aports/log/community/dumb-init
ARG DUMB_INIT_PACKAGE_VERSION=1.2.5-r3
# https://github.com/openbsd/src/commits/master/usr.bin/nc
# https://salsa.debian.org/debian/netcat-openbsd/-/commits/debian/latest
# https://git.alpinelinux.org/aports/log/main/netcat-openbsd
ARG NETCAT_PACKAGE_VERSION=1.228.1-r0
# https://git.alpinelinux.org/aports/log/community/dma
ARG DMA_PACKAGE_VERSION=0.14-r0
RUN apk add --no-cache \
        dma=${DMA_PACKAGE_VERSION} \
        dumb-init=${DUMB_INIT_PACKAGE_VERSION} \
        netcat-openbsd=${NETCAT_PACKAGE_VERSION} \
    && adduser -S -G mail report

VOLUME /var/spool/dma

ENV TOR_HOST= \
    TOR_PORT=9050 \
    ONION_SERVICE_HOST= \
    ONION_SERVICE_PORT= \
    TIMEOUT_SECONDS=4 \
    SLEEP_DURATION=16s \
    RETRIES=0 \
    MAIL_TO= \
    VERBOSE=

COPY --chown=report:nobody monitor.sh /
USER report
ENTRYPOINT ["dumb-init", "--"]
CMD ["/monitor.sh"]

HEALTHCHECK CMD nc -z "$TOR_HOST" "$TOR_PORT" || exit 1

# https://github.com/opencontainers/image-spec/blob/v1.0.1/annotations.md
ARG REVISION=
LABEL org.opencontainers.image.title="report online status of tor onion services via email" \
    org.opencontainers.image.source="https://github.com/fphammerle/onion-service-status-mail" \
    org.opencontainers.image.revision="$REVISION"
