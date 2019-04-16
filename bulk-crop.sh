#!/bin/bash
# bulk-crop.sh: This script bulk crops a bunch of files to the same size and aspect ratio. This is very helpful when the scanner produced different sized images from the same sized pages of a notebook. This also helps when the user crops the images themselves and ends up producing different sized images. 

USAGE="Usage: [-h help] [-r height in pixels [default=0]] filea1.jpg fileb2.jpg files*.jpg ... 
When a height is not specified or -r 0 is used, the minimum height from all the files will be used."

# if run with no argument show error
if [ "$#" == "0" ]; then
	echo "$USAGE"	
	exit 1
fi

# parse for arguments. set counter i=1 which counts the no. of files passed in the arguments
i=1

# $# = no. of arguments passed. the "sift" function keeps decreasing this value. Stop do loop when all arguments are parsed.
while (( "$#" )); do

key="$1"


if [[ $1 == "-h" ]]; then
	echo "$USAGE"
	exit
fi

if [[ $1 == "-r" ]]; then
#	echo "$2 will be used as height for all croped images. If this is more than the height of the smallest image then that height will be used instead. If unsure leave it to 0 for automatic height selection."
	fres=$2
	shift
	shift
fi


  
if  [ "$#" == "0" ]; then
	echo "$USAGE"	
	exit 1
fi


	
	res=`file $1  | sed  's/precision/|/' | sed 's/frames/|/' | cut -d"|" -f2 | cut -d "," -f2`
	height=`echo $res | cut -d"x" -f1`
	width=`echo $res | cut -d"x" -f2`
	
#	echo "height=" $height "width=" $width $i
	
	h1[$i]=$height
	w1[$i]=$width
	filename[$i]=$1
#	echo ${filename[$i]}
		
	let "i+=1"

	  
  shift

done

#find the minimum height (from the smallest pic)
min=1

for j in `seq 1 $(($i-1))`
do
	if [[ ${h1[$j]} < ${h1[$min]} ]]; then
		min=$j
	fi
	
#	echo ${filename[$j]}
	
done

#echo $min

if [ -z $fres  ]; then
	fres=${h1[$min]}
fi


if [[ $fres == 0 ]]; then
	fres=${h1[$min]}
fi

if [[ $fres < $min ]]; then
	echo "WARNING: $fres is less than the minimum height $min of the smallest image."
	echo "$fres will be used as height for all croped images."
fi

echo $min

# this min is the index no. of the file with minimum height ... now crop accordingly


