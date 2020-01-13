# docker build -t xx1 .

# docker run -it --rm -v $PWD/output:/home/cuteradio/output xx1:latest
FROM ubuntu:16.04

RUN dpkg -l | sort > /usr/src/pkgs.txt

RUN wc /usr/src/pkgs.txt

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
RUN rm /bin/sh && ln -s bash /bin/sh
ENV USER_NAME cuteradio

ENV PROJECT cuteradio

ARG host_uid=1001

ARG host_gid=1001

RUN groupadd -g $host_gid $USER_NAME && useradd -g $host_gid -m -s /bin/bash -u $host_uid $USER_NAME

RUN cd /home/cuteradio

RUN git clone https://github.com/develone/svd_rgb.git
