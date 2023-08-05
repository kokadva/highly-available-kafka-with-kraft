#!/bin/bash

# Kafka configuration setup script
source ./config_setup.sh

# Make the log directory if it doesn't exist
mkdir -p $LOG_DIRS

# Update the Kafka configuration
update_kafka_configuration

# Define the format lock file path
FORMAT_LOCK_FILE="$STORAGE_DIR/$NODE_ID/.format-lock"

# If the format lock file does not exist, create it and then format the Kafka storage.
# This is a protection mechanism to avoid reformatting existing storage.
if [[ ! -f $FORMAT_LOCK_FILE ]]; then
    # Create the format lock file
    touch $FORMAT_LOCK_FILE
    # Format Kafka storage. -t option sets the cluster id, and -c sets the configuration file
    ./bin/kafka-storage.sh format -t $CLUSTER_ID -c $SERVER_PROPERTIES_DIR
fi


# Print the server properties file to the console. This allows for verifying the current configuration of the server.
cat $SERVER_PROPERTIES_DIR

# Start the Kafka server using the server start script and the updated configuration file.
exec $KAFKA_BIN_DIR/kafka-server-start.sh $SERVER_PROPERTIES_DIR
