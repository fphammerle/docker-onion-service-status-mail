FROM alpine:3.11

ARG DUMB_INIT_PACKAGE_VERSION=1.2.2-r1
ARG NETCAT_PACKAGE_VERSION=1.130-r1
ARG DMA_REPOSITORY=http://dl-cdn.alpinelinux.org/alpine/edge/testing
ARG DMA_PACKAGE_VERSION=0.12-r0
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
    RECIPIENT_ADDRESS= \
    VERBOSE=

COPY --chown=report:nobody monitor.sh /
USER report
ENTRYPOINT ["dumb-init", "--"]
CMD ["/monitor.sh"]

HEALTHCHECK CMD nc -z "$TOR_HOST" "$TOR_PORT" || exit 1
