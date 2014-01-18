dockerfile-dwarffortress
========================

Dwarf Fortress in a container. Tested on Mint 15 and 16.

Usage
-----

    wget https://raw2.github.com/bencawkwell/dockerfile-dwarffortress/master/Dockerfile

    docker build -t DwarfFortress -rm .

    docker run -v /tmp/.X11-unix:/tmp/.X11-unix -v /dev/snd:/dev/snd -lxc-conf='lxc.cgroup.devices.allow = c 116:* rwm' -e DISPLAY=unix$DISPLAY DwarfFortress


Todo
----

* Add DFHack (currently there is an issue using dfhack as the ENTRYPOINT, which I think is related to https://github.com/dotcloud/docker/issues/2780).
* Perhaps a commandline option to toggle TEXT mode.
* Add some common tilesets or
* Use the lazy newb pack (http://www.bay12forums.com/smf/index.php?topic=130792)

Credits
-------

* Obviously Toady One at http://www.bay12games.com for Dwarf Fortress.
* Daniel Mizyrycki for the slideshow (http://www.slideshare.net/dotCloud/dockerizing-your-appli) that helped get started.
* Henrik Mühe for the fuse install hack (https://gist.github.com/henrik-muehe/6155333)
* All the guys that maintain the Dwarf Fortress wiki (http://dwarffortresswiki.org/index.php/DF2012:Installation)
