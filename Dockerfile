FROM eclipse-temurin:11-jdk-alpine
LABEL maintainer "Tim Brust <github@timbrust.de>"

ARG REFRESHED_AT
ENV REFRESHED_AT $REFRESHED_AT

ARG MAVEN_VERSION=3.8.7
ARG USER_HOME_DIR="/root"
ARG MAVEN_SHA=21c2be0a180a326353e8f6d12289f74bc7cd53080305f05358936f3a1b6dd4d91203f4cc799e81761cf5c53c5bbe9dcc13bdb27ec8f57ecf21b2f9ceec3c8d27
ARG MAVEN_BASE_URL=https://downloads.apache.org/maven/maven-3/${MAVEN_VERSION}/binaries

# Maven depends on openjdk8-jre, so a manual installation is necessary
SHELL ["/bin/ash", "-eo", "pipefail", "-c"]

RUN apk -U upgrade \
  && apk add --no-cache \
    curl \
  && mkdir -p /usr/share/maven /usr/share/maven/ref \
  && curl -fsSL -o /tmp/apache-maven.tar.gz ${MAVEN_BASE_URL}/apache-maven-${MAVEN_VERSION}-bin.tar.gz \
  && echo "${MAVEN_SHA}  /tmp/apache-maven.tar.gz" | sha512sum -c - \
  && tar -xzf /tmp/apache-maven.tar.gz -C /usr/share/maven --strip-components=1 \
  && rm -f /tmp/apache-maven.tar.gz \
  && ln -s /usr/share/maven/bin/mvn /usr/bin/mvn

ENV MAVEN_HOME /usr/share/maven
ENV MAVEN_CONFIG "$USER_HOME_DIR/.m2"
