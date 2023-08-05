#!/bin/bash

# Source the configuration setup
source ./config_setup.sh

# Make the log directory if it doesn't exist
mkdir -p $LOG_DIRS

# Update the Kafka configuration
update_kafka_configuration

# Create a file for storing the cluster ID if it doesn't already exist
CLUSTER_FILE="$STORAGE_DIR/$NODE_ID/cluster_id"
if [[ ! -f $CLUSTER_FILE ]]; then
    echo $CLUSTER_ID > $CLUSTER_FILE
    ./bin/kafka-storage.sh format -t $CLUSTER_ID -c $SERVER_PROPERTIES_DIR
fi



# Print the server configuration to the console
cat $SERVER_PROPERTIES_DIR

# Start the Kafka server
exec $KAFKA_BIN_DIR/kafka-server-start.sh $SERVER_PROPERTIES_DIR
