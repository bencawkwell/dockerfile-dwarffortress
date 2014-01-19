# Base docker image
FROM ubuntu:precise
MAINTAINER	Ben Cawkwell <bencawkwell@gmail.com>

# Common useful packages
RUN echo "deb http://archive.ubuntu.com/ubuntu precise main universe" > /etc/apt/sources.list
RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -y wget nano bzip2

# Fake a fuse install, thanks to Henrik Mühe (https://gist.github.com/henrik-muehe/6155333)
RUN apt-get install libfuse2
RUN cd /tmp ; apt-get download fuse
RUN cd /tmp ; dpkg-deb -x fuse_* .
RUN cd /tmp ; dpkg-deb -e fuse_*
RUN cd /tmp ; rm fuse_*.deb
RUN cd /tmp ; echo -en '#!/bin/bash\nexit 0\n' > DEBIAN/postinst
RUN cd /tmp ; dpkg-deb -b . /fuse.deb
RUN cd /tmp ; dpkg -i /fuse.deb

# Install dwarf fortress dependencies
RUN apt-get install -y --no-install-recommends ia32-libs libsdl-image1.2 libsdl-sound1.2 libsdl-ttf2.0-0

# Fetch and extract the game
RUN wget http://www.bay12games.com/dwarves/df_34_11_linux.tar.bz2
RUN tar -xjf df_34_11_linux.tar.bz2

# Fix OpenAl error
RUN ln -s /usr/lib/i386-linux-gnu/libopenal.so.1 df_linux/libs/libopenal.so
RUN ln -s /usr/lib/i386-linux-gnu/libsndfile.so.1 df_linux/libs/libsndfile.so

# Add DFHack
RUN wget http://dethware.org/dfhack/download/dfhack-0.34.11-r3-Linux.tar.gz
RUN cd df_linux && tar -xvzf ../dfhack-0.34.11-r3-Linux.tar.gz

# Custom launch script that allows setting some options in init.txt using commandline parameters
ADD start.sh start.sh

ENTRYPOINT ["/start.sh"]
