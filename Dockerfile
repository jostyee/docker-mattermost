FROM frolvlad/alpine-glibc:alpine-3.6
MAINTAINER jasl8r@alum.wpi.edu

ENV MATTERMOST_VERSION=4.2.0 \
    MATTERMOST_HOME="/opt/mattermost"

ENV MATTERMOST_DATA_DIR="${MATTERMOST_HOME}/data" \
    MATTERMOST_BUILD_DIR="${MATTERMOST_HOME}/build" \
    MATTERMOST_RUNTIME_DIR="${MATTERMOST_HOME}/runtime" \
    MATTERMOST_CONF_DIR="${MATTERMOST_HOME}/config"

COPY assets/runtime/ ${MATTERMOST_RUNTIME_DIR}/
COPY entrypoint.sh /sbin/entrypoint.sh
COPY mattermost-team-linux-amd64.tar.gz /opt/mattermost-team-linux-amd64.tar.gz

RUN sed -i -e 's/dl-cdn/dl-5/' /etc/apk/repositories \
    && apk --no-cache add bash gettext \
    mysql-client \
    ca-certificates \
    && cd /opt \
    && tar -xzf mattermost-team-linux-amd64.tar.gz \
    && rm mattermost-team-linux-amd64.tar.gz \
    && chmod 755 /sbin/entrypoint.sh

EXPOSE 80/tcp

VOLUME ["${MATTERMOST_DATA_DIR}"]
WORKDIR ${MATTERMOST_HOME}

ENTRYPOINT ["/sbin/entrypoint.sh"]
CMD ["app:start"]
