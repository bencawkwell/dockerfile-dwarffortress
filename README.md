dockerfile-dwarffortress
========================

Dwarf Fortress in a container. Tested on Mint 15 and 16.

Usage
-----

Make sure you are in the same directory as the Dockerfile

    cd dockerfile-dwarffortress

Build the image and tag it DwarfFortress. The -rm options cleans the cache after the final image has been created.

    docker build -t DwarfFortress -rm .

If you want to run in text mode

    docker run -t -i DwarfFortress -p TEXT /df_linux/df

In order to run in 2D mode you have two choices. The first is to map stuff from the host to the container

    docker run -t -i -v /tmp/.X11-unix:/tmp/.X11-unix -v /dev/snd:/dev/snd -lxc-conf='lxc.cgroup.devices.allow = c 116:* rwm' -e DISPLAY=unix$DISPLAY DwarfFortress /df_linux/df

When prompted to continue without xpra, hit y.

The other option is to connect to the container using xpra. The advantage of this approach is you can connect from a different machine to where the container is running. Since xpra runs over ssh you need to map port 22 from the container to a port on your host.

    docker run -i -t -p 1022:22 DwarfFortress /df_linux/df

Both sshd and xpra will be started, and then it will wait for you to hit a key before launching Dwarf Fortress. This is to give you time to connect so that you do not miss the really cool intro. Assuming you used the above command to start the container you can use the following to connect from the same machine. The password is changeme.

     xpra attach --ssh="ssh -p 1022" ssh:xpra@localhost:100

Bear in mind that the default version of xpra included in the Ubuntu repositories is usually really old. I would recommend installing the latest version from http://winswitch.org/downloads/

DfHack is included in the container, to use it simply replace the path to df with the path to dfhack

    docker run -t -i -v /tmp/.X11-unix:/tmp/.X11-unix -v /dev/snd:/dev/snd -lxc-conf='lxc.cgroup.devices.allow = c 116:* rwm' -e DISPLAY=unix$DISPLAY DwarfFortress /df_linux/dfhack

The Phoebus tile set is also included, you can use it by passing the -t option:

    docker run -i -t -p 1022:22 DwarfFortress -t /Phoebus /df_linux/df

To see all the options available, get help

    docker run -t -i DwarfFortress -h

Todo
----

* There seems to be an issue with parts of the screen are the wrong colour or goes blurry when using xpra. Need to investigate whether some settings could fix this.
* Clean up the entry point argument handling to be simpler. Its a bit annoying to have to use /Phoebus instead of just Phoebus.
* Add some more tile sets.
* Implement some practical way to keep saved games.
* Ideally remove the start.sh script again to keep the Dockerfile self contained.

Credits
-------

* Obviously Toady One at http://www.bay12games.com for Dwarf Fortress.
* Daniel Mizyrycki for the slideshow (http://www.slideshare.net/dotCloud/dockerizing-your-appli) that helped get started.
* Henrik Mühe for the first fuse install hack I tried (https://gist.github.com/henrik-muehe/6155333)
* Roberto G. Hashioka for the current fuse install hack that seems to work better with xpra (https://github.com/rogaha/docker-desktop)
* All the guys that maintain the Dwarf Fortress wiki (http://dwarffortresswiki.org/index.php/DF2012:Installation)
