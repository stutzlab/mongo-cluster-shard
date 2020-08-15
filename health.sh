#!/bin/sh

function deepCheck() {
    #check for replica set status
    R=$(echo 'rs.status().ok' | mongo localhost:27017/test --quiet)
    echo $R | grep 1
    if [ "$?" == "0" ]; then
        return 0
    fi

    #check that this node appears in nodes list
    mongo --eval "db.isMaster()" | grep $1
    if [ "$?" == "0" ]; then
        return 0
    fi

    return 1
}

set -e
nc -z 127.0.0.1 27017
set +e

if [ ! -f "/data/__initialized" ]; then
    echo "Node not initialized yet"
    R=$(deepCheck $SHARD_REPLICA_SET)
    if [ "$R" = "0" ]; then
        touch /data/__initialized
    fi
    exit 0
fi

echo "Node already initialized. make deep check"
R=$(deepCheck $SHARD_REPLICA_SET)
exit $R

