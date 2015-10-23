dockerfile-dwarffortress
========================

Dwarf Fortress in a container. Tested on Mint 17.

Building
--------

Make sure you are in the same directory as the Dockerfile

    cd dockerfile-dwarffortress

Build the image and tag it dwarffortress.

    docker build -t dwarffortress .

Running
-------

    docker run -t -i dwarffortress

### Saved Games ###

If you do not specify a way to save the game, quitting DF will lose your game.

The easiest way to keep your saved games between container restarts is to use dockers -v option to map a directory on your host to the save directory inside the container. The following example will mean any saves you make in the game will end up in the directory /tmp/save:

    docker run -i -t -v /tmp/save/:/df_linux/data/save/ dwarffortress

Remember to make the directory readable and ensure it has plenty of disk space, since there is a known issue in Dwarf Fortress that it will pretend to save successfully even if it has not.

Todo
----

* Fix sound.
* Support for print_mode other than TEXT.