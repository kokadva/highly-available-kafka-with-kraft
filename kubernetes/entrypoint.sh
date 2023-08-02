#!/bin/bash

# This script serves as the entrypoint for the Kafka image. It configures the
# server.properties file based on the environment variables provided and then starts Kafka.

# Extract the node ID from the pod hostname
NODE_ID=${HOSTNAME:6}

# Define Kafka directories
KAFKA_DIR="/app/kafka"
KAFKA_BIN_DIR="${KAFKA_DIR}/bin"

INTER_BROKER_LISTENER_NAME="BROKER_LISTENER"


CONTROLLER_LISTENER_NAMES="CONTROLLER"

LISTENERS="CONTROLLER://:19092,BROKER_LISTENER://:19093,LOCAL://:9092,EXTERNAL://:9093"

ADVERTISED_LISTENERS="BROKER_LISTENER://kafka-$NODE_ID.$SERVICE.$NAMESPACE.svc.cluster.local:19093,LOCAL://localhost:9092,EXTERNAL://localhost:9093"

LISTENER_SECURITY_PROTOCOL_MAP="CONTROLLER:PLAINTEXT,BROKER_LISTENER:PLAINTEXT,LOCAL:PLAINTEXT,EXTERNAL:PLAINTEXT"

CONTROLLER_QUORUM_VOTERS=""

# Generate election URLs for every node
for i in $( seq 0 $REPLICAS); do
    if [[ $i != $REPLICAS ]]; then
        CONTROLLER_QUORUM_VOTERS="$CONTROLLER_QUORUM_VOTERS$i@kafka-$i.$SERVICE.$NAMESPACE.svc.cluster.local:19092,"
    else
        CONTROLLER_QUORUM_VOTERS=${CONTROLLER_QUORUM_VOTERS::-1}
    fi
done

mkdir -p $SHARE_DIR/$NODE_ID

# Configure server.properties based on the provided environment variables
sed -i \
-e "s+^controller.quorum.voters=.*+controller.quorum.voters=$CONTROLLER_QUORUM_VOTERS+" \
-e "s+^node.id=.*+node.id=$NODE_ID+" \
-e "s+^log.dirs=.*+log.dirs=$SHARE_DIR/$NODE_ID+" \
-e "s+^listeners=.*+listeners=$LISTENERS+" \
-e "s+^advertised.listeners=.*+advertised.listeners=$ADVERTISED_LISTENERS+" \
-e "s+^listener.security.protocol.map=.*+listener.security.protocol.map=$LISTENER_SECURITY_PROTOCOL_MAP+" \
-e "s+^inter.broker.listener.name=.*+inter.broker.listener.name=$INTER_BROKER_LISTENER_NAME+" \
-e "s+^controller.listener.names=.*+controller.listener.names=$CONTROLLER_LISTENER_NAMES+" \
$KAFKA_DIR/server.properties

# Format log.dirs if not formatted yet
if [[ ! -f "$SHARE_DIR/$NODE_ID/cluster_id" ]]; then
    echo $CLUSTER_ID > $SHARE_DIR/$NODE_ID/cluster_id
    ./bin/kafka-storage.sh format -t $CLUSTER_ID -c $KAFKA_DIR/server.properties;
fi

# Display the server.properties content for verification
cat $KAFKA_DIR/server.properties

# Start Kafka
exec $KAFKA_BIN_DIR/kafka-server-start.sh $KAFKA_DIR/server.properties
