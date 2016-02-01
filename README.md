dockerfile-dwarffortress
========================

Dwarf Fortress in a container. Tested on Mint 17.

Configuring
-----------

Edit the Dockerfile under the section "Run each playbook" by commenting or uncommenting each line. Hopefully that section is self explanatory.

Building
--------

Make sure you are in the same directory as the Dockerfile

    cd dockerfile-dwarffortress

Build the image and tag it dwarffortress.

    docker build -t dwarffortress .

Running
-------

There are a few options, which depend on which playbooks have been uncommented in the Dockerfile:

### X11 ###

Run in the X session on the host. Before using this method you may need to run the following on the host to permit access to the X session from within a docker container:

    xhost +local:docker

To start dwarf fortress in the container with sound on your hosts display:

    docker run -t -i -e DISPLAY=unix$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix -v /dev/snd:/dev/snd --lxc-conf='lxc.cgroup.devices.allow = c 116:* rwm' dwarffortress

### noVNC ###

This allows you to connect and control Dwarf Fortress using a web browser. Since it requires a specific port you would run the container using the command:

    docker run -t -i -p 6080:6080 dwarffortress

If you also included dfhack then the dfhack console should be right in front of you. You can then access the game by visiting http://localhost:6080/vnc.html in your browser and click "connect" (there is no password).

### XPRA ###

This mode allows you to remotely run Dwarf Fortress but within a window as if it was running locally. Unfortunately this is the most complicated method and has some quirks to work around, for example:

* You must use the latest version of XPRA to connect, the version normally available through the package managers is out of date, instead get the latest version from https://winswitch.org.
* DO NOT USE FULLSCREEN, it will result in really high load, I suspect this is because Dwarf Fortress tries to scale to fit the window, and fullscreen in XPRA reports this in a quirky way.
* DO NOT PROVISION NOVNC, since that playbook already sets up an instance of Xvfb on DISPLAY 1, so the xpra process fails to start.
* The only reliable encoding I have found to work is "Raw RGB + zlib".

Since XPRA uses SSH, you need to bind port 22 to the host, so run the docker container using:

    docker run -t -i -p 2222:22 dwarffortress

If you included dfhack then the dfhack console will appear. You can use xpra to connect using the command:

    xpra attach --encoding=rgb --ssh="ssh -p 2222" ssh:df@localhost:1

The password is "changeme".

### TEXT mode ###

By far the simplest method, but you loose out on a dfhack console, and using a tile set. There is not special ports required since Dwarf Fortress is just controlled from the console you run the container.

### Saved Games ###

If you do not specify a way to save the game, quitting DF will lose your game.

The easiest way to keep your saved games between container restarts is to use dockers -v option to map a directory on your host to the save directory inside the container. The following example will mean any saves you make in the game will end up in the directory /tmp/save:

    docker run -i -t -v /tmp/save/:/df_linux/data/save/ dwarffortress

Remember to make the directory readable and ensure it has plenty of disk space, since there is a known issue in Dwarf Fortress that it will pretend to save successfully even if it has not.

### Saved Games and changing tile set ###

Assuming you use volume mapping to store saved games, you may choose to rebuild the container with a different tile set configured. After you have rebuilt you will need to trigger an update to your saved files:

    docker run -i -t -v /tmp/save/:/df_linux/data/save/ dwarffortress --update-saves

### Launch options ###

Some settings in init.txt can be changed by passing options, for example to skip the intro:

    docker run -t -i dwarffortress --skip-intro

To see the full list of possible options:

    docker run -t -i dwarffortress --help

Todo
----

* Fix sound.
* Perhaps wait for user feedback before starting DF so that you can connect first so you do not miss the awesome intro!