
#FROM resin/raspberrypi2-debian:latest
FROM resin/raspberry-pi2-debian
MAINTAINER BaseBoxOrg

ENV GIT_PROJECT     dualminer-cgminer
ENV GIT_URL         https://github.com/dualminer/${GIT_PROJECT}.git
ENV GIT_BRANCH      master
ENV REFRESHED_AT    2007-09-04

# install dependencies
RUN apt-get update && \
    apt-get -qqy install --no-install-recommends \
    build-essential git autoconf automake make libssl-dev libcurl4-openssl-dev \
    pkg-config libtool libncurses5-dev libudev-dev libusb-1.0-0 libusb-1.0-0-dev \
    nano screen && \
    rm -rf /var/lib/apt/lists/*

RUN git clone -b "$GIT_BRANCH" "$GIT_URL" /${GIT_PROJECT} && \
    cd /${GIT_PROJECT} && \
    chmod +x autogen.sh configure && \
    ./autogen.sh && \
    ./configure --enable-dualminer --enable-scrypt --disable-opencl && \
    make

WORKDIR /${GIT_PROJECT}

ENTRYPOINT	["./${GIT_PROJECT}"]

CMD ["--help"]
