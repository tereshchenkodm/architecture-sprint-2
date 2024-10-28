#!/bin/bash
docker compose exec -T configSrv mongosh --port 27019 <<EOF
rs.initiate({_id: "config", configsvr: true, members: [
{_id: 0, host: "configSrv:27019"}
]})
EOF
echo "Wait mongos_router..."

docker compose exec -T shard1-1 mongosh --port 27018 <<EOF
rs.initiate({_id: "shard1", members: [
{_id: 0, host: "shard1-1:27018"},
{_id: 1, host: "shard1-2:27018"},
{_id: 2, host: "shard1-3:27018"}
]})
EOF

docker compose exec -T shard2-1 mongosh --port 27018 <<EOF
rs.initiate({_id: "shard2", members: [
{_id: 0, host: "shard2-1:27018"},
{_id: 1, host: "shard2-2:27018"},
{_id: 2, host: "shard2-3:27018"}
]})
EOF

docker compose exec -T mongos_router mongosh <<EOF
sh.addShard( "shard1/shard1-1:27018,shard1-2:27018,shard1-3:27018");
sh.addShard( "shard2/shard2-1:27018,shard2-2:27018,shard2-3:27018");
sh.enableSharding("somedb");
sh.shardCollection("somedb.helloDoc", { "name" : "hashed" } );
EOF

docker compose exec -T mongos_router mongosh <<EOF
use somedb
for(var i = 0; i < 1000; i++) db.helloDoc.insertOne({age:i, name:"ly"+i})
EOF

docker exec -it redis_1 sh -c 'echo "yes" | redis-cli --cluster create redis_1:6379 redis_2:6379 redis_3:6379 redis_4:6379 redis_5:6379 redis_6:6379 --cluster-replicas 1'