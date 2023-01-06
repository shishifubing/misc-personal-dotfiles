#!/usr/bin/env bash
set -Eeuxo pipefail

echo "waiting for cloud-init"
while [ ! -f /var/lib/cloud/instance/boot-finished ]; do
    sleep 5
done
echo "done"
