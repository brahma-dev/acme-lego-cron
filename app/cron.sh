#!/bin/sh
set -a

#RUN it once to initiate
MODE=run /app/run.sh

crond -f
