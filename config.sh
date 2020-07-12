#!/bin/bash

echo "Waiting for mongo server to be available at 27017..."
while ! nc -z 127.0.0.1 27017; do sleep 0.5; done
sleep 1

MAX_RETRIES=9999
if [ "$INIT_SHARD_NODES" != "" ]; then
   MAX_RETRIES=5
fi

echo "Verifying if this shard node is already part of a shard..."
C=0
while (( "$C" < "$MAX_RETRIES" )); do
   mongo --eval "db.isMaster()" | grep $SHARD_REPLICA_SET
   if [ "$?" == "0" ]; then
      mongo --eval "db.isMaster()"
      echo ">>> THIS NODE IS PART OF A SHARD REPLICASET"
      exit 0
   fi
   C=($C+1)
   echo "."
   sleep 1
done

if [ "$INIT_SHARD_NODES" == "" ]; then
  echo ">>> THIS NODE IS NOT PART OF A SHARD. ADD IT IN ORDER TO BE ACTIVE"
  echo "Tip: On master node, execute rs.add( { host: \"[host]\", priority: 0, votes: 0 } )"
  exit 0
fi

echo "Generating initial shard config"
echo ""

rm /init-shard.js
cat <<EOT >> /init-shard.js
rs.initiate(
   {
EOT

echo "_id: \"$SHARD_REPLICA_SET\"," >> /init-shard.js

cat <<EOT >> /init-shard.js
      version: 1,
      members: [
EOT

IFS=',' read -r -a NODES <<< "$INIT_SHARD_NODES"
S=""
c=0
for N in "${NODES[@]}"; do
   echo "${S}{ _id: $c, host : \"$N:27017\"}" >> /init-shard.js
   S=","
   c=$((c+1))
done

cat <<EOT >> /init-shard.js
      ]
   }
)
EOT

echo "/init-shard.js"
cat /init-shard.js

echo "INITIALIZING NEW SHARD..."
mongo < /init-shard.js
echo ">>> NEW SHARD INITIALIZED SUCCESSFULLY"

