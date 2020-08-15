#!/bin/sh

set -e

#check for replica set status
R=$(echo 'rs.status().ok' | mongo localhost:27017/test --quiet)
echo $R | grep 1 

#check that this node appears in nodes list
mongo --eval "db.isMaster()" | grep $SHARD_REPLICA_SET
