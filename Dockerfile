FROM ubuntu:24.04@sha256:1e622c5f073b4f6bfad6632f2616c7f59ef256e96fe78bf6a595d1dc4376ac02 

ENV SPLUNK_HOME="/opt/splunk"

# Update system dependencies.
RUN \
	apt-get update && \
	apt-get install --yes --no-install-recommends curl ca-certificates && \
	rm -rf /var/lib/apt/lists/*

# Download splunk and it's sha512 checksum.
RUN curl -L -o /splunk-9.4.0-6b4ebe426ca6-linux-amd64.tgz "https://download.splunk.com/products/splunk/releases/9.4.0/linux/splunk-9.4.0-6b4ebe426ca6-linux-amd64.tgz"
RUN curl -L -o /splunk-9.4.0-6b4ebe426ca6-linux-amd64.tgz.sha512 "https://download.splunk.com/products/splunk/releases/9.4.0/linux/splunk-9.4.0-6b4ebe426ca6-linux-amd64.tgz.sha512?_gl=1*s8p1dv*_gcl_aw*R0NMLjE3NDU4MzIxMDkuQ2owS0NRand6cnpBQmhEOEFSSXNBTmxTV05PbFJraThyRVh6ODBYSG5NRlNGUDV1SDhwdnNwd1REX2RvdUIydm8zZ2lNaW92UjhFc3g5VWFBbDFiRUFMd193Y0I.*_gcl_au*MjUwNTUxNzg0LjE3NDU4MzIxMDg.*FPAU*MjUwNTUxNzg0LjE3NDU4MzIxMDg.*_ga*MjAxMDEwODc3OC4xNzQ1NDMxNDQ2*_ga_5EPM2P39FV*MTc0NTg0MTMyNS4zLjEuMTc0NTg0MTM1Mi4wLjAuODYzNzUwODM.*_fplc*bVBwdE1POGVqRTB1NGJwV2diaHhneWslMkZySTgyR2p3TEpydGFLYUpEWnIyZjBIZ3YzM1klMkJlc214Y0FHUG5pVlo3V3UxTnM3Zm81TUNlZm9BQlFHUnZrVVglMkJsYnh0OW1kWDJReGwwJTJCdFNJWjI4SkdyYjhmZDJLJTJCOHB4Y21xUSUzRCUzRA.."

# Make sure the sha512 of the downloaded archive is the same as the sha512 declared by splunk.
RUN sha512sum --check /splunk-9.4.0-6b4ebe426ca6-linux-amd64.tgz.sha512

# Install splunk.
RUN tar -xzf /splunk-9.4.0-6b4ebe426ca6-linux-amd64.tgz -C /opt

# Setup splunk alias.
RUN echo '#!/bin/bash\n/opt/splunk/bin/splunk "$@"' > /usr/bin/splunk && chmod +x /usr/bin/splunk

RUN echo "OPTIMISTIC_ABOUT_FILE_LOCKING=1" > ${SPLUNK_HOME}/etc/splunk-launch.conf

WORKDIR "${SPLUNK_HOME}"

CMD ["sh", "-c", "${SPLUNK_HOME}/bin/splunk start --answer-yes --no-prompt --accept-license && tail -f ${SPLUNK_HOME}/var/log/splunk/splunkd.log"]
