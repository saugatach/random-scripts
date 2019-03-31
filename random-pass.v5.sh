#!/bin/bash
# generate random passwords using urandom CSPRNG.  
# randompass.sh v5.2
# Usage: ./randompass.sh [-l=password length DEFAULT=16] [-n=number of passwords to generate DEFAULT=4] [-s=special characters DEFAULT=1. Set to 0 to disable selecting _!%] [-h=help]

# ---- SET INITIAL VALUES ----
length=16
num=4
special=1
usage="
Usage: ./randompass.sh [options ...]
  -l	password length. DEFAULT=16
  -n	number of passwords to generate. DEFAULT=4
  -s	special characters. DEFAULT=1. Set to 0 to disable selecting _!%
  -h	help
  
Example 1: ./randompass.sh -l 8 -n 2 -s 0
 	
OR

./randompass.sh [password length] [number of passwords to generate] [include special characters]	

Example 2: ./randompass.sh 8 2 0 		"

# If user uses "numbers only" input (shorthand) then assign the respective values. This assumes the user knows the order in which to input the values. This is verified if the first argument is a number.
#echo $1
#echo $2
#echo $3 
#echo

if [[ "$1" =~ ^[0-9]+$ ]]; then  
	# ---- SET INITIAL VALUES ----
	length=$1
	num=$2
	special=$3

	# Second and third argument might be empty which means $num and $special will be empty at this point too. Set the values of $num and $special to the default values in case they are empty
	[ "$2" == "" ] && num=4
	[ "$3" == "" ] && special=1
else
	# If user uses arguments then use getopts.
	while getopts l:n:s:h option
	do
		case "${option}"
		in
		        l) length=${OPTARG};;
		        n) num=${OPTARG};;
		        s) special=${OPTARG};;
		        h) echo "$usage" ;;
		esac
	done
fi

#echo $length
#echo $num
#echo $special

echo
# ---- CHECK ARG VALIDITY ----

# check if the first argument is an integer. If it is not then throw error. =~ matches REGEXP ^[0-9]+$ which is one or more occurences of the numbers 0-9
if [[ !("$length" =~ ^[0-9]+$ )]]; then
	echo "Enter numbers only for the password length"
	echo "$usage"
	exit
fi

# check if the second argument is an integer. If it is not then throw error. =~ matches REGEXP ^[0-9]+$ which is one or more occurences of the numbers 0-9
if [[ !("$num" =~ ^[0-9]+$) ]]; then
	echo "Enter numbers only for the number of passwords to generate"
	echo "$usage"
	exit
fi

# check if the third argument is an integer. If it is not then throw error. =~ matches REGEXP ^[0-9]+$ which is one or more occurences of the numbers 0-9
if [[ !("$special" =~ ^[0-1]+$) ]]; then
	echo "Enter only 0 or 1 for the third argument."
	echo "$usage"
	exit
fi


# ---- GENERATE THE PASSWORDS ----
if [[ $special == "1" ]]; then # if special chars needed: DEFAULT
	i="0"
#	echo "first loop for 1"
	while [ $i -lt $num ] 
	# Keep looping till next password, which satisfies the required criteria, is successfully generated. May require many more passess for stricter requirements, usually smaller length passwords.
	do 
	pass=`tr -dc "A-Za-z0-9_!%" < /dev/urandom | head -c ${length} | xargs`

	if [ `echo $pass | grep "%" | grep "[0-9]" ` ]; then
	  echo $pass
	  i=$[$i+1]
	fi
	done
else  # if special chars are NOT needed
	i="0"
#	echo "second loop for 0"
	while [ $i -lt $num ]
	do 
	pass=`tr -dc "A-Za-z0-9" < /dev/urandom | head -c ${length} | xargs`

	if [ `echo $pass | grep "[0-9]" ` ]; then
	  echo $pass
	  i=$[$i+1]
	fi
	done
fi



 
