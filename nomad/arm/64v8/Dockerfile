FROM arm64v8/debian:buster-slim
MAINTAINER Alexander Dragoset <a.dragoset@gmail.com> (@adragose)

# This is the release of Nomad to pull in.
ENV NOMAD_VERSION=1.1.4

# This is the location of the releases.
ENV HASHICORP_RELEASES=https://releases.hashicorp.com

# Create a nomad user and group first so the IDs get set the same way, even as
# the rest of this may change over time.
RUN adduser nomad

# Set up certificates, base tools, and Nomad.
RUN set -eux && \
    apt-get update && \
    apt-get install -y ca-certificates curl wget unzip dumb-init gnupg libcap-dev openssl openssh-client dnsutils git && \
    mkdir -p /tmp/build && \
    cd /tmp/build && \
    apkArch="$(dpkg --print-architecture)" && \
    case "${apkArch}" in \
        arm64) nomadArch='arm64' ;; \
        armhf) nomadArch='arm' ;; \
        x86) nomadArch='386' ;; \
        x86_64) nomadArch='amd64' ;; \
        *) echo >&2 "error: unsupported architecture: ${apkArch} (see ${HASHICORP_RELEASES}/nomad/${NOMAD_VERSION}/)" && exit 1 ;; \
    esac && \
    wget ${HASHICORP_RELEASES}/nomad/${NOMAD_VERSION}/nomad_${NOMAD_VERSION}_linux_${nomadArch}.zip && \
    unzip -d /bin nomad_${NOMAD_VERSION}_linux_${nomadArch}.zip && \
    cd /tmp && \
    rm -rf /tmp/build && \
    apt-get -y remove gnupg openssl && \
    rm -rf /root/.gnupg && \
    chmod +x /bin/nomad
# tiny smoke test to ensure the binary we downloaded runs

#Install docker
RUN curl -fsSLk https://download.docker.com/linux/debian/gpg | apt-key add - \
    && touch /etc/apt/sources.list.d/docker.list \
    && echo deb [arch=arm64] https://download.docker.com/linux/debian buster stable > /etc/apt/sources.list.d/docker.list \
    && apt-get update -o Acquire::https::download.docker.com::Verify-Peer=false \
    && apt-get install -y -o Acquire::https::download.docker.com::Verify-Peer=false docker-ce \
    && usermod -a -G docker nomad

ENV PATH=$PATH:/bin/nomad

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
COPY nomad/arm/docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

RUN chmod 777 /usr/local/bin/docker-entrypoint.sh \
    && ln -s /usr/local/bin/docker-entrypoint.sh /

RUN mkdir -p ~/.ssh

RUN ssh-keyscan -t rsa github.com >> ~/.ssh/known_hosts

RUN cp -R ~/.ssh /home/nomad

RUN apt-get install -y build-essential && \
    git -c http.sslVerify=false clone https://github.com/ncopa/su-exec.git && \
    cd su-exec && \
    make -f Makefile && \
    cp /su-exec/su-exec /usr/local/bin/su-exec && \
    apt-get -y remove build-essential && \
    chmod +x /usr/local/bin/su-exec
    
ENTRYPOINT ["docker-entrypoint.sh"]

# By default you'll get an insecure single-node development server that stores
# everything in RAM, exposes a web UI and HTTP endpoints, and bootstraps itself.
# Don't use this configuration for production.
CMD ["agent", "-dev", "-client", "0.0.0.0"]
