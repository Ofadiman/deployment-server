#!/usr/bin/env bash

set -euo pipefail

CONTAINER_NAME=$(curl --unix-socket /var/run/docker.sock "http://localhost/containers/$(basename $(cat /proc/1/cpuset))/json" | jq -r '.Name')

CLIENT_ID=$(uuidgen --sha1 --namespace @oid --name "${CONTAINER_NAME}")

echo "clientName = ${CLIENT_ID}" >>"${SPLUNK_HOME}/etc/system/local/deploymentclient.conf"

exec "$@"
