#!/bin/bash

if [ -e "/usr/bin/supervisord" ] ; then
    service supervisor start
    /wait-for-daemons.sh -a
fi
chown -R df:df /df_linux/data/save
sudo -u df -H DISPLAY=:1 dwarffortress "$@"
