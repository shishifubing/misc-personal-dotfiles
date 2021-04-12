#!/bin/bash

# make a pipe instead of a regular file to not waste cpu cycles

kde_status=/tmp/kde_status
mkfifo "$kde_status" || true  # output pipe

while true; do

  # moved to a separate Command Output plasmoid for efficiency
  #date=$(
  #  date +"[%A] [%B] [%d-%m-%Y] [%H:%M:%S:%3N]" # date
  #)
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
  traffic=$(
    sar -n DEV 1 1 | 
    awk '
      FNR == 6 { 
        printf("%.0fkB/s %.0fkB/s", $5, $6);
      }
    '
  )
  echo "[$memory] [$cpu_temp $cpu_usage] [$traffic]" > "$kde_status"

done