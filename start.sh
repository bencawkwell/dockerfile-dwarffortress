#!/bin/bash


/usr/bin/supervisord
set -x

chown xpra:xpra /home/xpra/.ssh
chown -R xpra:xpra /home/xpra/.ssh
chgrp -R xpra:xpra /home/xpra/.ssh
chmod 700 /home/xpra/.ssh
if [[ -e /home/xpra/.ssh/authorized_keys ]]; then
   chmod 600 /home/xpra/.ssh/authorized_keys
fi

echo 'Available Tilesetsi (use -e TILESET=<name>):'
ls /tilesets

tileswitch="-t /tilesets/$TILESET"
if [[ "$TILESET" == "" || ! -d "/tilesets/$TILESET" ]]; then
	 echo "$TILESET does note exist";
   tileswitch="";
fi
df="/df_linux/df"
if [[ "$DFHACK" != "" ]]; then
	 df="/df_linux/dfhack"
fi

echo "Requested PRINTMODE: $PRINTMODE"
# First if print mode is text we can just launch
if [[ $PRINTMODE == "TEXT" ]]; then
    /launch_df "$@"
    exit
fi

# Check for the presence of DISPLAY and if the user wants just launch
if [[ $PRINTMODE == "X11" ]]; then
    if [ "$DISPLAY" != "" ] ; then
        echo "found DISPLAY $DISPLAY"
        normed="a$DISPLAY"
        parts=(${normed//:/ })
        dnum=${parts[1]}
        echo "/tmp/.X11-unix/X$dnum"
        if [ -e "/tmp/.X11-unix/X$dnum" ] ; then
            echo    # (optional) move to a new line
            if [[ $REPLY =~ ^[Yy]$ ]]
            then
                /launch_df "$tileswitch $df"
                exit
            fi
				else
					  echo "/tmp/.X11-unix/X$dnum is not accessible please add '-v /tmp/.X11-unix:/tmp/.X11-unix'"
        fi
		else
			  echo "To use PRINTMODE='X11', specify DISPLAY"
    fi
fi

# At this point we assume xpra is required so we launch in that
/wait-for-daemons.sh xpra sshd
echo 'use the following command to connect: xpra attach --ssh=\"ssh -p PORT\" ssh:xpra@HOST:100'


# echo "su -l xpra -c 'DISPLAY=:100 /launch_df $tileswitch \"$0\" \"$@\"\ -- \"$@\""
#su -l xpra -c 'DISPLAY=:100 /launch_df $tileswitch "$0" "$@"' -- "$@"
echo "su -lc 'DISPLAY=:100 /launch_df $tileswitch $df' xpra -- \"$@\""
su -lc "DISPLAY=:100 /launch_df $tileswitch $df" xpra
