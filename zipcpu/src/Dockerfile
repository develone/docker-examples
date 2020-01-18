FROM ubuntu:xenial

RUN apt-get update && apt-get install -y build-essential clang bison flex libreadline-dev \
                                         gawk tcl-dev libffi-dev git mercurial \
                                         pkg-config python python3 libftdi-dev \
                                         python3-dev libboost-all-dev cmake libeigen3-dev \
    && rm -rf /var/lib/apt/lists/*

# By default, Ubuntu uses dash as an alias for sh. Dash does not support the source command
# needed for setting up the build environment in CMD. Use bash as an alias for sh.

RUN rm /bin/sh && ln -s bash /bin/sh

# Set the locale to en_US.UTF-8, because the Yocto build fails without any locale set.
RUN locale-gen en_US.UTF-8 && update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8

ENV USER_NAME zipcpu
ENV PROJECT zipcpu

RUN git clone https://github.com/develone/autofpga.git autofpga \
    && cd autofpga \
    && make -j$(nproc) \
    && make install \
    && cd .. && rm -rf autofpga

 
# /module is used for releases when we check out code in the toolbelt container
# It is passed on to the builder with --volumes-from
# Make sure it is accessible for all users
RUN mkdir /module && chmod 777 /module

WORKDIR /module
