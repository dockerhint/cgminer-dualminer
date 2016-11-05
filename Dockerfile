
FROM resin/raspberrypi2-debian:latest
MAINTAINER BaseBoxOrg

ENV GIT_PROJECT     dualminer-cgminer
ENV GIT_URL         https://github.com/dualminer/${GIT_PROJECT}.git
ENV GIT_BRANCH      master
ENV REFRESHED_AT    2016-11-05

# install dependencies
RUN apt-get update && \
    apt-get -qqy install --no-install-recommends \
    build-essential git autoconf automake make libssl-dev libcurl4-openssl-dev \
    pkg-config libtool libncurses5-dev libudev-dev libusb-1.0-0 libusb-1.0-0-dev && \
    rm -rf /var/lib/apt/lists/*
     
    
RUN mkdir -p /tmp/build && \
   git clone -b "$GIT_BRANCH" "$GIT_URL" /tmp/build/${GIT_PROJECT} && \
   cd /tmp/build/${GIT_PROJECT} && \
   ./autogen.sh && \
   ./configure --enable-dualminer --enable-scrypt --disable-opencl && \
   make && \
   make install && \
   cp cgminer /usr/local/bin/cgminer && \
   chmod a+x /usr/local/bin/cgminer && \
   rm -rf /tmp/build

# no parameters display help
ENTRYPOINT ["/usr/local/bin/cgminer"]
CMD ["-h"]
