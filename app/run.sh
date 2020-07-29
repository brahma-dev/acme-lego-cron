#!/bin/sh
set -a

error() {
    echo -e "[$( date '+%Y-%m-%d %H:%M:%S' )] $1" >&2
}

STAGING=${STAGING:-}

MODE=${MODE:-renew}

# Get endpoint
ENDPOINT='https://acme-v02.api.letsencrypt.org/directory'
[ -n "$STAGING" ] && ENDPOINT='https://acme-staging-v02.api.letsencrypt.org/directory'

DOMAINS=${DOMAINS:-}
DOMAINS=$(  ( [ -n "$DOMAINS" ] && echo ${DOMAINS//;/ --domains } ) )

# Stop here if no domains were given as arguments
[ -z "$DOMAINS" ] && error 'Domain(s) not provided.' && exit 1


EMAIL_ADDRESS=${EMAIL_ADDRESS:-}

# Stop here if no email address given as arguments
[ -z "$EMAIL_ADDRESS" ] && error 'Email Address not provided.' && exit 1


[ -n "$PROVIDER" ] && echo "Using dns provider $PROVIDER."

KEY_TYPE=${KEY_TYPE-ec384}

if [ -n "$PROVIDER" ]; then
    DNS_TIMEOUT=${DNS_TIMEOUT:-10}
    /usr/bin/lego --path /letsencrypt --accept-tos --key-type=$KEY_TYPE --dns $PROVIDER --domains $DOMAINS --email $EMAIL_ADDRESS --dns-timeout $DNS_TIMEOUT $MODE
else
    /usr/bin/lego --path /letsencrypt --accept-tos --key-type=$KEY_TYPE --domains $DOMAINS --email $EMAIL_ADDRESS $MODE
fi