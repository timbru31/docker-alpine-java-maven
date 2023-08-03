FROM eclipse-temurin:11-jdk-alpine
LABEL maintainer "Tim Brust <github@timbrust.de>"

ARG REFRESHED_AT
ENV REFRESHED_AT $REFRESHED_AT

ARG MAVEN_VERSION=3.9.4
ARG USER_HOME_DIR="/root"
ARG MAVEN_SHA=deaa39e16b2cf20f8cd7d232a1306344f04020e1f0fb28d35492606f647a60fe729cc40d3cba33e093a17aed41bd161fe1240556d0f1b80e773abd408686217e
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
