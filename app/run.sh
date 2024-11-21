#! /usr/bin/env bash
set -Eeuo pipefail

error() {
    echo -e "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >&2
}

STAGING=${STAGING:-0}
LEGO_ARGS=${LEGO_ARGS:-}
MODE=${MODE:-renew}
HOOK=${HOOK:-/app/hook.sh}

# Get endpoint
ENDPOINT='https://acme-v02.api.letsencrypt.org/directory'
[ "1" == "$STAGING" ] && ENDPOINT='https://acme-staging-v02.api.letsencrypt.org/directory'

DOMAINS=${DOMAINS:-}
DOMAINS=$( ( [ -n "$DOMAINS" ] && echo ${DOMAINS//;/ --domains } ) )

# Stop here if no domains were given as arguments
[ -z "$DOMAINS" ] && error 'Domain(s) not provided.' && exit 1


EMAIL_ADDRESS=${EMAIL_ADDRESS:-}

# Stop here if no email address given as arguments
[ -z "$EMAIL_ADDRESS" ] && error 'Email Address not provided.' && exit 1


[ -n "$PROVIDER" ] && echo "Using dns provider $PROVIDER."

KEY_TYPE=${KEY_TYPE-ec384}

if [[ -f $HOOK && -x "$HOOK" ]]; then
    if [ -n "$PROVIDER" ]; then
        DNS_TIMEOUT=${DNS_TIMEOUT:-10}
        /lego --server $ENDPOINT --path /letsencrypt --accept-tos --key-type=$KEY_TYPE --domains $DOMAINS --email $EMAIL_ADDRESS --pem --dns $PROVIDER --dns-timeout $DNS_TIMEOUT $LEGO_ARGS $MODE --${MODE}-hook=/app/hook.sh
    else
        /lego --server $ENDPOINT --path /letsencrypt --accept-tos --key-type=$KEY_TYPE --domains $DOMAINS --email $EMAIL_ADDRESS --pem $LEGO_ARGS $MODE --${MODE}-hook=/app/hook.sh
    fi
else
    echo "File '$HOOK' is not executable or found"
fi
