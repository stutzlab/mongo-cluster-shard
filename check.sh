#!/bin/sh

nc -z 127.0.0.1 27017

echo "Check replicaset status"
R=$(echo 'rs.status().ok' | mongo localhost:27017/test --quiet)
if [ "$?" != "0" ]; then
    echo "Cannot query mongo"
    exit 1
fi
if [ "$R" != "1" ]; then
    echo "rs.status() not OK"
    exit 1
fi

echo "Check that this node appears in nodes list"
V=$(mongo --eval "db.isMaster()" | grep $SHARD_REPLICA_SET)
E=$?
exit $E
