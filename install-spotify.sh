#!/bin/bash
 
# Script to install Spotify on Debian/Ubuntu
# Created by clamsawd (clamsawd@openmailbox.org)
# Licensed by GPL v.2
# Last update: 19-09-2015
# --------------------------------------
VERSION=0.1
SPOTIFY_VERSION=`spotify --version | cut -d "," -f 1`
URL_SPOTIFY="http://repository.spotify.com/pool/non-free/s/spotify-client"

#Check if user is root
user=$(whoami)
 if [ "$user" == "root" ] ; then
     echo "OK" > /dev/null
 else
     echo "You must be root!"
     exit 0
 fi

#Check name of kernel
KERNEL=$(uname -s)
 if   [ $KERNEL == "Linux" ]; then
       KERNEL=linux
 else
       echo "OS not supported ($KERNEL)"
       exit 0
 fi

#Check if your system is Debian or Ubuntu
CHECK_SYSTEM=`uname -a`
CHECK_DEBIAN=`uname -a | grep "Debian"`
CHECK_UBUNTU=`uname -a | grep "Ubuntu"`

clear
echo ""
echo "Spotify installer ($VERSION)"
echo ""

if [ "$CHECK_SYSTEM" == "$CHECK_DEBIAN" ]; then
      echo "$CHECK_DEBIAN"
elif [ "$CHECK_SYSTEM" == "$CHECK_UBUNTU" ]; then
      echo "$CHECK_UBUNTU"
else
      echo "Your system is not Debian or Ubuntu!"
      echo -n "(Default: n) Continue anyway? (y/n): " ; read CONTINUE
       if [ "$CONTINUE" == "y" ]; then
          echo "$CONTINUE"
       else
          exit
       fi
fi

#Check 'curl' in your system.
  curl --help > /dev/null
  if [ "$?" -eq 0 ] ; then
     echo "curl OK"
     clear
  else
     apt-get update
     apt-get install curl -y
  fi
#Check 'wget' in your system
  wget --help > /dev/null
  if [ "$?" -eq 0 ] ; then
     echo "wget OK"
     clear
  else
     apt-get update
     apt-get install wget -y
  fi
#Check 'gdebi' in your system
  gdebi --help > /dev/null
  if [ "$?" -eq 0 ] ; then
     echo "gdebi OK"
     clear
  else
     apt-get update
     apt-get install gdebi -y
  fi

#Get the current versions of Spotify
SPOTIFY_32=`curl $URL_SPOTIFY/ | cut -d ">" -f 2 | cut -d "<" -f 1 | grep i386`
SPOTIFY_64=`curl $URL_SPOTIFY/ | cut -d ">" -f 2 | cut -d "<" -f 1 | grep amd64`
 if [ $? -eq 0 ] ; then
   echo "Connection OK" > /dev/null
 else
  clear
  echo ""
  echo "Error: Failed to obtain the required information from the server!"
  echo "Connection Fail!"
  echo ""
  exit
 fi

#Menu
MENU_VARIABLE=1
while [ $MENU_VARIABLE -le 2 ] ; do
clear
echo ""
echo "Spotify installer ($VERSION)"
echo ""
echo "Installed: $SPOTIFY_VERSION"
echo ""
echo "Available packages:"
echo ""
echo "(1) $SPOTIFY_32 (32-bits)"
echo "(2) $SPOTIFY_64 (64-bits)"
echo ""
echo "(q) - quit"
echo ""
echo -n "(Default: autodetect) Choose an option; " ; read PACKAGE
   if [ "${PACKAGE:-NO_VALUE}" == "NO_VALUE" ] ; then
       
      # Detect the arch of the system if variable
      # 'AR' is empty.
      archs=`uname -m`
      case "$archs" in
       i?86)
         cd /tmp/
         wget -c $URL_SPOTIFY/$SPOTIFY_32
         gdebi $SPOTIFY_32
         rm -rf $SPOTIFY_32
         echo "Exiting..."
         MENU_VARIABLE=3
       ;;
       x86_64)
         cd /tmp/
         wget -c $URL_SPOTIFY/$SPOTIFY_64
         gdebi $SPOTIFY_64
         rm -rf $SPOTIFY_64
         echo "Exiting..."
         MENU_VARIABLE=3
      ;;
      *)
        echo "Unsupported Arquitecture ($archs)"
        exit 0
      esac
      
   elif [ "$PACKAGE" == "1" -o "$PACKAGE" == "32" ] ; then
    cd /tmp/
    wget -c $URL_SPOTIFY/$SPOTIFY_32
    gdebi $SPOTIFY_32
    rm -rf $SPOTIFY_32
    echo "Exiting..."
    MENU_VARIABLE=3
   
   elif [ "$PACKAGE" == "2" -o "$PACKAGE" == "64" ] ; then
    cd /tmp/
    wget -c $URL_SPOTIFY/$SPOTIFY_64
    gdebi $SPOTIFY_64
    rm -rf $SPOTIFY_64
    echo "Exiting..."
    MENU_VARIABLE=3
   
   elif [ "$PACKAGE" == "q" -o "$PACKAGE" == "quit" ] ; then
    echo "Exiting..."
    MENU_VARIABLE=3
   
   else
    clear  
    echo ""
    echo "Invalid option, please, choose any available arch"
    echo ""
    echo "Press 'ENTER' to return"
    read NOOPTION
   fi
done


