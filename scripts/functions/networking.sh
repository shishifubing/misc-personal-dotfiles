#!/usr/bin/env bash

### networking

## check open ports
net_ports_list() {

    sudo ss -tulpn | grep LISTEN

}

net_connections_list() {
    sudo netstat -nputw
}

net_check_dns() {
    dig "${@}" +nostats +nocomments +nocmd
}

### nginx fix
## fixes 'permission denied while connecting to upstream'
fix_nginx() {

    setsebool -P httpd_can_network_connect 1

}
