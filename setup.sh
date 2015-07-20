#!/bin/sh

# Update the system
echo "deb http://archive.ubuntu.com/ubuntu precise main universe" >> /etc/apt/sources.list
apt-get update
apt-get upgrade -y

# Install wget
apt-get install -y curl
# Install supervisord.
apt-get install -y supervisor

# Setup sshd
apt-get install -y ssh
mkdir /var/run/sshd
echo 'root:changeme' |chpasswd
/bin/echo -e "[program:sshd] \ncommand=/usr/sbin/sshd -D \n" > /etc/supervisor/conf.d/sshd.conf

# Install Xpra
curl  http://winswitch.org/gpg.asc | apt-key add -
echo "deb http://winswitch.org/ precise main" > /etc/apt/sources.list.d/winswitch.list
apt-get update
apt-get install -y --no-install-recommends xpra
useradd -m xpra
echo 'xpra:changeme' |chpasswd
chsh -s /bin/bash xpra
/bin/echo -e "export DISPLAY=:100" > /home/xpra/.profile
/bin/echo -e "[program:xpra] \ncommand=xpra start --no-daemon :100 \nuser=xpra \nenvironment=HOME=\"/home/xpra\" \n" > /etc/supervisor/conf.d/xpra.conf

# Fetch a utility for pausing bash scripts until supervisord has finished starting programs
curl -LO https://github.com/bencawkwell/supervisor-tools/raw/master/wait-for-daemons.sh 
chmod +x wait-for-daemons.sh

# The fuse workaround, thanks to Roberto G. Hashioka (https://github.com/rogaha/docker-desktop)
apt-get -y install fuse  || :
rm -rf /var/lib/dpkg/info/fuse.postinst
apt-get -y install fuse

# Install dwarf fortress dependencies (libgl1-mesa-swrast has to be installed separately otherwise we get an dpkg dependency issue on configuration)
apt-get install -y --no-install-recommends unzip bzip2 ia32-libs libsdl-image1.2 libsdl-sound1.2 libsdl-ttf2.0-0 libjpeg62:i386 && apt-get install -y libgl1-mesa-swrast libgl1-mesa-swrast:i386

# Fetch and extract the game
curl --retry 3 -OL http://www.bay12games.com/dwarves/df_$(echo $DF_MAJORVERSION)_$(echo $DF_MINORVERSION)_linux.tar.bz2
tar -xjf df_$(echo $DF_MAJORVERSION)_$(echo $DF_MINORVERSION)_linux.tar.bz2
rm df_$(echo $DF_MAJORVERSION)_$(echo $DF_MINORVERSION)_linux.tar.bz2

# Fix OpenAl error
ln -s /usr/lib/i386-linux-gnu/libopenal.so.1 df_linux/libs/libopenal.so
ln -s /usr/lib/i386-linux-gnu/libsndfile.so.1 df_linux/libs/libsndfile.so

# Add DFHack
curl --retry 3 -LO http://dethware.org/dfhack/download/dfhack-0.34.11-r3-Linux.tar.gz
pushd df_linux && tar -xvzf ../dfhack-0.34.11-r3-Linux.tar.gz && popd
rm dfhack-0.34.11-r3-Linux.tar.gz

# Setup the save directory
mkdir /df_linux/data/save
chmod 777 /df_linux/data/save

# Setup the save directory
mkdir -p /tilesets
chmod 777 /tilesets

# Download the Phoebus tileset
wget -O Phoebus_34_11v01.zip http://dffd.wimbli.com/download.php\?id=2430\&f=Phoebus_34_11v01.zip
mkdir /tilesets/Phoebus
unzip Phoebus_34_11v01.zip -d /tilesets/Phoebus
mv /tilesets/Phoebus/data/init/phoebus/* /tilesets/Phoebus/data/init/
rm Phoebus_34_11v01.zip 

# Download the Mike Mayday tileset
wget -O Mayday+34.11.zip http://dffd.wimbli.com/download.php?id=7025\&f=Mayday+34.11.zip
unzip Mayday+34.11.zip -d /tilesets
rm Mayday+34.11.zip

# Add a utility for modifying df config files via the commandline
pushd /
curl --retry 3 -LO https://github.com/bencawkwell/launch_df/raw/v0.2.2/launch_df
chmod +x launch_df
popd

# Add a utility for watching directories and committing them using git automatically
curl --retry 3 -O https://github.com/bencawkwell/gitwatch/raw/master/gitwatch.sh

apt-get install -y git gitk inotify-tools
chmod +x /gitwatch.sh
/bin/echo -e "[program:gitwatch] \ncommand=/gitwatch.sh -s 60 /df_linux/data/save \nautostart=false" > /etc/supervisor/conf.d/gitwatch.conf

apt-get purge -y curl
apt-get autoremove -y
