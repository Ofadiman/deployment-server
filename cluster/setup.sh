#!/usr/bin/env bash

# Usage: zsh setup.sh --username admin@gmail.com --password password

# https://gist.github.com/robin-a-meade/58d60124b88b60816e8349d1e3938615
set -euo pipefail

sudo rm -rf deployment_apps
sudo rm -rf client_events
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

COOKIE_JAR_PATH="/tmp/cookie-jar.txt"
EVENTGEN_APP_PATH="/tmp/eventgen.tgz"
AWS_APP_PATH="/tmp/splunk-add-on-for-amazon-web-services-aws.tgz"
GCP_APP_PATH="/tmp/splunk-add-on-for-google-cloud-platform.tgz"
AZURE_APP_PATH="/tmp/splunk-add-on-for-microsoft-cloud-services.tgz"

echo "[Info] Logging into splunkbase..."
curl --silent --output /dev/null --show-error --request POST --url https://splunkbase.splunk.com/api/account:login/ --data "username=${USERNAME}&password=${PASSWORD}" --cookie-jar "${COOKIE_JAR_PATH}"
echo "[Success] Logged into splunkbase and stored cookies in ${COOKIE_JAR_PATH}."

echo "[Info] Downloading deployment apps from splunkbase..."

if [[ -f "${EVENTGEN_APP_PATH}" ]]; then
	echo "[Info] ${EVENTGEN_APP_PATH} already exists, skipping download."
else
	curl --silent --show-error --location --cookie "${COOKIE_JAR_PATH}" "https://api.splunkbase.splunk.com/api/v2/apps/1924/releases/7.2.1/download/?origin=sb&lead=true" --output "${EVENTGEN_APP_PATH}"
fi

if [[ -f "${AWS_APP_PATH}" ]]; then
	echo "[Info] ${AWS_APP_PATH} already exists, skipping download."
else
	curl --silent --show-error --location --cookie "${COOKIE_JAR_PATH}" "https://api.splunkbase.splunk.com/api/v2/apps/1876/releases/7.9.1/download/?origin=sb&lead=true" --output "${AWS_APP_PATH}"
fi

if [[ -f "${GCP_APP_PATH}" ]]; then
	echo "[Info] ${GCP_APP_PATH} already exists, skipping download."
else
	curl --silent --show-error --location --cookie "${COOKIE_JAR_PATH}" "https://api.splunkbase.splunk.com/api/v2/apps/3088/releases/4.7.3/download/?origin=sb&lead=true" --output "${GCP_APP_PATH}"
fi

if [[ -f "${AZURE_APP_PATH}" ]]; then
	echo "[Info] ${AZURE_APP_PATH} already exists, skipping download."
else
	curl --silent --show-error --location --cookie "${COOKIE_JAR_PATH}" "https://api.splunkbase.splunk.com/api/v2/apps/3110/releases/5.5.0/download/?origin=sb&lead=true" --output "${AZURE_APP_PATH}"
fi

echo "[Success] Downloaded deployment apps from splunkbase."

tar --extract --gzip --file "${EVENTGEN_APP_PATH}" --directory deployment_apps
tar --extract --gzip --file "${AWS_APP_PATH}" --directory deployment_apps
tar --extract --gzip --file "${GCP_APP_PATH}" --directory deployment_apps
tar --extract --gzip --file "${AZURE_APP_PATH}" --directory deployment_apps
echo "[Success] Unarchived deployment apps into deployment_apps directory."

rm "${COOKIE_JAR_PATH}"
echo "[Success] Deleted cookies from ${COOKIE_JAR_PATH}."
