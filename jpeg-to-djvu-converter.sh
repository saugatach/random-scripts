#!/bin/bash
#
# any2djvu-bw
#

if [ -z `which anytopnm` -o -z `which ppmtopgm` -o -z `which pgmtopbm` -o -z `which cjb2` ]; then
  usage
  echo "Error: anytopnm, ppmtopgm, pgmtopbm and cjb2 are needed"
  echo
  exit 1
fi

shopt -s extglob

DEFMASK="*.jpg"
DPI=300
# uncomment the following line to compile a bundled DjVu document
#OUTFILE="#0-bw.djvu"

function usage() {
  echo
  echo "usage:"
  echo
  echo "$0 [\"REGEXP\"]"
  echo "    converts single pages with the default mask $DEFMASK (or REGEXP if provided)"
  echo "    in the current directory to single-page black and white djvu documents"
# uncomment the following line to compile a bundled DjVu document
# echo "    and bundles them as a djvu file $OUTFILE"
  echo
}

if [ -n "$1" ]; then
  MASK=$1
else
  MASK=$DEFMASK
fi

for i in $MASK; do
  if [ ! -e $i ]; then
    usage
    echo "Error: current directory must contain files with the mask $MASK"
    echo
    exit 1
  fi
  if [ ! -e $i.djvu ]; then
    echo "$i"
    anytopnm $i | ppmtopgm | pgmtopbm -value 0.499 > $i.pbm
# in netpbm >= 10.23 the above line can be replaced with the following:
#   anytopnm $i | ppmtopgm | pamditherbw -value 0.499 > $.pbm
    cjb2 -dpi $DPI $i.pbm $i.djvu
    rm -f $i.pbm
  fi
done

# uncomment the following line to compile a bundled DjVu document
djvm -c $OUTFILE $MASK.djvu


