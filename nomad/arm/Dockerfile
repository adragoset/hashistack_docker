FROM arm32v7/debian:stretch-slim
MAINTAINER Preetha Appan <preetha@hashicorp.com> (@preetapan)

# This is the release of Nomad to pull in.
ENV NOMAD_VERSION=0.8.3

# This is the location of the releases.
ENV HASHICORP_RELEASES=https://releases.hashicorp.com

# Create a nomad user and group first so the IDs get set the same way, even as
# the rest of this may change over time.
RUN adduser nomad

# Set up certificates, base tools, and Nomad.
RUN set -eux && \
    apt-get update && \
    apt-get install -y ca-certificates curl dumb-init gnupg libcap-dev openssl && \
    mkdir -p /tmp/build && \
    cd /tmp/build && \
    wget ${HASHICORP_RELEASES}/nomad/${NOMAD_VERSION}/nomad_${NOMAD_VERSION}_linux_arm.zip && \
    unzip -d /bin nomad_${NOMAD_VERSION}_linux_arm.zip && \
    cd /tmp && \
    rm -rf /tmp/build && \
    apt-get remove gnupg openssl && \
    rm -rf /root/.gnupg && \
    chmod +x /bin/nomad
# tiny smoke test to ensure the binary we downloaded runs

RUN curl -fsSLR -o /usr/local/bin/su-exec https://github.com/javabean/su-exec/releases/download/v0.2/su-exec.$(dpkg --print-architecture | awk -F- '{ print $NF }')

RUN nomad version

# The /nomad/data dir is used by Nomad to store state. The agent will be started
# with /nomad/config as the configuration directory so you can add additional
# config files in that location.
RUN mkdir -p /nomad/data && \
    mkdir -p /nomad/config && \
    chown -R nomad:nomad /nomad

# Expose the nomad data directory as a volume since there's mutable state in there.
VOLUME /nomad/data

EXPOSE 4646 4647 4648 4648/udp


# Nomad doesn't need root privileges so we run it as the nomad user from the
# entry point script. The entry point script also uses dumb-init as the top-level
# process to reap any zombie processes created by Nomad sub-processes.
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

RUN chmod 777 /usr/local/bin/docker-entrypoint.sh \
    && ln -s /usr/local/bin/docker-entrypoint.sh /

RUN mkdir -p ~/.ssh

RUN ssh-keyscan -t rsa github.com >> ~/.ssh/known_hosts

RUN cp -R ~/.ssh /home/nomad
    
ENTRYPOINT ["docker-entrypoint.sh"]

# By default you'll get an insecure single-node development server that stores
# everything in RAM, exposes a web UI and HTTP endpoints, and bootstraps itself.
# Don't use this configuration for production.
CMD ["agent", "-dev", "-client", "0.0.0.0"]