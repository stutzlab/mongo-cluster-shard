#!/bin/bash

set -e
# set -x

if [ "$SHARD_REPLICA_SET" == "" ]; then
    echo "SHARD_REPLICA_SET is required"
    exit 1
fi

SHAREDKEY_FILE="/run/secrets/$SHARED_KEY_SECRET"
if [ "$SHARED_KEY_SECRET" != "" ]; then
    if [ ! -f "$SHAREDKEY_FILE" ]; then
        echo "SHARED_KEY_SECRET was defined but no secret found at $SHAREDKEY_FILE"
        exit 1
    fi
    cp $SHAREDKEY_FILE /sharedkey
    chmod 600 /sharedkey
fi

/config.sh &

echo ">>> Starting Mongo shard node..."
AE=""
if [ "$SHARED_KEY_SECRET" != "" ]; then
    AE="--auth --keyFile /sharedkey"
fi
set -x
mongod --port 27017 $AE --shardsvr --replSet $SHARD_REPLICA_SET --bind_ip_all --dbpath /data
