# mongo-cluster-shard

Mongo Cluster Shard service node

This is meant to be used along with [http://github.com/stutzlab/mongo-cluster-configsrv](mongo-cluster-configsrv) and [http://github.com/stutzlab/mongo-cluster-router](mongo-cluster-router).

**Check http://github.com/stutzlab/mongo-cluster for more details and examples**

## ENVs

* SHARD_REPLICA_SET - name of the shard replica set
* INIT_SHARD_NODES - if defined, will try to initialize this shard adding those nodes as initial shard nodes. Important: place this configuration only in one shard node.

## Volumes

* Mount volumes at "/data/db". DON'T map at "/data" because there exists an /data/db volume that will be created for the instance if not declared explicitly!
