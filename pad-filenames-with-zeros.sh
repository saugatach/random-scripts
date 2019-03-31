#!/bin/bash
# pad filenames with zeros so that it sorts correctly.
locofword=$(ls| sed "s/[^0-9]//g" | sort -n | tail -n 1 | wc -m)

for ffl in `ls`
do
len=`echo $ffl | cut -d"." -f1 | wc -m `
echo $ffl $len
#let len=$(echo "$file" | cut -d"." -f1 )
let aa=$locofword-$len
perl -e 'print "-" x $aa,"\n"'
done


for i in *.avi
do
j=`echo $i | sed 's/find/replace/g'`
mv "$i" "$j"
done

if [ -f .tmp2 ];
then
   rm .tmp2
fi



