#!/bin/sh

deepCheck() {
    #check for replica set status
    R=$(echo 'rs.status().ok' | mongo localhost:27017/test --quiet)
    if [ "$?" != "0" ]; then
        echo "1"
        return
    fi
    if [ "$R" != "1" ]; then
        echo "1"
        return
    fi

    #check that this node appears in nodes list
    V=$(mongo --eval "db.isMaster()" | grep $)
    echo $?
}

set -e
nc -z 127.0.0.1 27017
set +e

if [ ! -f "/data/__initialized" ]; then
    echo "Service is up. replicaset not initialized yet"
    R=$(deepCheck $SHARD_REPLICA_SET)
    if [ "$R" = "0" ]; then
        echo "Marking this as initialized"
        touch /data/__initialized
    fi
    exit 0
fi

echo "Service is up. replicaset initialized. making deep check"
R=$(deepCheck $SHARD_REPLICA_SET)
exit $R

