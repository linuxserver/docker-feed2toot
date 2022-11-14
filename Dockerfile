FROM ghcr.io/linuxserver/baseimage-alpine:3.16

# set version label
ARG BUILD_DATE
ARG VERSION
ARG FEED2TOOT_VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="thespad"

# environment settings
ENV PYTHONIOENCODING=utf-8 \
    PYTHONUNBUFFERED=1

RUN \
  echo "**** install packages ****" && \
  apk add -U --update --no-cache --virtual=build-dependencies \
    build-base \
    g++ \
    gcc \
    python3-dev && \
  apk add  -U --update --no-cache \
    python3 \
    py3-pip && \
  echo "**** install feed2toot ****" && \  
  if [ -z ${FEED2TOOT_VERSION+x} ]; then \
    FEED2TOOT_VERSION=$(curl -sL  "https://pypi.python.org/pypi/feed2toot/json" \
    |jq -r '. | .info.version'); \
  fi && \
  python3 -m pip install --upgrade pip && \
  pip3 install -U --no-cache-dir --find-links https://wheel-index.linuxserver.io/alpine-3.16/ \
    wheel \
    feed2toot && \
  echo "**** cleanup ****" && \
  apk del --purge \
    build-dependencies && \
  rm -rf \
    /tmp/* \
    $HOME/.cache

# add local files
COPY root/ /

# ports and volumes
VOLUME /config
