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
    }'
  )"

done &

while true; do

  date=$(
    date +"[%A] [%B] [%d-%m-%Y] [%H:%M:%S:%3N]" # date
  )

  memory=$(
    free -h | # show memory in human readable form 
    tac | # need to be piped into tac to not call awk multiple times
    awk '
      FNR == 1 {
        swap_usage=$3;
      };
      FNR == 2 { 
        print $3 "+" swap_usage "/" $2; 
      };
    '
  )

  cpu_temp=$( # only first two numbers are meaningful
    cut -c1-2 /sys/class/thermal/thermal_zone0/temp
  )"°C"

  cpu_usage=$(
    vmstat |
    awk 'FNR == 3 { 
      print 100 - $15 "%"; 
    }'
  )

  traffic=$(<"$kde_status_traffic")

  $kde_status<"$date [$memory] [$cpu_temp $cpu_usage] [$traffic]"

done