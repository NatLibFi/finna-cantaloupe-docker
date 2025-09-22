FROM debian:trixie-slim

LABEL org.opencontainers.image.authors="Ronja Koistinen <ronja.koistinen@helsinki.fi>"
LABEL org.opencontainers.image.description="Cantaloupe image server"
LABEL org.opencontainers.image.vendor="National Library of Finland"

ARG CANTALOUPE_VERSION=5.0.7

ENV DEBIAN_FRONTEND=noninteractive

RUN set -eux; useradd -m -d /opt/cantaloupe cantaloupe; \
    chown -R cantaloupe /opt/cantaloupe; \
    apt-get update; \
    apt-get install -y --no-install-recommends openjdk-21-jre \
        ca-certificates \
        wget \
        curl \
        libopenjp2-7 \
        libturbojpeg-java \
        liblcms2-2 \
        libpng16-16t64 \
        libzstd1 \
        libtiff6 \
        zlib1g \
        libwebp7 \
        fontconfig fonts-dejavu \
        unzip \
        libimage-exiftool-perl; \
    wget https://github.com/cantaloupe-project/cantaloupe/releases/download/v$CANTALOUPE_VERSION/cantaloupe-$CANTALOUPE_VERSION.zip \
        -qO /tmp/cantaloupe.zip; \
    mkdir -p /etc/cantaloupe /opt/cantaloupe /tmp/extract /var/cache/cantaloupe \
        /var/iiif /opt/libjpeg-turbo/lib; \
    chmod 0755 /var/iiif; \
    chown cantaloupe /var/cache/cantaloupe; \
    unzip -q /tmp/cantaloupe.zip -d /opt/extract; \
    mv /opt/extract/cantaloupe-$CANTALOUPE_VERSION/* /opt/cantaloupe/; \
    mv /opt/cantaloupe/cantaloupe-$CANTALOUPE_VERSION.jar \
        /opt/cantaloupe/cantaloupe.jar; \
    cp /opt/cantaloupe/cantaloupe.properties.sample \
        /etc/cantaloupe/cantaloupe.properties; \
    rm -rf /tmp/extract /tmp/cantaloupe.zip /var/lib/apt/lists/*; \
    ln -s /usr/lib/x86_64-linux-gnu/libjpeg.so.62 \
        /opt/libjpeg-turbo/lib/libturbojpeg.so

USER cantaloupe
WORKDIR /opt/cantaloupe

CMD ["java", "-Dcantaloupe.config=/etc/cantaloupe/cantaloupe.properties", \
    "-Xmx2G", "-jar", "/opt/cantaloupe/cantaloupe.jar"]
