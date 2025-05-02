FROM ubuntu:24.04@sha256:1e622c5f073b4f6bfad6632f2616c7f59ef256e96fe78bf6a595d1dc4376ac02 

ARG SPLUNK_FORWARDER_CONFIGURATION_PATH

ENV SPLUNK_HOME="/opt/splunkforwarder"
# Add splunk universal forwarder binary directory to the system PATH so splunk commands are available globally.
ENV PATH="${PATH}:${SPLUNK_HOME}/bin"

# Update system packages and install missing packages.
RUN \
	apt-get update && \
	apt-get install --yes --no-install-recommends curl ca-certificates uuid-runtime jq && \
	rm -rf /var/lib/apt/lists/*

# Download splunk universal forwarder.
RUN curl --output /splunkforwarder-9.4.2-e9664af3d956-linux-amd64.tgz "https://download.splunk.com/products/universalforwarder/releases/9.4.2/linux/splunkforwarder-9.4.2-e9664af3d956-linux-amd64.tgz"

# Install splunk universal forwarder.
RUN tar --extract --gzip --file /splunkforwarder-9.4.2-e9664af3d956-linux-amd64.tgz --directory /opt

# Copy local configuration files to customize splunk installation.
COPY "${SPLUNK_FORWARDER_CONFIGURATION_PATH}" "${SPLUNK_HOME}/etc"

# Set working directory to splunk home.
WORKDIR "${SPLUNK_HOME}"

CMD ["sh", "-c", "splunk start --answer-yes --no-prompt --accept-license && tail --follow ${SPLUNK_HOME}/var/log/splunk/splunkd.log"]
