#!/bin/bash
#
# decalc.sh
# Convert source declination to nclicks of LTRT declination positioner
#
# LT 28/02/13
#

dec=$1
nlimit="+12.8"    # ddmm
slimit="-38.0"    # ddmm
zenith="-33:36"    # ddmm
equatorpos=32
ndeg=24 	   # arcmins/click


function usage() {
  echo
  echo " > decalc.sh <"
  echo -e " Convert source declination to nclicks of LTRT declination positioner\n"
  echo -e " Usage: decalc.sh <source declination (+/- fractional degrees)>\n"
  echo "           Telescope: LTRT"
  echo " North limit (dd:mm): +12:48"
  echo " South limit (dd:mm): -38:00"
  echo "      Zenith (dd:mm): $zenith"
  echo
}

function format() {
  echo $dec | grep - > /dev/null
  excode=`echo $?`

  if [ $excode -eq 0 ]; then
    sign="-"
  else
    sign="+"
  fi

  dec_strip=$(echo "$dec" | awk -F$sign '{print$2}')
  degrees=$(echo "$dec_strip" | awk -F. '{print$1}')
  arcmins_total=$(echo "$dec_strip*60" | bc)
  arcmins_fract=$(echo "$dec_strip" | awk -F. '{print$2}')
  arcmins=$(echo "0.$arcmins_fract*60" | bc | awk -F. '{print$1}')

  if [ $degrees -ge 0 ] && [ $degrees -lt 10 ]; then
   if [ $excode -eq 0 ]; then
     degrees="-0$degrees"
   else
     degrees="+0$degrees"
   fi
  else
   if [ $excode -eq 0 ]; then
     degrees="-$degrees"
   else
     degrees="+$degrees"
   fi
  fi

  if [ $arcmins -ge 0 ] && [ $arcmins -lt 10 ]; then
   arcmins=0$arcmins
  fi
}

function dec2clicks() {
  if [ $excode -eq 0 ]; then
    nclicks=$(echo "$equatorpos+($arcmins_total/$ndeg)" | bc | awk -F. '{print$1}')
  else
    nclicks=$(echo "$equatorpos-($arcmins_total/$ndeg)" | bc | awk -F. '{print$1}')
  fi
  echo " ***********************************************"
  echo "   Declination entered (fractional dd): $dec"
  echo "                   Declination (dd:mm): $degrees:$arcmins"
  echo "                      Slew to position: $nclicks"
  echo " ***********************************************"
  echo
}

if [ $# -lt 1 ]; then
  usage
  exit 1
fi

# get sign
echo $dec | grep - > /dev/null
excode=`echo $?`

if [ $excode -eq 0 ]; then
  sign="-"
  decstrip=$dec
else
  sign="+"
  decstrip=$(echo "$dec" | awk -F$sign '{print$2}')
fi

if [ `echo "$decstrip<=12.8" | bc` -ne 1 ] || [ `echo "$dec>=-38" | bc` -ne 1 ]; then
 usage
 echo -e "ERROR: Declination $dec degrees is out of range.\n"
 exit 1
fi

usage
format
dec2clicks
