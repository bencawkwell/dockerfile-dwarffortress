FROM ubuntu:precise
MAINTAINER Ben Cawkwell <bencawkwell@gmail.com>

# Setup

ADD setup.sh /setup.sh

RUN DF_MAJORVERSION=40 DF_MINORVERSION=24 bash -ex /setup.sh


VOLUME /home/xpra/.ssh

VOLUME /df_linux/data/save
# Script that will handle running Dwarf Fortress in xpra if needed
ADD sshd_config /etc/ssh/sshd_config
ADD start.sh /start.sh

ENV LANG C.UTF-8
EXPOSE 22
ENTRYPOINT ["/start.sh"]
