#!/bin/bash

usage()
{
cat << EOF
usage: $0 options

This script launches Dwarf Fortress but allows input paramters to set
options normally needed to be set in the init.txt config file.

OPTIONS:
   -h      Show this message
   -p      Print mode, can be ‘2D′ or ‘TEXT′
   -s      Skip the intro
   -x      Execute arbitery command, used for debugging. For example passing
           /bin/bash will give you a shell. To pass parameters simply wrap 
           everything in single quotes (eg -x 'ls -al')
EOF
}

INTRO="YES"
PRINTMODE="2D"
while getopts “:hp:sx:” OPTION
do
     case $OPTION in
         h)
             usage
             exit 1
             ;;
         p)
             PRINTMODE=$OPTARG
             ;;
         s)
             INTRO="NO"
             ;;
         x)
             $OPTARG
             exit
             ;;
         ?)
             usage
             exit
             ;;
     esac
done

if [[ -z $PRINTMODE ]]
then
     usage
     exit 1
fi
sed -i -r "s/^\[INTRO:.+\]/[INTRO:$INTRO]/" df_linux/data/init/init.txt
sed -i -r "s/^\[PRINT_MODE:.+\]/[PRINT_MODE:$PRINTMODE]/" df_linux/data/init/init.txt
df_linux/dfhack
