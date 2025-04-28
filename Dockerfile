FROM ubuntu:24.04@sha256:1e622c5f073b4f6bfad6632f2616c7f59ef256e96fe78bf6a595d1dc4376ac02 

# Use the latest splunk version by default.
ARG SPLUNK_DOWNLOAD_URL="https://download.splunk.com/products/splunk/releases/9.4.0/linux/splunk-9.4.0-6b4ebe426ca6-linux-amd64.tgz"

ENV SPLUNK_HOME="/opt/splunk"

# Update system dependencies.
RUN \
	apt-get update && \
	apt-get install --yes --no-install-recommends curl ca-certificates && \
	rm -rf /var/lib/apt/lists/*

# Install splunk.
RUN \
	curl -L -o /tmp/splunk.tgz "${SPLUNK_DOWNLOAD_URL}" && \
	tar -xzf /tmp/splunk.tgz -C /opt && \
	rm /tmp/splunk.tgz

# Setup splunk alias.
RUN echo '#!/bin/bash\n/opt/splunk/bin/splunk "$@"' > /usr/bin/splunk && chmod +x /usr/bin/splunk

RUN echo "OPTIMISTIC_ABOUT_FILE_LOCKING=1" > ${SPLUNK_HOME}/etc/splunk-launch.conf

WORKDIR "${SPLUNK_HOME}"

CMD ["sh", "-c", "${SPLUNK_HOME}/bin/splunk start --answer-yes --no-prompt --accept-license && tail -f ${SPLUNK_HOME}/var/log/splunk/splunkd.log"]
