#!/bin/bash

# make pipes instead of regular files to not waste cpu cycles

kde_status=/tmp/kde_status
kde_status_traffic=${kde_status}_traffic

mkfifo $kde_status  # output pipe
mkfifo $kde_status_traffic  # network traffic pipe 
# the second pipe and the second loop are needed
# since getting network info takes too much time


while true; do

  $kde_status_traffic<"$(
    sar -n DEV 1 1 | 
    awk 'FNR == 6 { 
      printf("%.0fkB/s %.0fkB/s", $5, $6);
    }' # remove decimals since they are useless
  )"

done &

while true; do

  date=$(
    date +"[%A] [%B] [%d-%m-%Y] [%H:%M:%S:%3N]" # date
  )
  memory=$(
    free -h | # show memory in human readable form 
    awk ' 
      FNR == 2 { 
        ram_usage=$3; total_memory=$2; 
      };
      FNR == 3 {
        swap_usage=$3;
        print ram_usage "+" swap_usage "/" total_memory; 
      };
    '
  )
  cpu_temp=$( # outputs only the first two symbols of the file
    cut -c1-2 /sys/class/thermal/thermal_zone0/temp
  )°C
  cpu_usage=$(
    vmstat |
    awk '
      FNR == 3 { 
        print 100 - $15 "%"; 
      }
    '
  )
  traffic=$(<"$kde_status_traffic")
  $kde_status<"$date [$memory] [$cpu_temp $cpu_usage] [$traffic]"

done