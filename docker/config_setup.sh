#!/bin/bash

# Setup configuration properties
KAFKA_DIR="/app/kafka"
SERVER_PROPERTIES_DIR=$KAFKA_DIR/server.properties
KAFKA_BIN_DIR="${KAFKA_DIR}/bin"
STORAGE_DIR="${STORAGE_DIR:-/mtn}"
LOG_DIRS=$STORAGE_DIR/$NODE_ID
CLUSTER_ID="${CLUSTER_ID:-oh-sxaDRTcyAr6pFRbXyzA}"
NODE_ID="${NODE_ID:-0}"
REPLICAS="${REPLICAS:-1}"
NODE_HOSTNAME="${NODE_HOSTNAME:-broker}"
NODE_CONTROLLER_PORT="${NODE_PORT:-19092}"
INTER_BROKER_LISTENER_NAME="${INTER_BROKER_LISTENER_NAME:-BROKER_LISTENER}"
CONTROLLER_LISTENER_NAMES="${CONTROLLER_LISTENER_NAMES:-CONTROLLER}"
LISTENERS="${LISTENERS:-CONTROLLER://:$NODE_CONTROLLER_PORT,BROKER_LISTENER://:19093,LOCAL://:9092,EXTERNAL://:9093}"
ADVERTISED_LISTENERS="${ADVERTISED_LISTENERS:-BROKER_LISTENER://$NODE_HOSTNAME$NODE_ID:19093,LOCAL://localhost:9092,EXTERNAL://localhost:9093}"
LISTENER_SECURITY_PROTOCOL_MAP="${LISTENER_SECURITY_PROTOCOL_MAP:-CONTROLLER:PLAINTEXT,BROKER_LISTENER:PLAINTEXT,LOCAL:PLAINTEXT,EXTERNAL:PLAINTEXT}"

CONTROLLER_QUORUM_VOTERS=""
for i in $(seq 0 $((REPLICAS - 1))); do
    CONTROLLER_QUORUM_VOTERS+="$i@$NODE_HOSTNAME-$i:$NODE_CONTROLLER_PORT,"
done
CONTROLLER_QUORUM_VOTERS=${CONTROLLER_QUORUM_VOTERS::-1}

# Function to update Kafka configuration
update_kafka_configuration() {
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
}
