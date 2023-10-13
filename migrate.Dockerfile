# ANYTHING BELOW THAT IS *NOT* COPY-PASTED FROM THE "Building a Custom Image for Python" SECTION OF
# https://aws.amazon.com/blogs/aws/new-for-aws-lambda-container-image-support/
# WILL BE IN BETWEEN `# *** BEGIN ***` & `# *** END ***` COMMENTS.

# Define global args
ARG FUNCTION_DIR="/home/app/"
ARG RUNTIME_VERSION="3.9"
ARG DISTRO_VERSION="3.12"

# Stage 1 - bundle base image + runtime
# Grab a fresh copy of the image and install GCC
FROM python:${RUNTIME_VERSION}-alpine${DISTRO_VERSION} AS python-alpine
# Install GCC (Alpine uses musl but we compile and link dependencies with GCC)
RUN apk add --no-cache \
    libstdc++

# Stage 2 - build function and dependencies
FROM python-alpine AS build-image

# Install aws-lambda-cpp build dependencies
RUN apk add --no-cache \
    build-base \
    libtool \
    autoconf \
    automake \
    libexecinfo-dev \
    make \
    cmake \
    tar \
    gzip \
    curl \
    openjdk11 \
    libcurl

WORKDIR /flyway

ARG FLYWAY_VERSION=9.8.1
ARG FLYWAY_ARTIFACT_URL=https://repo1.maven.org/maven2/org/flywaydb/flyway-commandline/

ENV FLYWAY_SCHEMAS="public"
ENV FLYWAY_VALIDATE_MIGRATION_NAMING=true
ENV FLYWAY_USER=
ENV FLYWAY_PASSWORD=
ENV FLYWAY_URL=

COPY scripts /flyway/sql


RUN curl -L ${FLYWAY_ARTIFACT_URL}${FLYWAY_VERSION}/flyway-commandline-${FLYWAY_VERSION}.tar.gz -o flyway-commandline-${FLYWAY_VERSION}.tar.gz
RUN ls -l -h
RUN gzip -d flyway-commandline-${FLYWAY_VERSION}.tar.gz 
RUN tar -xf flyway-commandline-${FLYWAY_VERSION}.tar --strip-components=1 
RUN rm flyway-commandline-${FLYWAY_VERSION}.tar 
RUN chmod -R a+r /flyway 
RUN chmod a+x /flyway/flyway

ENV PATH="/flyway:${PATH}"

ENTRYPOINT ["flyway"]
CMD ["-?"]