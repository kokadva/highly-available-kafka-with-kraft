[![Docker Image build/push](https://github.com/kokadva/highly-available-kafka-with-kraft/actions/workflows/docker-image.yml/badge.svg)](https://github.com/kokadva/highly-available-kafka-with-kraft/actions/workflows/docker-image.yml)

## Highly Available Kafka in KRaft Mode on Kubernetes

Welcome to our repository! Here, you will find the necessary Dockerfiles and Kubernetes configuration files required to
run a highly available Kafka in KRaft mode on Kubernetes. KRaft, or Kafka Raft metadata mode, enables Kafka to operate
without the need for ZooKeeper.

## Kafka Version

This setup uses Kafka version 3.3.1

## Public docker image:

* `kokadva/kafka-kraft`

### Configuration:

You can use the following environment variables for configuration:

- (Required) `NODE_ID`: Unique node id for each node, starting from 0. Default: `HOSTNAME:6` (config property: `node.id`)
- (Required) `REPLICAS`: Number of replicas or nodes in the cluster. Must be the same for all nodes. Default: `1`
- (Required) `CLUSTER_ID`: ID for the cluster. Must be the same for all nodes. Default: `oh-sxaDRTcyAr6pFRbXyzA`
- (Required) `NODE_HOSTNAME_PREFIX` and `NODE_HOSTNAME_SUFFIX`: In order to connect kafka brokers for high availability they must 
know each other's hostname, so you have to set these env variables correctly (`NODE_HOSTNAME_SUFFIX`) is not always needed, 
look into the bash scripts for specifics
- `STORAGE_DIR`: Directory for storing logs. Actual logs will be saved in the `STORAGE_DIR/NODE_ID` directory. Default: `/mtn`
- `INTER_BROKER_LISTENER_NAME`: Default: `BROKER_LISTENER` (config property: `inter.broker.listener.name`)
- `CONTROLLER_LISTENER_NAMES`: Default: `CONTROLLER` (config property: `controller.listener.names`)
- `LISTENERS`: Default: `CONTROLLER://:19092,BROKER_LISTENER://:19093,LOCAL://:9092,EXTERNAL://:9093` (config property: `listeners`)
- `ADVERTISED_LISTENERS`: (config property: `advertised.listeners`, computed: `BROKER_LISTENER://$NODE_HOSTNAME_PREFIX$NODE_ID$NODE_HOSTNAME_SUFFIX:19093,LOCAL://localhost:9092,EXTERNAL://localhost:9093`)
- `LISTENER_SECURITY_PROTOCOL_MAP`: Default: `CONTROLLER:PLAINTEXT,BROKER_LISTENER:PLAINTEXT,LOCAL:PLAINTEXT,EXTERNAL:PLAINTEXT` (config property: `listener.security.protocol.map`)
- See others in the [config_setup.sh](docker%2Fconfig_setup.sh)

## How to build kafka-kraft docker image

Navigate to the `docker` directory in the repository, then:

* Build the Docker image: `docker build -t kafka-kraft .`

### How to run with docker compose/kubernetes

* For docker compose look at [docker-compose.yml](docker%2Fdocker-compose.yml) file
* For kubernetes look at [kafka.yml](docker%2Fkafka.yml) config file

### How to build a docker image of another version of kafka 

Note: every version of kafka is different, if you use other version then 3.3.1 you'll may have to adjust these scripts:

* [entrypoint.sh](docker%2Fentrypoint.sh)
* [config_setup.sh](docker%2Fconfig_setup.sh)


### Choose version 

Go to https://kafka.apache.org/downloads, choose `scala` and `kafka` versions and replace existing with the chosen ones 
here [Dockerfile](docker%2FDockerfile) and build the docker image


### Authors:

* Konstantine Dvalishvili 

