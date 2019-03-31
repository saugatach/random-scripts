#!/bin/bash
# reduces size of mp3 for use in mobile phones. needs lame (gstreamer-ugly,gstreamer-ugly-multiverse) and id3cp (id3lib) to be installed. get it from the repos.
# the script converts all spaces into -. without it the script cannot work.
rename 's/\ /-/g' *.mp3
for i in `ls *.mp3`
do
pp1=$i
pp2="${pp1%%.mp3}"
#echo $pp2
lame -V6 -h -b 40 -mm --vbr-new $i  $pp2.small.mp3
id3cp $i  $pp2.small.mp3
rename 's/^/s-/' $pp2.small.mp3
rename 's/\.small\.mp3/\.mp3/' *.small.mp3
done

