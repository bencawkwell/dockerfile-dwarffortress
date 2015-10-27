#!/bin/bash

if [ -e "/usr/bin/supervisord" ] ; then
    /usr/bin/supervisord
    /wait-for-daemons.sh -a
fi

DISPLAY=:1 dwarffortress