#!/bin/bash
# sumcolumn.sh v1.5 by Saugata copyright 07/07/2020
# autosum price column of a csv after filtering for a specific column value

usage="
Usage: ./sumcolumn.sh [filename] [pattern] [-h help]
  
Example: ./sumcolumn.sh hsa.csv PHARMACY
"

# ---- GETOPTS ----
# no args. print usage and exit
if [[ $# -eq 0 ]]; then
 echo "$usage"
 exit
fi

while getopts h option
do
case "${option}"  in
 h) echo "$usage" 
 exit ;;
esac
done

# check if first arg is a file which exists
if [[ -z $1 ]]; then
  echo "File doesn't exist"
  exit
fi
echo "Filename: " $1

# check if file is a text file
txtfile=`file "$1" | grep "text"`

if [[ $txtfile == "" ]]; then
  echo "File not a text file. Choose a text file."
  exit
fi

# check if pattern exists in file
ptn=`grep "$2" "$1"`
if [[ $ptn == "" ]]; then
  echo "Pattern does not exist in file. No sum."
  exit
fi

# identify column containing price (elements have $ symbol)
sumcol="$(head -n 2 "$1" | tail -n 1 | tr "," "\n" | nl \
 | grep "\\$" | sed 's/ //g' | head -c1 )"

if [[ $sumcol == "" ]]; then
  echo "No columns to sum"
  exit
fi

echo "Summing column: " `head -n 1 "$1" | cut -d"," -f$sumcol`

echo "Total: " total="$(grep "$2" "$1" | cut -d"," -f$sumcol \
 | tr -cd '[:digit:].\n' | paste -sd+ | bc)"


