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



#MAX WIRED TIGER CACHE
#using same limits as default documentation, by regarding to container mem limits, not the whole VM mem
#https://docs.mongodb.com/manual/reference/program/mongod/#cmdoption-mongod-wiredtigercachesizegb
WC=""
if [ "$WIRED_TIGER_CACHE_SIZE_GB" != "" ]; then
    WC="--wiredTigerCacheSizeGB $WIRED_TIGER_CACHE_SIZE_GB"
else
    MEM_LIMIT=$(cgget -n --values-only --variable memory.limit_in_bytes /)
    WT_CACHE=$(((100 * (MEM_LIMIT - 1000000000) / 2000000000)))
    WT_CACHE=$(echo $((WT_CACHE>25 ? WT_CACHE : 25)))
    WT_CACHE=$(echo $((WT_CACHE<10000 ? WT_CACHE : 0)))
    WT_CACHE_GB=$(echo 0$WT_CACHE | sed 's/..$/.&/')
    if [ "$WT_CACHE" != "0" ]; then
        WC="--wiredTigerCacheSizeGB $WT_CACHE_GB"
    fi
    echo "Max WiredTiger cache size GB=$WT_CACHE_GB"
fi



echo ">>> Starting Mongo shard node..."
AE=""
if [ "$SHARED_KEY_SECRET" != "" ]; then
    AE="--auth --keyFile /sharedkey"
fi
set -x
mongod --port 27017 $AE $WC --shardsvr --replSet $SHARD_REPLICA_SET --bind_ip_all --dbpath /data
