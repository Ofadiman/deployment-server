FROM ubuntu:24.04@sha256:1e622c5f073b4f6bfad6632f2616c7f59ef256e96fe78bf6a595d1dc4376ac02 

ENV SPLUNK_HOME="/opt/splunkforwarder"
# Add splunk universal forwarder binary directory to the system PATH so splunk commands are available globally.
ENV PATH="${PATH}:${SPLUNK_HOME}/bin"

# Update system packages and install missing packages.
RUN \
	apt-get update && \
	apt-get install --yes --no-install-recommends curl ca-certificates uuid-runtime jq && \
	rm -rf /var/lib/apt/lists/*

# Download splunk universal forwarder and it's sha512 for further verification.
RUN curl --output /splunkforwarder-9.4.2-e9664af3d956-linux-amd64.tgz "https://download.splunk.com/products/universalforwarder/releases/9.4.2/linux/splunkforwarder-9.4.2-e9664af3d956-linux-amd64.tgz"
RUN curl --output /splunkforwarder-9.4.2-e9664af3d956-linux-amd64.tgz.sha512 "https://download.splunk.com/products/universalforwarder/releases/9.4.2/linux/splunkforwarder-9.4.2-e9664af3d956-linux-amd64.tgz.sha512?_gl=1*1hjotbh*_gcl_aw*R0NMLjE3NDU4MzIxMDkuQ2owS0NRand6cnpBQmhEOEFSSXNBTmxTV05PbFJraThyRVh6ODBYSG5NRlNGUDV1SDhwdnNwd1REX2RvdUIydm8zZ2lNaW92UjhFc3g5VWFBbDFiRUFMd193Y0I.*_gcl_au*MjUwNTUxNzg0LjE3NDU4MzIxMDg.*FPAU*MjUwNTUxNzg0LjE3NDU4MzIxMDg.*_ga*MjAxMDEwODc3OC4xNzQ1NDMxNDQ2*_ga_5EPM2P39FV*MTc0NTg3NTMzOC41LjEuMTc0NTg3NTcxNS4wLjAuMTEwMjE5NzMxOA..*_fplc*SWh4WlpkSzNqbkJVallTQmxoSWhydEJWJTJCSiUyRnZQeDhQZUJza2tvNjl2bG10RHNNT3Y2ZGk1ODU5aGRhaE9sMG4wYTc1cTd4bHJma25wd3BuVzJMZ0YxbGVVazF4TU5tVzhJeDclMkJxNlJ6ZUN3cVFtR0tPb29mYkZMM1F5NlpBJTNEJTNE"

# Verify the integrity of the downloaded splunk universal forwarder binary using the sha512 checksum.
RUN sha512sum --check /splunkforwarder-9.4.2-e9664af3d956-linux-amd64.tgz.sha512

# Install splunk universal forwarder.
RUN tar --extract --gzip --file /splunkforwarder-9.4.2-e9664af3d956-linux-amd64.tgz --directory /opt

# Copy local configuration files to customize splunk installation.
COPY etc "${SPLUNK_HOME}/etc"

# Set working directory to splunk home.
WORKDIR "${SPLUNK_HOME}"

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

CMD ["sh", "-c", "splunk start --answer-yes --no-prompt --accept-license && tail --follow ${SPLUNK_HOME}/var/log/splunk/splunkd.log"]
