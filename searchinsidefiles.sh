#!/bin/bash
# search inside text files : v3.0 by Saugata 

usage="
Usage: ./searchinsidefiles.sh [-s word to search] [-t file types to search ...] [-h help]
  
Example: ./searchinsidefiles.sh -s DataFrame -t py
Example: ./searchinsidefiles.sh DataFrame py
"
# ---- SET INITIAL VALUES ----
word=""
file_ext="*"

# ---- GETOPTS ----
# no args. print usage and exit
if [[ $# -eq 0 ]]; then
	echo "$usage"
	exit
fi

# if $1 doesn't start with a switch - then user have used 
# the other way of passing args
if [[ "$1" =~ ^[a-zA-Z0-9]+$ ]]; then  
 # ---- SET INITIAL VALUES ----
	word=$1
	file_ext=$2

	# Second argument might be empty which means $file_ext 
	# will be empty at this point too. Set the values of $num and $special 
	#to the default values in case they are empty
	[ "$2" == "" ] && file_ext="*"

else
 # user have used a switch to pass args. Use getopts
 while getopts s:t:h option
 do
  case "${option}"  in
				      s) word=${OPTARG};;
				      t) file_ext=${OPTARG};;
				      h) echo "$usage" 
				      exit ;;
  esac
 done
fi

# -----------------------

echo
echo "Pattern to search for: " $word
echo "Files being searched: " $file_ext
echo

IFS=$'\n'
filenames=`find . -type f -name "*.$file_ext"` 
for i in $filenames
do
istextfile=`file $i | grep "text"`

if [ "$istextfile" ]; then
	text=`cat $i | grep "$word"`
	if [ "$text" ] ; 	then 
	 echo "-------------------------------------" 
	 echo "FILE : " $i 
	 echo
	 grep $word $i -A2 -B2 --color=auto
	 echo
	fi
fi
done

