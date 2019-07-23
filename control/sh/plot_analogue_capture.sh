#!/bin/bash

outfile="analogue_capture.dat"
script="analogue_capture.sh"
script_status=`ps -C $script > /dev/null; echo $?`

# Start png viewer
gthumb -s &

if [ "$script_status" -eq 1 ]; then
  echo -e "Script '$script' is not running!";
  #exit
fi  

echo -e "Plotting script up and running..."

if [ ! -f $outfile ]; then
  echo -e "File '$outfile' does not exist. Exiting."
  exit
fi

gnuplot -persist<<EOF
load "plot.gp"
EOF
