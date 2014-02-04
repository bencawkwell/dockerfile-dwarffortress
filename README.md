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

    docker run -t -i DwarfFortress -p TEXT df_linux/df

In order to run in 2D mode you need to map stuff from the host to the container

    docker run -t -i -v /tmp/.X11-unix:/tmp/.X11-unix -v /dev/snd:/dev/snd -lxc-conf='lxc.cgroup.devices.allow = c 116:* rwm' -e DISPLAY=unix$DISPLAY DwarfFortress

DfHack is included in the container, to use it simply specify the path to it when running the container

    docker run -t -i -v /tmp/.X11-unix:/tmp/.X11-unix -v /dev/snd:/dev/snd -lxc-conf='lxc.cgroup.devices.allow = c 116:* rwm' -e DISPLAY=unix$DISPLAY DwarfFortress df_linux/dfhack

To see all the options available, get help

    docker run -t -i DwarfFortress -h

Remember, if you pass any options (other than -h) you also have to specify the path to either the df binary:

    df_linux/df

 or the dfhack script

    df_linux/dfhack

For example the following will NOT work:

    docker run -t -i DwarfFortress -p TEXT -s

Instead it should be:

    docker run -t -i DwarfFortress -p TEXT -s df_linux/df

Todo
----

* Include xpra so it can be played on a remote machine.
* Add some common tile-sets or
* Use the lazy newb pack (http://www.bay12forums.com/smf/index.php?topic=130792)
* Implement some practical way to keep saved games.

Credits
-------

* Obviously Toady One at http://www.bay12games.com for Dwarf Fortress.
* Daniel Mizyrycki for the slideshow (http://www.slideshare.net/dotCloud/dockerizing-your-appli) that helped get started.
* Henrik Mühe for the first fuse install hack I tried (https://gist.github.com/henrik-muehe/6155333)
* Roberto G. Hashioka for the current fuse install hack that seems to work better with xpra (https://github.com/rogaha/docker-desktop)
* All the guys that maintain the Dwarf Fortress wiki (http://dwarffortresswiki.org/index.php/DF2012:Installation)
