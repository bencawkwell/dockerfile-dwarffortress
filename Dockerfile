FROM ansible/ubuntu14.04-ansible:stable
MAINTAINER Ben Cawkwell <bencawkwell@gmail.com>

# Install core
ENV DFPKGS unzip
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y $DFPKGS

# Add the ancible playbooks from github
ADD https://github.com/bencawkwell/ansible-dwaffortress/archive/master.zip /ansible.zip
RUN unzip /ansible.zip
RUN ln -s /ansible-dwaffortress-master /ansible

# Run each playbook
RUN cd /ansible && ansible-playbook dwarffortress.yml --connection=local
RUN cd /ansible && ansible-playbook textmode.yml --connection=local

ENV LANG C.UTF-8
VOLUME ["/df_linux/data/save"]

ENTRYPOINT ["/df_linux/df"]
