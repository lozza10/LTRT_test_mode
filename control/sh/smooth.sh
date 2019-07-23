#!/bin/bash

infile="analogue_capture.dat"
outfile="out.dat"
nsmooth=$1

if [ $# != 1 ]; then
  echo "Usage: smooth.sh <no. lines to smooth>"
  exit
fi

while [ 1 -lt 2 ]
  do
    echo -e "`date -u` :: Smoothing every $nsmooth lines..."
    awk 'NF == 2' $infile | awk '{sum+=$2} (NR%'$nsmooth')==0{print$1,sum/'$nsmooth'; sum=0;}' > out.tmp
    mv out.tmp $outfile
    sleep 10
  done
