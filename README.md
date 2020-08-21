# mongo-cluster-shard

Mongo Cluster Shard service node

This is meant to be used along with [http://github.com/stutzlab/mongo-cluster-configsrv](mongo-cluster-configsrv) and [http://github.com/stutzlab/mongo-cluster-router](mongo-cluster-router).

**Check http://github.com/stutzlab/mongo-cluster for more details and examples**

## ENVs

* SHARD_REPLICA_SET - name of the shard replica set
* INIT_SHARD_NODES - if defined, will try to initialize this shard adding those nodes as initial shard nodes. Important: place this configuration only in one shard node.
* AUTH_ENABLE - only allow connections from authenticated users (even through mongos router). default to true.

## Volumes

* Mount volumes at "/data".
