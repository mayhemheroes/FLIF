# Build Stage
FROM --platform=linux/amd64 ubuntu:20.04 as builder

## Install build dependencies.
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y cmake clang autoconf automake pkg-config

## Add source code to the build stage.
ADD . /flif
WORKDIR /flif

RUN apt -y install libpng-dev libsdl2-dev
RUN CXX=clang++ CXXFLAGS=-fsanitize=address make flif

# Package Stage
FROM --platform=linux/amd64 ubuntu:20.04

COPY --from=builder /lib/x86_64-linux-gnu/libpng16.so.16 /lib/x86_64-linux-gnu/libpng16.so.16
COPY --from=builder /flif/src/flif /flif
RUN mkdir /corpus
COPY --from=builder /flif/testFiles/sig05-014.png /corpus
