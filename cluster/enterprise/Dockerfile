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

# Add splunk apps for deployment.
RUN --mount=type=bind,source=deployment-apps,target=/tmp \
  mkdir "${SPLUNK_HOME}/etc/deployment-apps/eventgen" && \
  tar --strip-components=1 --extract --gzip --file /tmp/eventgen_721.tgz --directory "${SPLUNK_HOME}/etc/deployment-apps/eventgen" && \
  mkdir "${SPLUNK_HOME}/etc/deployment-apps/splunk-add-on-for-okta-identity-cloud" && \
  tar --strip-components=1 --extract --gzip --file /tmp/splunk-add-on-for-okta-identity-cloud_300.tgz --directory "${SPLUNK_HOME}/etc/deployment-apps/splunk-add-on-for-okta-identity-cloud" && \
  mkdir "${SPLUNK_HOME}/etc/deployment-apps/splunk-add-on-for-unix-and-linux" && \
  tar --strip-components=1 --extract --gzip --file /tmp/splunk-add-on-for-unix-and-linux_1010.tgz --directory "${SPLUNK_HOME}/etc/deployment-apps/splunk-add-on-for-unix-and-linux" && \
  mkdir "${SPLUNK_HOME}/etc/deployment-apps/splunk-app-for-lookup-file-editing" && \
  tar --strip-components=1 --extract --gzip --file /tmp/splunk-app-for-lookup-file-editing_405.tgz --directory "${SPLUNK_HOME}/etc/deployment-apps/splunk-app-for-lookup-file-editing" && \
  mkdir "${SPLUNK_HOME}/etc/deployment-apps/splunk-common-information-model-cim" && \
  tar --strip-components=1 --extract --gzip --file /tmp/splunk-common-information-model-cim_604.tgz --directory "${SPLUNK_HOME}/etc/deployment-apps/splunk-common-information-model-cim" && \
  mkdir "${SPLUNK_HOME}/etc/deployment-apps/splunk-es-content-update" && \
  tar --strip-components=1 --extract --gzip --file /tmp/splunk-es-content-update_540.tgz --directory "${SPLUNK_HOME}/etc/deployment-apps/splunk-es-content-update"

# Copy local configuration files to customize splunk installation.
COPY "${SPLUNK_CONFIGURATION_PATH}" "${SPLUNK_HOME}/etc"

# Set working directory to splunk home.
WORKDIR "${SPLUNK_HOME}"

CMD ["sh", "-c", "${SPLUNK_HOME}/bin/splunk start --answer-yes --no-prompt --accept-license && tail --follow ${SPLUNK_HOME}/var/log/splunk/splunkd.log"]
