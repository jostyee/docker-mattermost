FROM frolvlad/alpine-glibc:alpine-3.7
LABEL maintainer="jostyee <hi@josta.me>"

ENV MATTERMOST_VERSION=5.0.0 \
    MATTERMOST_HOME="/mattermost"

ENV MATTERMOST_DATA_DIR="${MATTERMOST_HOME}/data"

RUN apk --no-cache add bash gettext curl \
    mysql-client postgresql-client \
    ca-certificates \
    && curl https://releases.mattermost.com/${MATTERMOST_VERSION}/mattermost-${MATTERMOST_VERSION}-linux-amd64.tar.gz | tar -xz \
    && apk del curl

EXPOSE 80/tcp

VOLUME ["${MATTERMOST_DATA_DIR}"]
WORKDIR ${MATTERMOST_HOME}

ENTRYPOINT ["bin/mattermost"]
