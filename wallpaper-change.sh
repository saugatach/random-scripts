#!/bin/bash
# Wallpaper randomizer script
# this script keeps rotating the wallpapers at a fixed interval and does it randomly. 
# It goes into background. You can either kill it manually or use the "kill" switch as a command line parameter.


# location of wallpapers / pics.
wallpaperdir="$HOME/Pictures" 

# wallpaper change interval time in seconds. Cannot changed during runtime. 
changetime=1800 



# do not have to edit beyond this line
#------------------------------------------

helpme(){
# help menu
   echo
   echo "Usage: " `basename $0` "[option] <directory_name>"
   echo "[option] = kill    : Kill all running instances of the script "
   echo "         = change  : Change the wallpaper"
   echo "         = dir     : Change the wallpaper directory to <directory_name>"
   echo "         = -h      : Display this help."
   exit
}

if [ "$1" != "" ] 
then 
# if no command line parameter supplied then move on.

 if [ "$1" == "kill" ] 
 then
# if command line parameter is "kill" then kill all running instances of this script.

  nnn=`ps aux | grep $0 | tr -s " " | cut -d" " -f2 `
   echo -e $$ "\n====" # prints PID of this instance of script. make sure not to kill itself.
  
  for ii in `echo $nnn`
  do 
   if [ "$ii" -ne "$$" ] 
   then 
     echo "Killing PID:" $ii
     kill -9 $ii 
   fi
  done
  
  exit
# modify wallpaper rotation time

 elif [ "$1" == "change" ] 
 then
# if command line parameter is "change" then change the wallpaper.
  cd $wallpaperdir
  pic=`ls | sort -R | tail -n1 `

  picfullname="$PWD/$pic"
  echo "Changing wallpaper to :" $picfullname
  echo
  gconftool-2 -t str --set /desktop/gnome/background/picture_filename "$picfullname"
  exit
  
 elif [ "$1" == "dir" ] 
 then
# if CLI parameter is "dir" then change the wallpaper directory.
  if [ "$2" == "" ] 
  then
    echo "No directory name given."
    helpme
    echo
    exit
  elif [ ! -d "$2"  ] 
  then
    echo "Directory does not exist."
    echo
    exit
  else  
    wallpaperdir="$2" # set wallpaper directory temporarily
    # kill running instances and spawn a new one with modified wallpaper directory

  nnn=`ps aux | grep $0 | tr -s " " | cut -d" " -f2 `
  
  for ii in `echo $nnn`
  do 
   if [ "$ii" -ne "$$" ] 
   then 
     kill -9 $ii 
   fi
  done
  
  fi
  
 elif [  "$1" == "-h" ] 
 then
# -h : help menu
   helpme
 else 
   helpme
  fi
fi

cd $wallpaperdir
hrs=$(($changetime/3600))
mins=$(($changetime/60))

echo
echo "Wallpaper directory : " $wallpaperdir
echo "Wallpaper change interval time:" $hrs "h" $mins "m"
echo

{
while [ 1 ]
do

pic=`ls *.jpg *.png *.bmp *.gif| sort -R | tail -n1 `

picfullname="$PWD/$pic"
gconftool-2 -t str --set /desktop/gnome/background/picture_filename "$picfullname"
echo "Changing wallpaper to :" $picfullname
echo

sleep $changetime

done
}&

