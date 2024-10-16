#!/bin/sh
set -a

error() {
    echo -e "[$( date '+%Y-%m-%d %H:%M:%S' )] $1" >&2
}

STAGING=${STAGING:-0}
LEGO_ARGS=${LEGO_ARGS:-}
MODE=${MODE:-renew}

# Get endpoint
ENDPOINT='https://acme-v02.api.letsencrypt.org/directory'
[ "1" == "$STAGING" ] && ENDPOINT='https://acme-staging-v02.api.letsencrypt.org/directory'

DOMAINS=${DOMAINS:-}
DOMAINS=$(  ( [ -n "$DOMAINS" ] && echo ${DOMAINS//;/ --domains } ) )

# Stop here if no domains were given as arguments
[ -z "$DOMAINS" ] && error 'Domain(s) not provided.' && exit 1


EMAIL_ADDRESS=${EMAIL_ADDRESS:-}

# Stop here if no email address given as arguments
[ -z "$EMAIL_ADDRESS" ] && error 'Email Address not provided.' && exit 1


[ -n "$PROVIDER" ] && echo "Using dns provider $PROVIDER."

KEY_TYPE=${KEY_TYPE-ec384}

if [ "$MODE" = "run" ]; then
    HOOK=${RUN_HOOK:+--run-hook $RUN_HOOK}
elif [ "$MODE" = "renew" ]; then
    HOOK=${RENEW_HOOK:+--renew-hook $RENEW_HOOK}
else
    HOOK=""
fi

if [ -n "$PROVIDER" ]; then
    DNS_TIMEOUT=${DNS_TIMEOUT:-10}
    /lego --server $ENDPOINT --path /letsencrypt --accept-tos --key-type=$KEY_TYPE --domains $DOMAINS --email $EMAIL_ADDRESS --pem --dns $PROVIDER --dns-timeout $DNS_TIMEOUT $LEGO_ARGS $MODE $HOOK
else
    /lego --server $ENDPOINT --path /letsencrypt --accept-tos --key-type=$KEY_TYPE --domains $DOMAINS --email $EMAIL_ADDRESS --pem $LEGO_ARGS $MODE $HOOK
fi
