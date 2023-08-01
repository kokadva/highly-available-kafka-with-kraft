#!/bin/bash

# This script serves as the entrypoint for the Kafka image. It configures the
# server.properties file based on the environment variables provided and then starts Kafka.

# Extract the node ID from the pod hostname
NODE_ID=${HOSTNAME:6}

# Define Kafka directories
KAFKA_DIR="/app/kafka"
KAFKA_BIN_DIR="${KAFKA_DIR}/bin"

# Define Kafka app listeners
LISTENERS="CONTROLLER://:19092,EXTERNAL://:9093,INTERNAL://:9092"

# Define Kafka node listeners
ADVERTISED_LISTENERS="INTERNAL://localhost:9092,EXTERNAL://kafka-$NODE_ID.$SERVICE.$NAMESPACE.svc.cluster.local:19092"

# Initialize the variable for the controller quorum voters
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
$KAFKA_DIR/server.properties

# Format log.dirs if not formatted yet
if [[ ! -f "$SHARE_DIR/$NODE_ID/cluster_id" ]]; then
    echo $CLUSTER_ID > $SHARE_DIR/cluster_id
    ./bin/kafka-storage.sh format -t $CLUSTER_ID -c $KAFKA_DIR/server.properties;
fi

# Display the server.properties content for verification
cat $KAFKA_DIR/server.properties

# Start Kafka
exec $KAFKA_BIN_DIR/kafka-server-start.sh $KAFKA_DIR/server.properties
