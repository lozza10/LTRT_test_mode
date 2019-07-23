#!/bin/bash

data_dir=$1
outimg="$data_dir/$2.png"
cnt=0

if [ $# != 2 ]; then
  echo
  echo -e " > concat.sh <\n"
  echo -e " Usage: concat.sh <path to data directory> <output image name>\n"
  exit
fi
 
  cd $data_dir

  if [ -f *concat.dat ]; then
    rm *concat.dat
  fi

  # Comment out for manually edited datlist
  ls -rt *.dat > datlist

  for line in $(<datlist)
    do
      echo $line
      if [ $cnt -eq 0 ]; then
        IFS='_' read -a array <<< "$data_dir/$line"
        datestr=${array[2]}
        lststr=`echo "${array[3]}" | awk -F- '{print$1}'`
        dec=`echo "${array[3]}" | awk -F. '{print$1}'`
        lst=`echo $lststr | sed 's/\(..\)\(..\)\(..\)/\1:\2:\3/'`
        date=`echo $datestr | sed 's/\(..\)\(..\)\(....\)/\1.\2.\3/'` 
        outfile="ac_${datestr}_${dec}_concat.dat"
        awk '{print}' $data_dir/$line > $outfile
      else 
        lastline=`awk 'END{print}' $outfile`
        d=$(echo $lastline | awk -F- '{print$1}')
        if [ $d -ne 1 ]; then
          awk '!/^#/ {sub(/1/,'$d');print}' $data_dir/$line >> $outfile
        else
          awk '!/^#/ {print}' $data_dir/$line >> $outfile
        fi 
      fi
      cnt=$((cnt+1));
    done

# plot
gnuplot <<EOF
set term png size 1250, 400 font '/usr/share/fonts/liberation/LiberationSans-Regular.ttf' 10
set out "$outimg"
set title "$outfile" tc ls 1
set style line 1 lt 1 lw 0.5 linecolor rgb "white"
set style line 2 lt 1 lw 0.5 linecolor rgb "green"
set border ls 1
unset key
set xlabel "LST (hh:mm:ss) from $lst on $date" tc ls 1
set ylabel "Amplitude (arbitary)" tc ls 1
set obj 1 rectangle from screen 0,0 to screen 1,1 fillcolor rgbcolor "black" behind
set xdata time
set timefmt "%d-%H:%M:%S"
set format x "%H:%M"
plot "$outfile" u 1:2 w lines ls 2
EOF

  # check integrity
  if [ -f $outfile ] && [ -f $outimg ] && [ `cat $outfile | wc -l` -gt 0 ] ; then
    echo
    echo -e "Complete.\n"
  else
    echo
    echo -e "Write failed!\n"
  fi

cd -
