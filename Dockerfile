# Cromwell Releases
# https://github.com/broadinstitute/cromwell/releases/tag/34


FROM ubuntu:17.10
LABEL maintainer="Steve Tsang <mylagimail2004@yahoo.com>"

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get -yq dist-upgrade \
 && apt-get install -yq --no-install-recommends \
    build-essential \
    apt-utils \
    wget \
    git-all \
    default-jre \
    nano

WORKDIR /opt
RUN wget https://github.com/broadinstitute/cromwell/releases/download/34/cromwell-34.jar
RUN wget https://github.com/broadinstitute/cromwell/releases/download/34/womtool-34.jar
RUN cp *.jar /usr/local/bin

RUN DEBIAN_FRONTEND=noninteractive apt-get install --yes \
 build-essential \
 gcc-multilib \
 apt-utils \
 zlib1g-dev \
 cmake \
 libhdf5-dev \
 git-all \
 autoconf \
 automake \
 libcurl4-openssl-dev \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# Get latest source from releases
WORKDIR /opt
RUN git clone https://github.com/pachterlab/kallisto.git
WORKDIR kallisto
RUN git clone https://github.com/samtools/htslib
RUN rm -rf -f build
RUN rm -rf /ext/htslib
RUN cp -r htslib /ext/
WORKDIR /opt/kallisto/ext/htslib
RUN autoconf && autoheader
WORKDIR /opt/kallisto
RUN mkdir build
WORKDIR build
RUN cmake ..
RUN make
RUN make install
