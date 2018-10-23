FROM alpine:3.8@sha256:621c2f39f8133acb8e64023a94dbdf0d5ca81896102b9e57c0dc184cadaf5528
LABEL maintainer "Tim Brust <tim.brust@sinnerschrader.com>"

ARG REFRESHED_AT
ENV REFRESHED_AT $REFRESHED_AT

ARG OPENJDK11_ALPINE_URL=https://download.java.net/java/early_access/alpine/28/binaries/openjdk-11+28_linux-x64-musl_bin.tar.gz
ARG MAVEN_VERSION=3.5.4
ARG USER_HOME_DIR="/root"
ARG MAVEN_SHA=ce50b1c91364cb77efe3776f756a6d92b76d9038b0a0782f7d53acf1e997a14d
ARG MAVEN_BASE_URL=https://apache.osuosl.org/maven/maven-3/${MAVEN_VERSION}/binaries

SHELL ["/bin/sh", "-o", "pipefail", "-c"]

RUN apk add --no-cache \
  ca-certificates \
  wget \
  curl \
  bash \
  procps

# hadolint ignore=DL4006
RUN mkdir -p /opt/jdk \
  && curl -fsSL $OPENJDK11_ALPINE_URL \
  | tar -zxC /opt/jdk \
  && rm /opt/jdk/jdk-11/lib/src.zip

ENV JAVA_HOME /opt/jdk/jdk-11
ENV PATH=$PATH:$JAVA_HOME/bin
ENV LANG=C.UTF-8

# Maven depends on openjdk8-jre, so a manual installation is necessary
# hadolint ignore=DL4006
RUN mkdir -p /usr/share/maven /usr/share/maven/ref \
  && curl -fsSL -o /tmp/apache-maven.tar.gz ${MAVEN_BASE_URL}/apache-maven-${MAVEN_VERSION}-bin.tar.gz \
  && echo "${MAVEN_SHA}  /tmp/apache-maven.tar.gz" | sha256sum -c - \
  && tar -xzf /tmp/apache-maven.tar.gz -C /usr/share/maven --strip-components=1 \
  && rm -f /tmp/apache-maven.tar.gz \
  && ln -s /usr/share/maven/bin/mvn /usr/bin/mvn

ENV MAVEN_HOME /usr/share/maven
ENV MAVEN_CONFIG "$USER_HOME_DIR/.m2"
