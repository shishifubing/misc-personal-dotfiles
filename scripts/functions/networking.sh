#!/usr/bin/env bash

### networking

## check open ports
networking_ports_list() {

    sudo ss -tulpn | grep LISTEN

}

networking_connections_list() {
    sudo netstat -nputw
}

### nginx fix
## fixes 'permission denied while connecting to upstream'
fix_nginx() {

    setsebool -P httpd_can_network_connect 1

}
