FROM ubuntu:24.04@sha256:1e622c5f073b4f6bfad6632f2616c7f59ef256e96fe78bf6a595d1dc4376ac02 

ARG SPLUNK_CONFIGURATION_PATH

ENV SPLUNK_HOME="/opt/splunk"
# Add splunk binary directory to the system PATH so splunk commands are available globally.
ENV PATH="${PATH}:${SPLUNK_HOME}/bin"

# Update system packages and install missing packages.
RUN \
  apt-get update && \
  apt-get install --yes --no-install-recommends curl ca-certificates uuid-runtime jq && \
  rm -rf /var/lib/apt/lists/*

# Download splunk enterprise.
RUN curl --output /splunk-9.4.0-6b4ebe426ca6-linux-amd64.tgz "https://download.splunk.com/products/splunk/releases/9.4.0/linux/splunk-9.4.0-6b4ebe426ca6-linux-amd64.tgz"

# Install splunk enterprise in default directory.
RUN tar --extract --gzip --file /splunk-9.4.0-6b4ebe426ca6-linux-amd64.tgz --directory /opt

# Copy local configuration files to customize splunk installation.
COPY "${SPLUNK_CONFIGURATION_PATH}" "${SPLUNK_HOME}/etc"

# Set working directory to splunk home.
WORKDIR "${SPLUNK_HOME}"

CMD ["sh", "-c", "${SPLUNK_HOME}/bin/splunk start --answer-yes --no-prompt --accept-license && tail --follow ${SPLUNK_HOME}/var/log/splunk/splunkd.log"]
