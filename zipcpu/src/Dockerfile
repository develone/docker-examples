FROM ubuntu:16.04

# Install all the Linux packages required for Yocto builds. Note that the packages python3,
# tar, locales and cpio are not listed in the official Yocto documentation. The build, however,
# without them.
RUN apt-get update && apt-get -y install gawk wget git-core diffstat unzip texinfo gcc-multilib \
     build-essential chrpath socat cpio python python3 python3-pip python3-pexpect \
     xz-utils debianutils iputils-ping libsdl1.2-dev xterm tar locales

# By default, Ubuntu uses dash as an alias for sh. Dash does not support the source command
# needed for setting up the build environment in CMD. Use bash as an alias for sh.
# By default, Ubuntu uses dash as an alias for sh. Dash does not support the source command
# needed for setting up the build environment in CMD. Use bash as an alias for sh.

RUN rm /bin/sh && ln -s bash /bin/sh

# Set the locale to en_US.UTF-8, because the Yocto build fails without any locale set.
RUN locale-gen en_US.UTF-8 && update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8

ENV USER_NAME zipcpu
ENV PROJECT zipcpu


 
# /module is used for releases when we check out code in the toolbelt container
# It is passed on to the builder with --volumes-from
# Make sure it is accessible for all users
RUN mkdir /module && chmod 777 /module

WORKDIR /module

RUN git clone https://github.com/develone/autofpga.git autofpga \
    && cd autofpga \
    && make \

    && cp module/autofpga/sw/autofpga /usr/local/binautofpga
    && cd .. && rm -rf autofpga

