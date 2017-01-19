FROM alpine:3.4
MAINTAINER jasl8r@alum.wpi.edu

ENV MATTERMOST_VERSION=3.6.0 \
    MATTERMOST_HOME="/opt/mattermost"

ENV MATTERMOST_DATA_DIR="${MATTERMOST_HOME}/data" \
    MATTERMOST_BUILD_DIR="${MATTERMOST_HOME}/build" \
    MATTERMOST_RUNTIME_DIR="${MATTERMOST_HOME}/runtime" \
    MATTERMOST_CONF_DIR="${MATTERMOST_HOME}/config" \
    MATTERMOST_LOG_DIR="/var/log/mattermost"

COPY assets/build/ ${MATTERMOST_BUILD_DIR}/
COPY entrypoint.sh /sbin/entrypoint.sh

RUN apk --no-cache add bash gettext \
    mysql-client postgresql-client \
    ca-certificates \
    && bash ${MATTERMOST_BUILD_DIR}/install.sh \
    && chmod 755 /sbin/entrypoint.sh

COPY assets/runtime/ ${MATTERMOST_RUNTIME_DIR}/

EXPOSE 80/tcp

VOLUME ["${MATTERMOST_DATA_DIR}", "${MATTERMOST_LOG_DIR}"]
WORKDIR ${MATTERMOST_HOME}
ENTRYPOINT ["/sbin/entrypoint.sh"]
CMD ["app:start"]
