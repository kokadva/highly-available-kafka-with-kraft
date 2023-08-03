#!/bin/bash

# This script serves as the entrypoint for the Kafka image. It configures the
# server.properties file based on the environment variables provided and then starts Kafka.

# Extract the node ID from the pod hostname
NODE_ID=${HOSTNAME:6}

# Define Kafka directories

KAFKA_DIR="/app/kafka"

KAFKA_BIN_DIR="${KAFKA_DIR}/bin"

SERVER_PROPERTIES_DIR=$KAFKA_DIR/server.properties

STORAGE_DIR="${STORAGE_DIR:-/mtn}"

LOG_DIRS=$STORAGE_DIR/$NODE_ID

CLUSTER_ID="${CLUSTER_ID:-oh-sxaDRTcyAr6pFRbXyzA}"

NODE_ID="${NODE_ID:-0}"

REPLICAS="${REPLICAS:-1}"

INTER_BROKER_LISTENER_NAME="${INTER_BROKER_LISTENER_NAME:-BROKER_LISTENER}"

CONTROLLER_LISTENER_NAMES="${CONTROLLER_LISTENER_NAMES:-CONTROLLER}"

LISTENERS="${LISTENERS:-CONTROLLER://:19092,BROKER_LISTENER://:19093,LOCAL://:9092,EXTERNAL://:9093}"

ADVERTISED_LISTENERS="${ADVERTISED_LISTENERS:-BROKER_LISTENER://kafka-$NODE_ID.$SERVICE.$NAMESPACE.svc.cluster.local:19093,LOCAL://localhost:9092,EXTERNAL://localhost:9093}"

LISTENER_SECURITY_PROTOCOL_MAP="${LISTENER_SECURITY_PROTOCOL_MAP:-CONTROLLER:PLAINTEXT,BROKER_LISTENER:PLAINTEXT,LOCAL:PLAINTEXT,EXTERNAL:PLAINTEXT}"

ADVERTISED_LISTENERS="BROKER_LISTENER://kafka-$NODE_ID.$SERVICE.$NAMESPACE.svc.cluster.local:19093,LOCAL://localhost:9092,EXTERNAL://localhost:9093"


# Generate election URLs for every node
CONTROLLER_QUORUM_VOTERS=""
for i in $(seq 0 $((REPLICAS - 1))); do
    CONTROLLER_QUORUM_VOTERS+="$i@kafka-$i.$SERVICE.$NAMESPACE.svc.cluster.local:19092,"
done
CONTROLLER_QUORUM_VOTERS=${CONTROLLER_QUORUM_VOTERS::-1} # Remove trailing comma


mkdir -p $SHARE_DIR/$NODE_ID

# Configure server.properties based on the provided environment variables
sed -i \
-e "s+^controller.quorum.voters=.*+controller.quorum.voters=$CONTROLLER_QUORUM_VOTERS+" \
-e "s+^node.id=.*+node.id=$NODE_ID+" \
-e "s+^log.dirs=.*+log.dirs=$LOG_DIRS+" \
-e "s+^listeners=.*+listeners=$LISTENERS+" \
-e "s+^advertised.listeners=.*+advertised.listeners=$ADVERTISED_LISTENERS+" \
-e "s+^listener.security.protocol.map=.*+listener.security.protocol.map=$LISTENER_SECURITY_PROTOCOL_MAP+" \
-e "s+^inter.broker.listener.name=.*+inter.broker.listener.name=$INTER_BROKER_LISTENER_NAME+" \
-e "s+^controller.listener.names=.*+controller.listener.names=$CONTROLLER_LISTENER_NAMES+" \
$SERVER_PROPERTIES_DIR

# Format log.dirs if not formatted yet
CLUSTER_FILE="$STORAGE_DIR/$NODE_ID/cluster_id"
if [[ ! -f $CLUSTER_FILE ]]; then
    echo $CLUSTER_ID > $CLUSTER_FILE
    ./bin/kafka-storage.sh format -t $CLUSTER_ID -c $SERVER_PROPERTIES_DIR
fi

# Display the server.properties content for verification
cat $SERVER_PROPERTIES_DIR

# Start Kafka
exec $KAFKA_BIN_DIR/kafka-server-start.sh $SERVER_PROPERTIES_DIR
