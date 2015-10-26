#!/bin/bash

if [ -e "/usr/bin/supervisord" ] ; then
    /usr/bin/supervisord
    /wait-for-daemons.sh -a
fi

if [ -e "/df_linux/dfhack" ] ; then
    DF_PATH=/df_linux/dfhack
else
    DF_PATH=/df_linux/df
fi

DISPLAY=:1 $DF_PATH