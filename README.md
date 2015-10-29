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

Assuming you chose to build with noVNC enabled:

    docker run -t -i -p 6080:6080 dwarffortress

If you also included dfhack then the dfhack console should be right in front of you. You can then access the game by visiting http://localhost:6080/vnc.html in your browser and click "connect" (there is no password).

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