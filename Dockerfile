FROM openjdk:13-alpine@sha256:5e91e51f5aadc58ab5ca35c9a2887e6a40b2c9e71790d200165674fa0fa60582
LABEL maintainer "Tim Brust <tim.brust@sinnerschrader.com>"

ARG REFRESHED_AT
ENV REFRESHED_AT $REFRESHED_AT

ARG MAVEN_VERSION=3.6.1
ARG USER_HOME_DIR="/root"
ARG MAVEN_SHA=b4880fb7a3d81edd190a029440cdf17f308621af68475a4fe976296e71ff4a4b546dd6d8a58aaafba334d309cc11e638c52808a4b0e818fc0fd544226d952544
ARG MAVEN_BASE_URL=https://apache.osuosl.org/maven/maven-3/${MAVEN_VERSION}/binaries

SHELL ["/bin/sh", "-o", "pipefail", "-c"]

RUN apk add --no-cache \
  curl

# Maven depends on openjdk8-jre, so a manual installation is necessary
# hadolint ignore=DL4006
RUN mkdir -p /usr/share/maven /usr/share/maven/ref \
  && curl -fsSL -o /tmp/apache-maven.tar.gz ${MAVEN_BASE_URL}/apache-maven-${MAVEN_VERSION}-bin.tar.gz \
  && echo "${MAVEN_SHA}  /tmp/apache-maven.tar.gz" | sha512sum -c - \
  && tar -xzf /tmp/apache-maven.tar.gz -C /usr/share/maven --strip-components=1 \
  && rm -f /tmp/apache-maven.tar.gz \
  && ln -s /usr/share/maven/bin/mvn /usr/bin/mvn

ENV MAVEN_HOME /usr/share/maven
ENV MAVEN_CONFIG "$USER_HOME_DIR/.m2"
