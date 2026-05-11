#!/bin/sh
set -a

#RUN it once to initiate
/app/run.sh

crond -f
