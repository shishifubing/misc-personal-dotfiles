#!/bin/sh

kde_status=/tmp/kde_status
kde_status_traffic=/tmp/kde_status_traffic

mkfifo $kde_status
echo "0kB/s 0kB/s" > $kde_status_traffic

while true; do

output=`sar -n DEV 1 1 | awk 'FNR == 6 { printf("%.0fkB/s %.0fkB/s", $5, $6); }'`
awk -i inplace -v output="$output" '{ print output; }' $kde_status_traffic

done &

while true; do

date=`date +"[%A] [%B] [%d-%m-%Y] [%H:%M:%S:%2N]"`

memory=`free -h | awk 'FNR == 2 { print $3 "/" $2; }'` 

cpu_temp=`cat /sys/class/thermal/thermal_zone0/temp | cut -c1-2`"°C" 

cpu_usage=`vmstat | awk 'FNR == 3 { print 100 - $15 "%"; }'` 

traffic=`cat $kde_status_traffic`

echo "$date [$memory] [$cpu_temp $cpu_usage] [$traffic]" > $kde_status

done