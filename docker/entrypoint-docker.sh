#!/bin/bash

KAFKA_DIR="/app/kafka"
KAFKA_BIN_DIR="${KAFKA_DIR}/bin"

LISTENERS="CONTROLLER://:19092,EXTERNAL://:9093,INTERNAL://:9092"

ADVERTISED_LISTENERS="EXTERNAL://localhost:19092,INTERNAL://localhost:9092"

CONTROLLER_QUORUM_VOTERS=""

for i in $( seq 0 $REPLICAS); do
    if [[ $i != $REPLICAS ]]; then
        CONTROLLER_QUORUM_VOTERS="$CONTROLLER_QUORUM_VOTERS$i@broker-$i:19092,"
    else
        CONTROLLER_QUORUM_VOTERS=${CONTROLLER_QUORUM_VOTERS::-1}
    fi
done


mkdir -p $SHARE_DIR/$NODE_ID

sed -i \
-e "s+^controller.quorum.voters=.*+controller.quorum.voters=$CONTROLLER_QUORUM_VOTERS+" \
-e "s+^node.id=.*+node.id=$NODE_ID+" \
-e "s+^log.dirs=.*+log.dirs=$SHARE_DIR/$NODE_ID+" \
-e "s+^listeners=.*+listeners=$LISTENERS+" \
-e "s+^advertised.listeners=.*+advertised.listeners=$ADVERTISED_LISTENERS+" \
$KAFKA_DIR/server.properties

cat $KAFKA_DIR/server.properties

./bin/kafka-storage.sh format -t $CLUSTER_ID -c $KAFKA_DIR/server.properties;

exec $KAFKA_BIN_DIR/kafka-server-start.sh $KAFKA_DIR/server.properties
