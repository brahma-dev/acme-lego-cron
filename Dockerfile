# Dockerfile: https://hub.docker.com/r/goacme/lego/
ARG VERSION
FROM goacme/lego:${VERSION}

MAINTAINER Brahma Dev

COPY app/*.sh /app
RUN chown -R root:root /app
RUN chmod -R 550 /app
RUN chmod +x app/*.sh

RUN mkdir -p /letsencrypt

COPY crontab /var/spool/cron/crontabs/root
RUN chown -R root:root /var/spool/cron/crontabs/root && chmod -R 640 /var/spool/cron/crontabs/root

# This is the only signal from the docker host that appears to stop crond
STOPSIGNAL SIGKILL

WORKDIR /app
RUN ls -al
ENTRYPOINT "/app/cron.sh"
