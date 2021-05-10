#!/usr/bin/env bash

# kde aliases

# resources
kde_resources() {

    local memory=$(
        free -h | # show memory in human readable form
            awk '
                FNR == 2 { ram_usage=$(3); total_memory=$(2); };
                FNR == 3 {
                    swap_usage=$(3);
                    print ram_usage "+" swap_usage "/" total_memory;
                };
            '
    )
    # outputs only the first two symbols of the file
    local cpu_temp="$(cut -c1-2 /sys/class/thermal/thermal_zone0/temp)°C"
    local cpu_usage=$(vmstat | awk 'FNR == 3 { print 100 - $(15) "%" }')
    local traffic=$(
        sar -n DEV 1 1 |
            awk 'FNR == 6 { printf("%.0fkB/s %.0fkB/s", $(5), $(6)) }'
    )

    echo "[${memory}] [${cpu_temp} ${cpu_usage}] [${traffic}]"

}

# date
kde_date() {

    date +"[%A] [%B] [%Y-%m-%d] [%H:%M:%S:%3N]"

}
