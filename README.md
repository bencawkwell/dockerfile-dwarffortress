dockerfile-dwarffortress
========================

Dwarf Fortress in a container. Tested on Mint 15 and 16.

Usage
-----

Make sure you are in the same directory as the Dockerfile

    cd dockerfile-dwarffortress

Build the image and tag it dwarffortress. The -rm options cleans the cache after the final image has been created.

    docker build -t dwarffortress -rm .

If you want to run in text mode

    docker run -t -i dwarffortress -p TEXT /df_linux/df

In order to run in 2D mode you have two choices. The first is to map stuff from the host to the container

    docker run -t -i -v /tmp/.X11-unix:/tmp/.X11-unix -v /dev/snd:/dev/snd -lxc-conf='lxc.cgroup.devices.allow = c 116:* rwm' -e DISPLAY=unix$DISPLAY dwarffortress /df_linux/df

When prompted to continue without xpra, hit y.

The other option is to connect to the container using xpra. The advantage of this approach is you can connect from a different machine to where the container is running. Since xpra runs over ssh you need to map port 22 from the container to a port on your host.

    docker run -i -t -p 1022:22 dwarffortress /df_linux/df

Both sshd and xpra will be started, and then it will wait for you to hit a key before launching Dwarf Fortress. This is to give you time to connect so that you do not miss the really cool intro. Assuming you used the above command to start the container you can use the following to connect from the same machine. The password is changeme.

     xpra attach --ssh="ssh -p 1022" ssh:xpra@localhost:100

Bear in mind that the default version of xpra included in the Ubuntu repositories is usually really old. I would recommend installing the latest version from http://winswitch.org/downloads/

### DfHack ###

DfHack is included in the container, to use it simply replace the path to df with the path to dfhack

    docker run -t -i -v /tmp/.X11-unix:/tmp/.X11-unix -v /dev/snd:/dev/snd -lxc-conf='lxc.cgroup.devices.allow = c 116:* rwm' -e DISPLAY=unix$DISPLAY dwarffortress /df_linux/dfhack

### Tile sets ###

The Phoebus and Mayday tile sets are also included, you can use one of them by passing the -t option and specifying the name (case sensitive) prefixed with a slash, for example:

    docker run -i -t -p 1022:22 dwarffortress -t /Phoebus /df_linux/df

### Saved Games ###

The easiest way to keep your saved games between container restarts is to use dockers -v option to map a directory on your host to the save directory inside the container. The following example will mean any saves you make in the game will end up in the directory /tmp/save:

    docker run -i -t -p 1022:22 -v /tmp/save/:/df_linux/data/save/ dwarffortress /df_linux/df

Remember to make the directory readable and ensure it has plenty of disk space, since there is a known issue in Dwarf Fortress that it will pretend to save successfully even if it has not.

It is also possible to use Data Volume Containers, see the docker website for more details: http://docs.docker.io/en/latest/use/working_with_volumes/#creating-and-mounting-a-data-volume-container

### Auto backup of Saved Games ###

Since you can only have one saved version of a fortress, and I sometimes make silly mistakes that I do not notice until several days later, I got into the habit of making backups of the data/save directory on a regular basis. To automate this I have found a script by Nevik Rehnel which monitors a directory and on each change automatically makes a commit of it. Using git you can then recover older saves from before you accidentally left a hole into you forts defenses which you only notice after an entire hoard of goblins discover it.

If you want to make use of this feature then simply initiate a git repository in the folder you are storing saves. For example assuming you are using /tmp/save on your host:

    cd /tmp/save
    git init

When the docker container is started it will check if the save directory has the hidden .git directory, and if it does it will start up gitwatch utility to monitor it. Note that I have set the waiting period to 1 minute before gitwatch will commit the changes. This is to give Dwarf Fortress ample time to finish the save before the save gets committed.

### Other options ###

To see all the options available, get help

    docker run -t -i dwarffortress -h

Todo
----

* There seems to be an issue with parts of the screen are the wrong colour or goes blurry when using xpra. Need to investigate whether some settings could fix this. The workaround is to change the encoding to "RAW RGB + zlib".
* Clean up the entry point argument handling to be simpler. Its a bit annoying to have to use /Phoebus instead of just Phoebus and it would be even better if it was not case sensitive.
* Add some more tile sets.
* Document a cool way to keep saved games in Data Volume Containers.
* Ideally remove the start.sh script again to keep the Dockerfile self contained, or break out all the extra feature I keep adding like auto backup and tile sets into plugins so that its easier to customise or add new features.
* Simplify using world gen parameters, for example traverse a directory for world gen parameter files and automatically append them to the data/init/world_gen.txt file. Again this could be written as a plugin.
* Fix sound when using xpra.
* Create a tutorial version, or have it optional to load a tutorial map by passing arguments. I personally found http://dftutorial.wordpress.com really helpful but unfortunately its for the older 0.31.25 version of Dwarf Fortress and I was unable to get the saved game to work in 0.34.11. The second challenge is that the files are hosted on MediaFire which might be tricky to automate in a script/Dockerfile, so I would either need to ask that the files are hosted on dffd.wimbli.com or include the files in the github repo, but then there is a licensing issue.

Credits
-------

* Obviously Toady One at http://www.bay12games.com for Dwarf Fortress.
* Daniel Mizyrycki for the slideshow (http://www.slideshare.net/dotCloud/dockerizing-your-appli) that helped get started.
* Henrik Mühe for the first fuse install hack I tried (https://gist.github.com/henrik-muehe/6155333)
* Roberto G. Hashioka for the current fuse install hack that seems to work better with xpra (https://github.com/rogaha/docker-desktop)
* All the guys that maintain the Dwarf Fortress wiki (http://dwarffortresswiki.org/index.php/DF2012:Installation)
* Nevik Rehnel for gitwatch (https://github.com/nevik/gitwatch)
