###  This image is created for the 2018 ACM-BCB Workshop
###  NCI Cloud Resources
###  https://stevetsa.github.io/post/acmbcb-ncicr/


FROM ubuntu:17.10
LABEL maintainer="Steve Tsang <mylagimail2004@yahoo.com>"

###
### Install Cromwell and WDL Tools
### Cromwell Releases 34
### https://github.com/broadinstitute/cromwell/releases/tag/34
###

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

###
###  Install Kallisto
###  https://github.com/pachterlab/kallisto
###

RUN DEBIAN_FRONTEND=noninteractive apt-get install --yes \
 gcc-multilib \
 zlib1g-dev \
 cmake \
 libhdf5-dev \
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

WORKDIR /opt
RUN git clone https://github.com/stevetsa/2018-ACMBCB-workshop.git
