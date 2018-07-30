FROM alpine:3.8
LABEL maintainer "Tim Brust <tim.brust@sinnerschrader.com>"

ARG REFRESHED_AT
ENV REFRESHED_AT $REFRESHED_AT

ARG OPENJDK11_ALPINE_URL=https://download.java.net/java/early_access/alpine/22/binaries/openjdk-11-ea+22_linux-x64-musl_bin.tar.gz

RUN apk add --no-cache \
  ca-certificates \
  wget \
  maven \
  && mkdir -p /opt/jdk \
  && wget -c -O- $OPENJDK11_ALPINE_URL \
    | tar -zxC /opt/jdk

ENV JAVA_HOME /opt/jdk/jdk-11
ENV PATH=$JAVA_HOME/bin:$PATH
