#!/bin/bash

set -e
# set -x

if [ "$SHARD_REPLICA_SET" == "" ]; then
    echo "SHARD_REPLICA_SET is required"
    exit 1
fi

/config.sh &

echo "Starting Mongo shard node..."
mongod --port 27017 --shardsvr --replSet $SHARD_REPLICA_SET --bind_ip_all --dbpath /data
