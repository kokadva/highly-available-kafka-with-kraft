[![Docker Image build/push](https://github.com/kokadva/highly-available-kafka-with-kraft/actions/workflows/docker-image.yml/badge.svg)](https://github.com/kokadva/highly-available-kafka-with-kraft/actions/workflows/docker-image.yml)

## Highly Available Kafka in KRaft Mode on Kubernetes

Welcome to our repository! Here, you will find the necessary Dockerfiles and Kubernetes configuration files required to
run a highly available Kafka in KRaft mode on Kubernetes. KRaft, or Kafka Raft metadata mode, enables Kafka to operate
without the need for ZooKeeper.

## Kafka Version

This setup uses Kafka version 3.3.1.

## Public docker images:

We have provided Docker images for both Kubernetes and docker-compose for your convenience:

* Kubernetes Docker Image: `kokadva/kafka-kraft-kube`
* Docker-compose Docker Image: `kokadva/kafka-kraft-compose`

## Pre-requisites

Before you get started, make sure you have the following:

- Docker
- Kubernetes
- Optional: Container Image Registry Account

### How to Build and Run for Docker-compose

Navigate to the docker/docker-compose directory in the repository, then:

* Build the Docker image: `docker build -t kafka .`
* Run Docker compose: `docker compose up`

To run multiple brokers, simply add broker-1, broker-2, and so forth to the services in Docker compose and adjust the
environment variables as needed (`NODE_ID`, `REPLICAS`).

### How to Build and Run for Kubernetes

Navigate to the docker/kubernetes directory in the repository. If you prefer not to build the image yourself, you can
use ours: `kokadva/kafka-kraft-kube`

Note: The Docker image must be built on the same OS as your Kubernetes nodes. A container image registry account is
also necessary.

* Login to your image registry: `docker login`
* Build the Docker image: `docker build -t {your-username}/kafka .`
* Push the Docker image: `docker push -t {your-username/kafka .`
* Apply the Kubernetes configuration: `kubectl apply -f kafka.yml` (Modify configuration as needed)

This process will launch 3 Kafka nodes in your Kubernetes cluster. To test this, you can ssh into one of your Kafka
nodes using `kubectl exec -it kafka-0 -- /bin/bash`. Navigate to the `/app/kafka/bin directory` and run kafka commands.
To list all Kafka commands run [kafka_commands.py](kafka_commands.py) python script.

* `kubectl exec -it kafka-0 -- /bin/bash`

### Kafka configuration:

You can use the following environment variables for configuration:

- (Required) `NODE_ID`: Unique node id for each node, starting from 0. Default: `0` (config property: `node.id`)
- (Required) `REPLICAS`: Number of replicas or nodes in the cluster. Must be the same for all nodes. Default: `1`
- `STORAGE_DIR`: Directory for storing logs. Actual logs will be saved in the `STORAGE_DIR/NODE_ID` directory.
  Default: `/mtn`
- `CLUSTER_ID`: ID for the cluster. Must be the same for all nodes. Default: `oh-sxaDRTcyAr6pFRbXyzA`
- `INTER_BROKER_LISTENER_NAME`: Default: `BROKER_LISTENER` (config property: `inter.broker.listener.name`)
- `CONTROLLER_LISTENER_NAMES`: Default: `CONTROLLER` (config property: `controller.listener.names`)
- `LISTENERS`: Default: `CONTROLLER://:19092,BROKER_LISTENER://:19093,LOCAL://:9092,EXTERNAL://:9093` (config
  property: `listeners`)
- `ADVERTISED_LISTENERS`: (config property: `advertised.listeners`)
    - For docker, default: `BROKER_LISTENER://broker-$NODE_ID:19093,LOCAL://localhost:9092,EXTERNAL://localhost:9093`
    - For Kubernetes,
      default: `BROKER_LISTENER://kafka-$NODE_ID.$SERVICE.$NAMESPACE.svc.cluster.local:19093,LOCAL://localhost:9092,EXTERNAL://localhost:9093`
- `LISTENER_SECURITY_PROTOCOL_MAP`:
  Default: `CONTROLLER:PLAINTEXT,BROKER_LISTENER:PLAINTEXT,LOCAL:PLAINTEXT,EXTERNAL:PLAINTEXT` (config
  property: `listener.security.protocol.map`)
- See others in the [config_setup.sh](docker%2Fconfig_setup.sh)

### Authors:

* Konstantine Dvalishvili 

