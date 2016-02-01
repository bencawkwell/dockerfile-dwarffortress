#!/bin/bash

if [ -e "/usr/bin/supervisord" ] ; then
    service supervisor start
    /wait-for-daemons.sh -a
fi
chown -R df:df /df_linux/data/save
if [ -z "$DISPLAY"] ; then
    export DISPLAY=:100
fi
sudo -u df -H DISPLAY=$DISPLAY dwarffortress "$@"
