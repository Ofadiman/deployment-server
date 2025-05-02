#!/usr/bin/env bash

# This script creates a stable `clientName` in the form of UUID v5 for each universal forwarder based on its container name, which is assigned by docker.

set -euo pipefail

# A container can find its name by querying the Docker API using its ID.
CONTAINER_NAME=$(curl --unix-socket /var/run/docker.sock "http://localhost/containers/$(basename $(cat /proc/1/cpuset))/json" | jq -r '.Name')

# Generate a stable client name from the container name.
CLIENT_NAME=$(uuidgen --sha1 --namespace @oid --name "${CONTAINER_NAME}")

echo "clientName = ${CLIENT_NAME}" >>"${SPLUNK_HOME}/etc/system/local/deploymentclient.conf"

exec "$@"
