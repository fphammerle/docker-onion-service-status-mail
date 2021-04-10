FROM alpine:3.13.4

ARG DUMB_INIT_PACKAGE_VERSION=1.2.5-r0
ARG NETCAT_PACKAGE_VERSION=1.130-r2
ARG DMA_REPOSITORY=http://dl-cdn.alpinelinux.org/alpine/edge/testing
ARG DMA_PACKAGE_VERSION=0.13-r1
RUN apk add --no-cache \
        dumb-init=${DUMB_INIT_PACKAGE_VERSION} \
        netcat-openbsd=${NETCAT_PACKAGE_VERSION} \
    && apk add --repository=${DMA_REPOSITORY} --no-cache \
        dma=${DMA_PACKAGE_VERSION} \
    && adduser -S -G mail report

VOLUME /var/spool/dma

ENV TOR_HOST= \
    TOR_PORT=9050 \
    ONION_SERVICE_HOST= \
    ONION_SERVICE_PORT= \
    TIMEOUT_SECONDS=4 \
    SLEEP_DURATION=16s \
    MAIL_TO= \
    VERBOSE=

COPY --chown=report:nobody monitor.sh /
USER report
ENTRYPOINT ["dumb-init", "--"]
CMD ["/monitor.sh"]

HEALTHCHECK CMD nc -z "$TOR_HOST" "$TOR_PORT" || exit 1
