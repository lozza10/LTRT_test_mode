#!/bin/bash

tty="ttyS0"
serial_port=/dev/$tty
port_status=`dmesg | grep -w $tty > /dev/null; echo $?`
outfile="analogue_capture.dat"

if [ -f $outfile ]; then
  rm $outfile
fi

if [ "$port_status" -eq 1 ]; then
 echo -e "Serial port $serial_port does not exist!"
 echo -e "Please check that Arduino is connected and running.";
 exit
fi

stty -F $serial_port raw
stty -F $serial_port -echo -echoe -echok
#stty -F $serial_port 9600
stty -F $serial_port 115200

echo -e "Analogue capture script up and running..."
cat $serial_port >> $outfile
