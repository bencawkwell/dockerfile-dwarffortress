FROM ubuntu:precise
MAINTAINER Ben Cawkwell <bencawkwell@gmail.com>

# Update the system
RUN echo "deb http://archive.ubuntu.com/ubuntu precise main universe" > /etc/apt/sources.list
RUN apt-get update
RUN apt-get upgrade -y

# The fuse workaround, thanks to Roberto G. Hashioka (https://github.com/rogaha/docker-desktop)
RUN apt-get -y install fuse  || :
RUN rm -rf /var/lib/dpkg/info/fuse.postinst
RUN apt-get -y install fuse

# Install dwarf fortress dependencies
RUN apt-get install -y --no-install-recommends bzip2 ia32-libs libsdl-image1.2 libsdl-sound1.2 libsdl-ttf2.0-0

# Fetch and extract the game
RUN wget http://www.bay12games.com/dwarves/df_34_11_linux.tar.bz2
RUN tar -xjf df_34_11_linux.tar.bz2

# Fix OpenAl error
RUN ln -s /usr/lib/i386-linux-gnu/libopenal.so.1 df_linux/libs/libopenal.so
RUN ln -s /usr/lib/i386-linux-gnu/libsndfile.so.1 df_linux/libs/libsndfile.so

# Add DFHack
RUN wget http://dethware.org/dfhack/download/dfhack-0.34.11-r3-Linux.tar.gz
RUN cd df_linux && tar -xvzf ../dfhack-0.34.11-r3-Linux.tar.gz

# Add a utility for modifying df config files via the commandline
ADD https://raw2.github.com/bencawkwell/launch_df/master/launch_df launch_df
RUN chmod +x launch_df

ENTRYPOINT ["/launch_df"]
CMD ["df_linux/dfhack"]