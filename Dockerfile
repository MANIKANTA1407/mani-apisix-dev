# https://hub.docker.com/r/apache/apisix/tags
FROM apache/apisix:3.14.0-debian

USER root

COPY conf/config.yaml /usr/local/apisix/conf/config.yaml
COPY custom-plugins/header-injector.lua /usr/local/apisix/apisix/plugins/
COPY custom-plugins/custom-file-logger.lua /usr/local/apisix/apisix/plugins/

# 🔥 Change ownership to apisix user
RUN chown apisix:apisix /usr/local/apisix/conf/config.yaml

USER apisix