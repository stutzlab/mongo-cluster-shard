# mongo-cluster-shard

Mongo Cluster Shard service node

This is meant to be used along with [http://github.com/stutzlab/mongo-cluster-configsrv](mongo-cluster-configsrv) and [http://github.com/stutzlab/mongo-cluster-router](mongo-cluster-router).

**Check http://github.com/stutzlab/mongo-cluster for more details and examples**

## ENVs

* SHARD_REPLICA_SET - name of the shard
* SHARD_SERVER_NODES - hostname of shards that are part of shard defined in $SHARD_NAME

