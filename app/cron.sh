#!/bin/sh
set -a

#RUN it once to initiate
/app/run.sh

exec supercronic /app/crontab
