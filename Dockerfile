FROM ansible/ubuntu14.04-ansible:stable
MAINTAINER Ben Cawkwell <bencawkwell@gmail.com>

# Install core
ENV DFPKGS unzip
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y $DFPKGS

# Add the ansible playbooks from github
ADD https://github.com/bencawkwell/ansible-dwaffortress/archive/master.zip /ansible.zip
RUN unzip /ansible.zip
RUN ln -s /ansible-dwaffortress-master /ansible

# Run each playbook
RUN cd /ansible && ansible-playbook dwarffortress.yml --connection=local
# Comment the line below if you do not want dfhack
RUN cd /ansible && ansible-playbook dfhack.yml --connection=local

# Only pick ONE of the following display options:

# 2D mode using noVNC (control via a browser)
RUN cd /ansible && ansible-playbook novnc.yml --connection=local

# 2D mode using XPRA
#RUN cd /ansible && ansible-playbook xpra.yml --connection=local

# TEXT mode (in the console)
#RUN cd /ansible && ansible-playbook textmode.yml --connection=local

# Add scripts
ADD https://github.com/bencawkwell/supervisor-tools/raw/master/wait-for-daemons.sh /wait-for-daemons.sh
ADD start.sh /start.sh
RUN chmod +x /wait-for-daemons.sh /start.sh

ENV LANG C.UTF-8
VOLUME ["/df_linux/data/save"]

ENTRYPOINT ["/start.sh"]
