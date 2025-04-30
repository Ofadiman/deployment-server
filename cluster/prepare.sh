#!/usr/bin/env bash

# https://gist.github.com/robin-a-meade/58d60124b88b60816e8349d1e3938615
set -euo pipefail

rm -rf deployment_apps
rm -rf client_events
echo "[Success] Deleted deployment_apps and client_events directories."

mkdir deployment_apps
mkdir client_events
echo "[Success] Created deployment_apps and client_events directories."

while [[ $# -gt 0 ]]; do
	case "${1}" in
	--username)
		USERNAME="${2}"
		echo "[Success] --username argument parsed correctly."
		shift 2
		;;
	--password)
		PASSWORD="${2}"
		echo "[Success] --password argument parsed correctly."
		shift 2
		;;
	*)
		echo "[Error] Unknown argument ${1}."
		exit 1
		;;
	esac
done

if [[ -z "${USERNAME}" ]]; then
	echo "[Error] --username argument is required."
	exit 1
fi

if [[ -z "${PASSWORD}" ]]; then
	echo "[Error] --password argument is required."
	exit 1
fi

COOKIE_JAR="/tmp/cookie-jar.txt"
# Login to splunkbase using credentials from docker secrets.
curl --silent --output /dev/null --show-error --request POST --url https://splunkbase.splunk.com/api/account:login/ --data "username=${USERNAME}&password=${PASSWORD}" --cookie-jar "${COOKIE_JAR}"

echo "[Success] Logged into splunkbase and stored cookies in ${COOKIE_JAR}."

curl --silent --show-error --location --cookie "${COOKIE_JAR}" "https://api.splunkbase.splunk.com/api/v2/apps/1924/releases/7.2.1/download/?origin=sb&lead=true" --output /tmp/eventgen_721.tgz
echo "[Success] Downloaded eventgen application."

tar --extract --gzip --file /tmp/eventgen_721.tgz --directory deployment_apps
echo "[Success] Unarchived eventgen application into deployment_apps directory."

rm "${COOKIE_JAR}"
echo "[Success] Deleted cookies from ${COOKIE_JAR}."
