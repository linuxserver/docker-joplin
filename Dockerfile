# syntax=docker/dockerfile:1

FROM ghcr.io/linuxserver/baseimage-selkies:debiantrixie

# set version label
ARG BUILD_DATE
ARG VERSION
ARG JOPLIN_VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="thelamer"

# title
ENV TITLE=Joplin

RUN \
  echo "**** add icon ****" && \
  curl -o \
    /usr/share/selkies/www/icon.png \
    https://raw.githubusercontent.com/linuxserver/docker-templates/master/linuxserver.io/img/joplin-logo.png && \
  echo "**** install packages ****" && \
  apt-get update && \
  if [ -z ${JOPLIN_VERSION+x} ]; then \
    JOPLIN_VERSION=$(curl -sX GET "https://api.github.com/repos/laurent22/joplin/releases/latest" \
    | awk '/tag_name/{print $4;exit}' FS='[""]'); \
  fi && \
  curl -o \
    /tmp/joplin.deb -L \
    "https://github.com/laurent22/joplin/releases/download/${JOPLIN_VERSION}/Joplin-$(echo ${JOPLIN_VERSION}| sed 's/^v//g').deb" && \
  apt-get install -y \
    /tmp/joplin.deb && \
  echo "**** cleanup ****" && \
  apt-get autoclean && \
  rm -rf \
    /config/.cache \
    /var/lib/apt/lists/* \
    /var/tmp/* \
    /tmp/*

# add local files
COPY /root /

# ports and volumes
EXPOSE 3001
VOLUME /config
