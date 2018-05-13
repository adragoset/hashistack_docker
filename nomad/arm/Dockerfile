FROM arm32v6/alpine:3.7

LABEL maintainer="DJ Enriquez <denrie.enriquezjr@gmail.com> (@djenriquez)"

ENV GLIBC_VERSION "2.25-r0"
ENV GOSU_VERSION 1.10
ENV DUMB_INIT_VERSION 1.2.0
ENV HASHICORP_RELEASES=https://releases.hashicorp.com

RUN apk update

RUN apk add shadow docker dos2unix git openssh-client --update-cache --repository http://dl-3.alpinelinux.org/alpine/edge/community/ --allow-untrusted

RUN addgroup -g 1100 nomad && \
    adduser -S -G nomad -u 1100 nomad

RUN set -x && \
    apk --update add --no-cache --virtual .gosu-deps dpkg curl gnupg
RUN curl -L -o /tmp/glibc-${GLIBC_VERSION}.apk https://github.com/andyshinn/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-${GLIBC_VERSION}.apk
RUN apk add --allow-untrusted /tmp/glibc-${GLIBC_VERSION}.apk && \
    rm -rf /tmp/glibc-${GLIBC_VERSION}.apk /var/cache/apk/*
RUN curl -L -o /usr/local/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v${DUMB_INIT_VERSION}/dumb-init_${DUMB_INIT_VERSION}_amd64
RUN chmod +x /usr/local/bin/dumb-init
RUN dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')" && \
    curl -L -o /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch"
RUN export GNUPGHOME="$(mktemp -d)" && \
    chmod +x /usr/local/bin/gosu && \
    gosu nobody true && \
    apk del .gosu-deps

ENV NOMAD_VERSION 0.8.3

RUN set -x \
  apk --update add --no-cache --virtual .nomad-deps gnupg curl \
  && cd /tmp \
  && apkArch="$(apk --print-arch)" && \
      case "${apkArch}" in \
        aarch64) nomadArch='arm64' ;; \
        armhf) nomadArch='arm' ;; \
        x86) nomadArch='386' ;; \
        x86_64) nomadArch='amd64' ;; \
        *) echo >&2 "error: unsupported architecture: ${apkArch} (see ${HASHICORP_RELEASES}/nomad/${NOMAD_VERSION}/)" && exit 1 ;; \
    esac && \
    curl -L -o nomad_${NOMAD_VERSION}_linux_${nomadArch}.zip ${HASHICORP_RELEASES}/nomad/${NOMAD_VERSION}/nomad_${NOMAD_VERSION}_linux_${nomadArch}.zip && \
    unzip -d /bin nomad_${NOMAD_VERSION}_linux_${consulArch}.zip && \
  chmod +x /bin/nomad \
  && apk del .nomad-deps

RUN apk add --no-cache ca-certificates curl dumb-init gnupg libcap openssl

RUN mkdir -p /nomad/data
RUN mkdir -p /nomad/config

RUN  chown -R nomad:nomad /nomad

VOLUME /nomad/data

EXPOSE 4646 4647 4648 4648/udp

ADD start.sh /usr/local/bin/start.sh

RUN dos2unix /usr/local/bin/start.sh && chmod +x /usr/local/bin/start.sh

RUN mkdir -p ~/.ssh

RUN ssh-keyscan -t rsa github.com >> ~/.ssh/known_hosts

RUN cp -R ~/.ssh /home/nomad

ENTRYPOINT ["/usr/local/bin/start.sh"]