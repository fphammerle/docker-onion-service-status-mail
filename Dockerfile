FROM docker.io/alpine:3.15.0

ARG DUMB_INIT_PACKAGE_VERSION=1.2.5-r1
ARG NETCAT_PACKAGE_VERSION=1.130-r2
ARG DMA_REPOSITORY=http://dl-cdn.alpinelinux.org/alpine/edge/testing
ARG DMA_PACKAGE_VERSION=0.13-r2
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
