FROM alpine:3

LABEL org.opencontainers.image.authors="Ronja Koistinen <ronja.koistinen@helsinki.fi>"
LABEL org.opencontainers.image.description="Cantaloupe image server"
LABEL org.opencontainers.image.vendor="National Library of Finland"

ARG CANTALOUPE_VERSION=5.0.7

RUN set -eux; adduser -h /opt/cantaloupe -D cantaloupe; \
    chown -R cantaloupe /opt/cantaloupe; \
    apk add --no-cache openjdk17-jre \
        ca-certificates \
        wget \
        openjpeg \
        lcms2 \
        libpng \
        zstd \
        tiff \
        zlib \
        libwebp \
        fontconfig font-dejavu \
        perl-image-exiftool; \
    wget https://github.com/cantaloupe-project/cantaloupe/releases/download/v$CANTALOUPE_VERSION/cantaloupe-$CANTALOUPE_VERSION.zip \
        -qO /tmp/cantaloupe.zip; \
    mkdir -p /etc/cantaloupe /opt/cantaloupe /tmp/extract; \
    unzip -q /tmp/cantaloupe.zip -d /opt/extract; \
    mv /opt/extract/cantaloupe-$CANTALOUPE_VERSION/* /opt/cantaloupe/; \
    mv /opt/cantaloupe/cantaloupe-$CANTALOUPE_VERSION.jar \
        /opt/cantaloupe/cantaloupe.jar; \
    cp /opt/cantaloupe/cantaloupe.properties.sample \
        /etc/cantaloupe/cantaloupe.properties; \
    rm -rf /tmp/extract /tmp/cantaloupe.zip

USER cantaloupe
WORKDIR /opt/cantaloupe

CMD ["java", "-Dcantaloupe.config=/etc/cantaloupe/cantaloupe.properties", \
    "-Xmx2G", "-jar", "/opt/cantaloupe/cantaloupe.jar"]
