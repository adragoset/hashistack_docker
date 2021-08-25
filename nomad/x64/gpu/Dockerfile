FROM nvidia/cuda:10.2-runtime
MAINTAINER Alexander Dragoset <a.dragoset@gmail.com> (@adragose)

ENV GLIBC_VERSION "2.25-r0"
ENV GOSU_VERSION 1.10
ENV DUMB_INIT_VERSION 1.2.0
ENV WAIT_FOR_CONSUL false

RUN apt-get update && \
apt-get install -y docker dos2unix git openssh-client dnsutils libc6 dpkg curl gosu gnupg libcap2 openssl ca-certificates dumb-init unzip

RUN addgroup --gid 1100 nomad && \
    adduser --ingroup nomad --uid 1100 nomad

RUN curl -L -o /usr/local/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v${DUMB_INIT_VERSION}/dumb-init_${DUMB_INIT_VERSION}_amd64
RUN chmod +x /usr/local/bin/dumb-init

ENV NOMAD_VERSION 1.1.3

RUN set -x \
  && cd /tmp \
  && curl -L -o nomad_${NOMAD_VERSION}_linux_amd64.zip https://releases.hashicorp.com/nomad/${NOMAD_VERSION}/nomad_${NOMAD_VERSION}_linux_amd64.zip \
  && curl -L -o nomad_${NOMAD_VERSION}_SHA256SUMS      https://releases.hashicorp.com/nomad/${NOMAD_VERSION}/nomad_${NOMAD_VERSION}_SHA256SUMS \
  && curl -L -o nomad_${NOMAD_VERSION}_SHA256SUMS.sig  https://releases.hashicorp.com/nomad/${NOMAD_VERSION}/nomad_${NOMAD_VERSION}_SHA256SUMS.sig \
  && export GNUPGHOME="$(mktemp -d)" \
  && gpg --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-keys 72D7468F \
  && gpg --batch --verify nomad_${NOMAD_VERSION}_SHA256SUMS.sig nomad_${NOMAD_VERSION}_SHA256SUMS \
  && grep nomad_${NOMAD_VERSION}_linux_amd64.zip nomad_${NOMAD_VERSION}_SHA256SUMS | sha256sum -c \
  && unzip -d /bin nomad_${NOMAD_VERSION}_linux_amd64.zip \
  && chmod +x /bin/nomad \
  && rm -rf "$GNUPGHOME" nomad_${NOMAD_VERSION}_linux_amd64.zip nomad_${NOMAD_VERSION}_SHA256SUMS nomad_${NOMAD_VERSION}_SHA256SUMS.sig

RUN mkdir -p /nomad/data && mkdir -p /nomad/config && chown -R nomad:nomad /nomad

VOLUME /nomad/data

EXPOSE 4646 4647 4648 4648/udp

ADD nomad/x64/gpu/start.sh /usr/local/bin/start.sh

RUN dos2unix /usr/local/bin/start.sh && chmod +x /usr/local/bin/start.sh

RUN mkdir -p ~/.ssh

RUN ssh-keyscan -t rsa github.com >> ~/.ssh/known_hosts

RUN cp -R ~/.ssh /home/nomad

ENTRYPOINT ["/usr/local/bin/start.sh"]
