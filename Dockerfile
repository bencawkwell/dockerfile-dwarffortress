FROM ubuntu:precise
MAINTAINER Ben Cawkwell <bencawkwell@gmail.com>

# Update the system
RUN echo "deb http://archive.ubuntu.com/ubuntu precise main universe" > /etc/apt/sources.list
RUN apt-get update
RUN apt-get upgrade -y

# Install supervisord.
RUN apt-get install -y supervisor

# Setup sshd
RUN apt-get install -y ssh
RUN mkdir /var/run/sshd
RUN echo 'root:changeme' |chpasswd
RUN /bin/echo -e "[program:sshd] \ncommand=/usr/sbin/sshd -D \n" > /etc/supervisor/conf.d/sshd.conf

# Install Xpra
RUN wget -qO - http://winswitch.org/gpg.asc | apt-key add -
RUN echo "deb http://winswitch.org/ precise main" > /etc/apt/sources.list.d/winswitch.list
RUN apt-get update
RUN apt-get install -y --no-install-recommends xpra
RUN useradd -m xpra
RUN echo 'xpra:changeme' |chpasswd
RUN chsh -s /bin/bash xpra
RUN /bin/echo -e "export DISPLAY=:100" > /home/xpra/.profile
RUN /bin/echo -e "[program:xpra] \ncommand=xpra start --no-daemon :100 \nuser=xpra \nenvironment=HOME=\"/home/xpra\" \n" > /etc/supervisor/conf.d/xpra.conf

# Fetch a utility for pausing bash scripts until supervisord has finished starting programs
ADD https://github.com/bencawkwell/supervisor-tools/raw/master/wait-for-daemons.sh /wait-for-daemons.sh
RUN chmod +x wait-for-daemons.sh

# The fuse workaround, thanks to Roberto G. Hashioka (https://github.com/rogaha/docker-desktop)
RUN apt-get -y install fuse  || :
RUN rm -rf /var/lib/dpkg/info/fuse.postinst
RUN apt-get -y install fuse

# Install dwarf fortress dependencies (libgl1-mesa-swrast has to be installed separately otherwise we get an dpkg dependency issue on configuration)
RUN apt-get install -y --no-install-recommends unzip bzip2 ia32-libs libsdl-image1.2 libsdl-sound1.2 libsdl-ttf2.0-0 libjpeg62:i386 && apt-get install -y libgl1-mesa-swrast libgl1-mesa-swrast:i386

# Fetch and extract the game
RUN wget http://www.bay12games.com/dwarves/df_34_11_linux.tar.bz2
RUN tar -xjf df_34_11_linux.tar.bz2

# Fix OpenAl error
RUN ln -s /usr/lib/i386-linux-gnu/libopenal.so.1 df_linux/libs/libopenal.so
RUN ln -s /usr/lib/i386-linux-gnu/libsndfile.so.1 df_linux/libs/libsndfile.so

# Add DFHack
RUN wget http://dethware.org/dfhack/download/dfhack-0.34.11-r3-Linux.tar.gz
RUN cd df_linux && tar -xvzf ../dfhack-0.34.11-r3-Linux.tar.gz

# Download the Phoebus tileset
ADD http://dffd.wimbli.com/download.php?id=2430&f=Phoebus_34_11v01.zip /Phoebus_34_11v01.zip
RUN unzip Phoebus_34_11v01.zip -d Phoebus
RUN mv /Phoebus/data/init/phoebus/* /Phoebus/data/init/

# Add a utility for modifying df config files via the commandline
ADD https://github.com/bencawkwell/launch_df/raw/v0.2.1/launch_df /launch_df
RUN chmod 777 launch_df

# Script that will handle running Dwarf Fortress in xpra if needed
ADD start.sh /start.sh

EXPOSE 22
ENTRYPOINT ["/start.sh"]
CMD ["-h"]