FROM debian:stable

RUN apt-get update -y && apt-get upgrade -y && apt-get dist-upgrade -y
RUN apt-get install -y curl wget

RUN echo "deb http://emdebian.org/tools/debian/ jessie main" > "/etc/apt/sources.list.d/crosstools.list"
RUN curl http://emdebian.org/tools/debian/emdebian-toolchain-archive.key | apt-key add -
RUN dpkg --add-architecture armel
RUN apt-get update -y && apt-get upgrade -y && apt-get dist-upgrade -y
RUN apt-get install -y build-essential binutils-arm-linux-gnueabi crossbuild-essential-armel
