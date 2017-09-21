#!/bin/bash
#--------------------------------------------------------------
#           ___
#         /  __\__  ___  ___ _   _ _ __ ___
#        / _\/ __|/ _ \/ __| | | | '__/ _ \
#       / /  \__ \  __/ (__| |_| | | |  __/
#       \/   |___/\___|\___|\__,_|_|  \___|
#
#    Script to install F-secure into linux machines
#  :: Coded by n3k00n3 | userX this code uses GPL3 ::
#              3mm4[at]riseup[dot]net
#	          user_x[at]riseup[dot]net
#
#---------------------------------------------------------------

# We need to be root!
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi


TARGET=$(echo "https://download.f-secure.com/corpro/ls/current/fsls-11.10.68-rtm.tar.gz" | awk -F "/\n" '{print $1}' | awk -F "/" '{print $7}')

DOWNLOADED=$(ls -l | grep $TARGET | awk -F " " '{print $9}')

# Downloding F-secure package for linux!
# OBS: Change the link below if this version is not the latest!
if [ -z "$DOWNLOADED" ]; then 
	wget https://download.f-secure.com/corpro/ls/current/$TARGET
fi

# Unpacking our linux package!
tar zxvf $TARGET

FOLDER=$(echo $TARGET | awk -F "." '{print $1"."$2"."$3}')
cd $FOLDER

# Changing Permissions for this package!
chmod u+x fsls-11.10.68

# We need to know how the OS
OS=$(cat /etc/issue | awk -F " " '{print $1}' | tr -d " \t\n\r")
ARCH=$(uname -m | awk -F "_" '{print $2}')

# Solving dependencies
case $OS in
  Debian)
    if [ $ARCH == "64" ]
    then 
	    dpkg --add-architecture i386
	    apt-get update
	    apt install linux-headers-amd54
    else
		apt install linux-headers-`uname -r`
    fi	

    apt install  gcc patch make rpm dkms libstdc++6:i386 libpam-modules:i386 zlib1g:i386 build-essential
    ;;

  Ubuntu)
   apt-get install rpm libstdc++6:i386 libpam-modules:i386 libc6-dev:i386 zlib1g:i386;;

    CentOS)

esac

# Run Package
PACKAGE=$(echo $FOLDER | awk -F "-" '{print $1"-"$2}')
./$PACKAGE
