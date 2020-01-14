# Copyright 2019, Burkhard Stubert (DBA Embedded Use)

# In any directory on the docker host, perform the following actions:
#   * Copy this Dockerfile in the directory.
#   * Create input and output directories: mkdir -p yocto/output yocto/input
#   * Build the Docker image with the following command:
#     docker build --no-cache --build-arg "host_uid=$(id -u)" --build-arg "host_gid=$(id -g)" \
#         --tag "cuteradio-image:latest" .
#   * Run the Docker image, which in turn runs the Yocto and which produces the Linux rootfs,
#     with the following command:
#     docker run -it --rm -v $PWD/yocto/output:/home/cuteradio/yocto/output cuteradio-image:latest

# Use Ubuntu 16.04 LTS as the basis for the Docker image.
# docker build -t xx1 .

# docker run -it --rm -v $PWD/output:/home/cuteradio/output xx1:latest
FROM ubuntu:16.04

RUN dpkg -l | sort > /usr/src/pkgs.txt

RUN wc /usr/src/pkgs.txt

# Install all the Linux packages required for Yocto builds. Note that the packages python3,
# tar, locales and cpio are not listed in the official Yocto documentation. The build, however,
# without them.

RUN apt-get update && apt-get -y install gawk wget git-core diffstat unzip texinfo gcc-multilib \
     build-essential chrpath socat cpio python python3 python3-pip python3-pexpect \
     xz-utils debianutils iputils-ping libsdl1.2-dev xterm tar locales

RUN dpkg -l | sort > /usr/src/pkgsyocto.txt

RUN wc /usr/src/pkgsyocto.txt

# Step 5/6 : RUN dpkg -l | sort > /usr/src/pkgsyocto.txt
# ---> Running in b2d6c3089046
# Removing intermediate container b2d6c3089046
# ---> 5635488741aa
# Step 6/6 : RUN wc /usr/src/pkgsyocto.txt
# ---> Running in f415e4014b63
#  447  4388 56883 /usr/src/pkgsyocto.txt
# Removing intermediate container f415e4014b63
# ---> 373cb33c18e4
# Successfully built 373cb33c18e4
# Successfully tagged xx:latest
# By default, Ubuntu uses dash as an alias for sh. Dash does not support the source command
# needed for setting up the build environment in CMD. Use bash as an alias for sh.
RUN rm /bin/sh && ln -s bash /bin/sh

# Set the locale to en_US.UTF-8, because the Yocto build fails without any locale set.
RUN locale-gen en_US.UTF-8 && update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8

ENV USER_NAME cuteradio
ENV PROJECT cuteradio

# The running container writes all the build artefacts to a host directory (outside the container).
# The container can only write files to host directories, if it uses the same user ID and
# group ID owning the host directories. The host_uid and group_uid are passed to the docker build
# command with the --build-arg option. By default, they are both 1001. The docker image creates
# a group with host_gid and a user with host_uid and adds the user to the group. The symbolic
# name of the group and user is cuteradio.
ARG host_uid=1001
ARG host_gid=1001

RUN groupadd -g $host_gid $USER_NAME && useradd -g $host_gid -m -s /bin/bash -u $host_uid $USER_NAME

# Perform the Yocto build as user cuteradio (not as root).
# NOTE: The USER command does not set the environment variable HOME.

# By default, docker runs as root. However, Yocto builds should not be run as root, but as a 
# normal user. Hence, we switch to the newly created user cuteradio.
USER $USER_NAME

# Create the directory structure for the Yocto build in the container. The lowest two directory
# levels must be the same as on the host.
ENV BUILD_INPUT_DIR /home/$USER_NAME/yocto/input
ENV BUILD_OUTPUT_DIR /home/$USER_NAME/yocto/output
RUN mkdir -p $BUILD_INPUT_DIR $BUILD_OUTPUT_DIR
