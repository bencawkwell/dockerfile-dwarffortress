#!/bin/bash

if [ -e "/usr/bin/supervisord" ] ; then
    service supervisor start
    /wait-for-daemons.sh -a
fi
sudo -u df -H DISPLAY=:1 dwarffortress "$@"
