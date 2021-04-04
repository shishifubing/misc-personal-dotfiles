#!/bin/sh

temp_file=/tmp/kde_status
temp_file_traffic="${temp_file}_traffic"
echo "start" > $temp_file
echo "0.00kB/s|0.00kB/s" > $temp_file_traffic

while true; do

output=`sar -n DEV 1 1 | awk 'FNR == 21 {print $5"kB/s|"$6"kB/s"}'`
awk -i inplace -v output="$output" '{ print output; }' $temp_file_traffic

done &

while true; do

date=`date +"%A %B %T:%3N %d.%m.%Y"`

memory=`free -h | awk 'FNR == 2 { print $3 "/" $2; }'` 

celsius="°C"
cpu_temp=`cat /sys/class/thermal/thermal_zone0/temp | cut -c1-2`$celsius 

cpu_usage=`vmstat | awk 'FNR == 3 { print 100 - $15 "%"; }'` 

traffic=`cat $temp_file_traffic`

output="$date $memory $cpu_temp $cpu_usage $traffic"

awk -i inplace -v output="$output" '{ print output; }' $temp_file

done

