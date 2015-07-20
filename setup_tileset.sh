#!/bin/sh


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

