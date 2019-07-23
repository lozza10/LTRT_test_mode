set term png
set out "out.png"
set title "LTRT - test mode"
set xlabel "Time since script started (s)"
set ylabel "Amplitude (arbitary)"
#set yrange [0:40]
set yrange [12:18]
plot "out.dat" u ($1/1000):2 w lines lc 3
pause 3
reread
