FROM ubuntu:24.04@sha256:1e622c5f073b4f6bfad6632f2616c7f59ef256e96fe78bf6a595d1dc4376ac02 

ENV SPLUNK_HOME="/opt/splunk"
# Add splunk binary directory to the system PATH so splunk commands are available globally.
ENV PATH="${PATH}:${SPLUNK_HOME}/bin"

# Update system packages and install missing packages.
RUN \
  apt-get update && \
  apt-get install --yes --no-install-recommends curl ca-certificates uuid-runtime jq && \
  rm -rf /var/lib/apt/lists/*

# Download splunk and it's sha512 for further verification.
RUN curl --output /splunk-9.4.0-6b4ebe426ca6-linux-amd64.tgz "https://download.splunk.com/products/splunk/releases/9.4.0/linux/splunk-9.4.0-6b4ebe426ca6-linux-amd64.tgz"
RUN curl --output /splunk-9.4.0-6b4ebe426ca6-linux-amd64.tgz.sha512 "https://download.splunk.com/products/splunk/releases/9.4.0/linux/splunk-9.4.0-6b4ebe426ca6-linux-amd64.tgz.sha512?_gl=1*s8p1dv*_gcl_aw*R0NMLjE3NDU4MzIxMDkuQ2owS0NRand6cnpBQmhEOEFSSXNBTmxTV05PbFJraThyRVh6ODBYSG5NRlNGUDV1SDhwdnNwd1REX2RvdUIydm8zZ2lNaW92UjhFc3g5VWFBbDFiRUFMd193Y0I.*_gcl_au*MjUwNTUxNzg0LjE3NDU4MzIxMDg.*FPAU*MjUwNTUxNzg0LjE3NDU4MzIxMDg.*_ga*MjAxMDEwODc3OC4xNzQ1NDMxNDQ2*_ga_5EPM2P39FV*MTc0NTg0MTMyNS4zLjEuMTc0NTg0MTM1Mi4wLjAuODYzNzUwODM.*_fplc*bVBwdE1POGVqRTB1NGJwV2diaHhneWslMkZySTgyR2p3TEpydGFLYUpEWnIyZjBIZ3YzM1klMkJlc214Y0FHUG5pVlo3V3UxTnM3Zm81TUNlZm9BQlFHUnZrVVglMkJsYnh0OW1kWDJReGwwJTJCdFNJWjI4SkdyYjhmZDJLJTJCOHB4Y21xUSUzRCUzRA.."

# Verify the integrity of the downloaded splunk binary using the sha512 checksum.
RUN sha512sum --check /splunk-9.4.0-6b4ebe426ca6-linux-amd64.tgz.sha512

# Install splunk.
RUN tar --extract --gzip --file /splunk-9.4.0-6b4ebe426ca6-linux-amd64.tgz --directory /opt

# Add splunk apps for deployment.
RUN \
  --mount=type=secret,id=splunkbase_username \
  --mount=type=secret,id=splunkbase_password \
  # Login to splunkbase using credentials from docker secrets.
  curl --silent --output /dev/null --show-error --request POST --url https://splunkbase.splunk.com/api/account:login/ --data "username=$(cat /run/secrets/splunkbase_username)&password=$(cat /run/secrets/splunkbase_password)" --cookie-jar cookie-jar.txt && \
  # Download apps from splunkbase.
  curl --silent --show-error --location --cookie cookie-jar.txt "https://api.splunkbase.splunk.com/api/v2/apps/1876/releases/7.9.1/download/?origin=sb&lead=true" --output /tmp/splunk-add-on-for-amazon-web-services-aws_791.tgz && \
  curl --silent --show-error --location --cookie cookie-jar.txt "https://api.splunkbase.splunk.com/api/v2/apps/3088/releases/4.7.3/download/?origin=sb&lead=true" --output /tmp/splunk-add-on-for-google-cloud-platform_473.tgz && \
  curl --silent --show-error --location --cookie cookie-jar.txt "https://api.splunkbase.splunk.com/api/v2/apps/3110/releases/5.5.0/download/?origin=sb&lead=true" --output /tmp/splunk-add-on-for-microsoft-cloud-services_550.tgz && \
  # Unarchive apps to default deployment server repository location.
  tar --extract --gzip --file /tmp/splunk-add-on-for-amazon-web-services-aws_791.tgz --directory "${SPLUNK_HOME}/etc/deployment-apps" && \
  tar --extract --gzip --file /tmp/splunk-add-on-for-google-cloud-platform_473.tgz --directory "${SPLUNK_HOME}/etc/deployment-apps" && \
  tar --extract --gzip --file /tmp/splunk-add-on-for-microsoft-cloud-services_550.tgz --directory "${SPLUNK_HOME}/etc/deployment-apps" && \
  # Delete cached authentication cookies from the container.
  rm cookie-jar.txt

# Copy local configuration files to customize splunk installation.
COPY etc "${SPLUNK_HOME}/etc"

# Set working directory to splunk home.
WORKDIR "${SPLUNK_HOME}"

CMD ["sh", "-c", "${SPLUNK_HOME}/bin/splunk start --answer-yes --no-prompt --accept-license && tail --follow ${SPLUNK_HOME}/var/log/splunk/splunkd.log"]
