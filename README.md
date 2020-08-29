# mongo-cluster-shard

Mongo Cluster Shard service node

This is meant to be used along with [http://github.com/stutzlab/mongo-cluster-configsrv](mongo-cluster-configsrv) and [http://github.com/stutzlab/mongo-cluster-router](mongo-cluster-router).

**Check http://github.com/stutzlab/mongo-cluster for more details and examples**

## ENVs

* SHARD_REPLICA_SET - name of the shard replica set
* INIT_SHARD_NODES - if defined, will try to initialize this shard adding those nodes as initial shard nodes. Important: place this configuration only in one shard node.
* SHARED_KEY_SECRET - secret name with shared key. defaults to '', which will run with no keyfile
* WIRED_TIGER_CACHE_SIZE_GB - defines the max cache size for wired tiger storage in GB. defaults to 1/2 of available mem limits for this container (defined in limits of cgroup) - almost the same behavior as mongod, but using cgroup limits (https://docs.mongodb.com/manual/reference/program/mongod/#bin.mongod)

## Volumes

* Mount volumes at "/data".
