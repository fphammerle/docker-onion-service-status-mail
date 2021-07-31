#!/bin/sh

set -e

if [ -z "$TOR_HOST" ]; then
    echo 'missing $TOR_HOST'
    exit 1
elif [ -z "$ONION_SERVICE_HOST" ]; then
    echo 'missing $ONION_SERVICE_HOST'
    exit 1
elif [ -z "$ONION_SERVICE_PORT" ]; then
    echo 'missing $ONION_SERVICE_PORT'
    exit 1
elif [ -z "$MAIL_TO" ]; then
    echo 'missing $MAIL_TO'
    exit 1
fi

sender_address="onion-service-status@$(hostname).local"

ping_onion_service() {(
    if [ ! -z "$VERBOSE" ]; then
        set -x
    fi
    nc -z -w "$TIMEOUT_SECONDS" -x "$TOR_HOST:$TOR_PORT" "$ONION_SERVICE_HOST" "$ONION_SERVICE_PORT"
)}

send_report() {(
    if [ ! -z "$VERBOSE" ]; then
        set -x
    fi
    sendmail -t <<EOF
From: $sender_address
To: $MAIL_TO
Subject: $ONION_SERVICE_HOST:$ONION_SERVICE_PORT $1

EOF
)}

last_state=""
left_retries="$RETRIES"
while : ; do
    if ! nc -z -w "$TIMEOUT_SECONDS" "$TOR_HOST" "$TOR_PORT"; then
        echo "failed to connect to tor proxy at $TOR_HOST:$TOR_PORT"
    else
        if ping_onion_service; then
            if [ "$last_state" == "offline" ]; then
                echo went online
                send_report online
            fi
            last_state="online"
            left_retries=$RETRIES
        else
            if [ $left_retries -le 0 ]; then
                if [ "$last_state" == "online" ]; then
                    echo went offline
                    send_report offline
                fi
                last_state="offline"
            else
                left_retries=$((left_retries-1))
                [ ! -z "$VERBOSE" ] && echo "$left_retries retry/ies left"
            fi
        fi
    fi
    # flush queue
    dma -q1
    sleep "$SLEEP_DURATION"
done
