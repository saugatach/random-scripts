#!/bin/bash
# batch replace environment variables
# v 3.2 by Jones Mar 31, 2019
# example: ./replaceenv.sh python python2 .

progname=$0

function usage {
	echo "usage: $progname [option] env1 env2 directory"
	echo "to revert to original switch env1 and env2"
	echo "	env1	variable replaced"
	echo "	env2	replaced to"
	echo "	-n		dry run (files saved as filename.temp)"	
	echo "	-h		print help"
	exit 1
}


if [[ $1 = "-h" || $1 = "--help" ]]; then
	usage
fi

# check if all parameters have been supplied
if [[ $1 = "-n" ]]; then
	if [[ $# -lt 4 ]]; then
		usage
	else
		env1=$2
		env2=$3
		dir=$4
		dryrun=true		
	fi
else
	if [[ $# -lt 3 ]]; then
			usage
	else
		env1=$1
		env2=$2
		dir=$3
		dryrun=false		
	fi
fi

echo "Working directory:" $(readlink --canonicalize $dir)
echo "Replace /usr/bin/env/"$env1 " -> /usr/bin/env/"$env2
echo

IFS=$'\n'
for file in `find $dir -name "*" -type f`
do
	if [ "`cat $file | grep "usr/bin/env" | grep -w $env1 | grep -v $env2 `" ] ; 
	then 
		echo "FILE : " $file 
		#sed 's|bin/env python$|bin/env python2|' $file
#		line1=`grep "usr/bin/env" $file`
#		echo $line1
#		line2=`echo $line1 | sed 's|bin/env python$|bin/env python2|'`
#		echo "... replaced by ..."
#		echo  $line2
		sed "s|bin/env $env1|bin/env $env2|" $file > $file.temp
		if $dryrun ; then
			echo "Saved as " $file.temp
		else
			cp $file $file.bak
			mv $file.temp $file
			echo "File modified. To test use -n option (dry run). Original file saved to $file.bak"
		fi
		echo
	fi

done

