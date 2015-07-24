dockerfile-dwarffortress
========================

Dwarf Fortress in a container. Previously Tested on Mint 15 and 16, now on Mac OS X.


Building
--------

Make sure you are in the same directory as the Dockerfile

    cd dockerfile-dwarffortress

Build the image and tag it dwarffortress. The -rm options cleans the cache after the final image has been created.

    docker build -t dwarffortress -rm .


However this has been pushed to the Docker hub, so you can just use the existing copy.

Running
-------

Environment Variables
=====================

PRINTMODE: How the game is accessed:
  * XPRA (Default): Xpra over ssh. 

This is not secure enough to be put on the internet, it does not use publickey exchange to authenticate and falls back to password (default: changeme)

  docker run -e TILESET=Phoebus dwarffortress:latest

      If you wish to connect over the network rather than from the host to the container, you will have to map a port from the container to the host. 

  docker run -e TILESET=Phoebus -p 1022:22 dwarffortress:latest



  * X11 : Only works when running locally, maps docker files from the host to the container.

  docker run -e PRINTMODE=X11 -v /tmp/.X11-unix:/tmp/.X11-unix -v /dev/snd:/dev/snd -lxc-conf='lxc.cgroup.devices.allow = c 116:* rwm' -e DISPLAY=unix$DISPLAY dwarffortress

  * TEXT : This allows running inside the same terminal window you start in, however I find that not all the keys work so navigation is problematic.

  docker run -it -e PRINTMODE=TEXT dwarffortress:latest


TILESET: Defines the tileset used. Currently only Phoebus and Mayday+34.11 are available

* docker run -e TILESET=Phoebus dwarffortress:latest 
* docker run -e TILESET=Mayday+34.11 dwarffortress:latest 


DFHACK: Uses Dfhack rather than the vanilla df

docker run -e DFHACK=True dwarffortress:latest

### Saved Games ###

If you do not specify a way to save the game, quitting DF will lose your game.

The easiest way to keep your saved games between container restarts is to use dockers -v option to map a directory on your host to the save directory inside the container. The following example will mean any saves you make in the game will end up in the directory /tmp/save:

    docker run -i -t -p 1022:22 -v /tmp/save/:/df_linux/data/save/ dwarffortress


Remember to make the directory readable and ensure it has plenty of disk space, since there is a known issue in Dwarf Fortress that it will pretend to save successfully even if it has not.

It is also possible to use Data Volume Containers, see the docker website for more details: http://docs.docker.io/en/latest/use/working_with_volumes/#creating-and-mounting-a-data-volume-container


### Adding Tile sets ###

To add more tileset you will have to create a Data Volume Container

 * Create a directory that contains all the tilesets you want to use

 * Creating the container:

   docker create -v <Tileset directory>:/tilesets --name=df_tiles tianon/true /bin/true

 * Using the tiles:

   docker run -e TILESET=<Tileset directory> --volumes-from=df_tiles dwarffortress:latest  

### Using a custom init.txt ###

   docker run  -v <path to init.txt>:/df_linux/data/init/init.txt dwarffortress:40.24

Known Issues
------------
* There seems to be an issue with parts of the screen are the wrong colour or goes blurry when using xpra. Need to investigate whether some settings could fix this. The workaround is to change the encoding to "RAW RGB + zlib".
* No sound when using xpra.

Todo
----

* Improve XPRA support to turn off password authentication
* Create more tags/versions (Originally this was for 34.11, so I should add that one at least)
* Finish the setup_tileset.sh script to accept a tileset name and pull that down, so it can be used to create an data image with the tilesets people want
* Find a way to share out saved games.


Credits
-------

* Obviously Toady One at http://www.bay12games.com for Dwarf Fortress.
* Daniel Mizyrycki for the slideshow (http://www.slideshare.net/dotCloud/dockerizing-your-appli) that helped get started.
* Henrik Mühe for the first fuse install hack I tried (https://gist.github.com/henrik-muehe/6155333)
* Roberto G. Hashioka for the current fuse install hack that seems to work better with xpra (https://github.com/rogaha/docker-desktop)
* All the guys that maintain the Dwarf Fortress wiki (http://dwarffortresswiki.org/index.php/DF2012:Installation)
* Nevik Rehnel for gitwatch (https://github.com/nevik/gitwatch)
