# Copyright 2019, Burkhard Stubert (DBA Embedded Use)

# In any directory on the docker host, perform the following actions:
#   * Copy this Dockerfile in the directory.
#   * Create input and output directories: mkdir -p yocto/output yocto/input
#   * Build the Docker image with the following command:
#     docker build --no-cache --build-arg "host_uid=$(id -u)" --build-arg "host_gid=$(id -g)" \
#         --tag "cuteradio-image:latest" .
#   * Run the Docker image, which in turn runs the Yocto and which produces the Linux rootfs,
#     with the following command:
#     docker run -it --rm -v $PWD/yocto/output:/home/zipcpu/yocto/output zipcpu:0.62

# Use Ubuntu 16.04 LTS as the basis for the Docker image.
FROM ubuntu:16.04

# Install all the Linux packages required for Yocto builds. Note that the packages python3,
# tar, locales and cpio are not listed in the official Yocto documentation. The build, however,
# without them.
RUN apt-get update && apt-get -y install gawk wget git-core diffstat unzip texinfo gcc-multilib \
     build-essential chrpath socat cpio python python3 python3-pip python3-pexpect \
     xz-utils debianutils iputils-ping libsdl1.2-dev xterm tar locales \
     bison flex autoconf automake libtool libgmp3-dev \
     libmpfr-dev libmpfr-doc libmpfr4 libmpfr4-dbg libmpc-dev libelf-dev bc \
     ncurses-dev ctags mercurial gperf \
     clang libreadline-dev tcl-dev libffi-dev pkg-config libftdi-dev libboost-all-dev \
     cmake libeigen3-dev
#The following packages are needed when creating zipcpu:06
#with docker-fpga-builder
#     clang libreadline-dev tcl-dev libffi-dev pkg-config libftdi-dev libboost-all-dev \
#     cmake libeigen3-dev
 


# By default, Ubuntu uses dash as an alias for sh. Dash does not support the source command
# needed for setting up the build environment in CMD. Use bash as an alias for sh.
RUN rm /bin/sh && ln -s bash /bin/sh

# Set the locale to en_US.UTF-8, because the Yocto build fails without any locale set.
RUN locale-gen en_US.UTF-8 && update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8

ENV USER_NAME zipcpu
ENV PROJECT zipcpu

# The running container writes all the build artefacts to a host directory (outside the container).
# The container can only write files to host directories, if it uses the same user ID and
# group ID owning the host directories. The host_uid and group_uid are passed to the docker build
# command with the --build-arg option. By default, they are both 1001. The docker image creates
# a group with host_gid and a user with host_uid and adds the user to the group. The symbolic
# name of the group and user is cuteradio.
ARG host_uid=1000
ARG host_gid=1000
RUN groupadd -g $host_gid $USER_NAME && useradd -g $host_gid -m -s /bin/bash -u $host_uid $USER_NAME

# Perform the Yocto build as user cuteradio (not as root).
# NOTE: The USER command does not set the environment variable HOME.

RUN git clone https://github.com/develone/icestorm.git icestorm \
    && cd icestorm \
    && make -j$(nproc) \
    && make install \
    && cd .. && rm -rf icestorm

RUN git clone https://github.com/develone/nextpnr nextpnr \
    && cd nextpnr \
    && cmake -DARCH=ice40 -DBUILD_GUI=OFF -DCMAKE_INSTALL_PREFIX=/usr/local . \
    && make -j$(nproc) \
    && make install \
    && cd .. && rm -rf nextpnr

RUN git clone https://github.com/develone/yosys.git yosys \
    && cd yosys && git checkout 0488492 \
    && make -j$(nproc) \
    && make install \
    && cd .. && rm -rf yosys

#/using ver from mypi3-15 
RUN git clone https://git.veripool.org/git/verilator \
    && cd verilator && git checkout v3.926 \
    && autoconf \
    && ./configure --prefix /usr/local \
    && make \
    && make install \
    && cd ../ \
    && rm -rf verilator

#/using ver from mypi3-15 
RUN git clone https://github.com/develone/zipcpu.git \
    && cd zipcpu && git checkout  006f4c \
    && make \
    && tar -cvf /usr/local/share/zipcpu.tar ../zipcpu  \
    && cd /usr/local/share \
    && tar -xvf zipcpu.tar \
    && rm -f zipcpu.tar

RUN git clone https://github.com/develone/autofpga.git autofpga \
    && cd autofpga \
    && make \
    && cp sw/autofpga /usr/local/bin \
    && cd .. && rm -rf autofpga 
# By default, docker runs as root. However, Yocto builds should not be run as root, but as a 
# normal user. Hence, we switch to the newly created user cuteradio.
USER $USER_NAME

# Create the directory structure for the Yocto build in the container. The lowest two directory
# levels must be the same as on the host.
ENV BUILD_INPUT_DIR /home/$USER_NAME/yocto/input
ENV BUILD_OUTPUT_DIR /home/$USER_NAME/yocto/output
RUN mkdir -p $BUILD_INPUT_DIR $BUILD_OUTPUT_DIR




