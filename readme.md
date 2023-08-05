[![Docker Image build/push](https://github.com/kokadva/highly-available-kafka-with-kraft/actions/workflows/docker-image.yml/badge.svg)](https://github.com/kokadva/highly-available-kafka-with-kraft/actions/workflows/docker-image.yml)

## Highly available Kafka with KRaft mode on Kubernetes

This repository contains the Dockerfiles and Kubernetes configuration files for running Highly available Kafka in
KRaft mode in kubernetes. KRaft (Kafka Raft metadata mode), is a mode where Kafka runs without ZooKeeper.

## Kafka Version

The current Kafka version used is `3.3.1`.

## Public docker images:

* Docker image for Kubernetes `kokadva/kafka-kraft-kube`
* Docker image for docker-compose: `kokadva/kafka-kraft-compose` 

## Pre-requisites

- Docker
- Kubernetes
- Container Image registry account (Optional)

### How to build and run for docker-compose (resources in the `docker/docker-compose` directory):

* build docker image: `docker build -t kafka .`
* run `docker compose up`

If you want to run multiple brokers, add `broker-1`, `broker-2` etc. to the services in docker compose and adjust env
variables accordingly.

### How to build and run for kubernetes (resources in the `docker/kubernetes` directory):

* If you don't want to build the image yourself you can use mine: `kokadva/kafka-kraft-kube`

Important: You'll need to build the docker image on the OS which you have on your kube nodes !!!
You'll also need container image registry account

* login to your image registry: `docker login`
* build docker image: `docker build -t {your-username}/kafka .`
* push docker image: `docker push -t {your-username/kafka .`
* run in kubernetes `kubectl apply -f kafka.yml` (adjust configuration to your needs)

This process will run 3 kafka nodes in kubernetes cluster. To test it you can ssh into one of your kafka nodes:

* `kubectl exec -it kafka-0 -- /bin/bash`

Go to `/app/kafka/bin` directory and use kafka commands which can be listed by
running [kafka_commands.py](kafka_commands.py)

### Kafka configuration:

Supported env variables:

* `NODE_ID`: node id, default: `0`, each node must have unique node id, starting from 0 (config property: `node.id`)
* `STORAGE_DIR`: directory for saving logs, default: `/mtn` (actual logs will be saved in `STORAGE_DIR`/`NODE_ID`
  directory)
* `CLUSTER_ID`: cluster id, default: `oh-sxaDRTcyAr6pFRbXyzA`, this variable must be same for all nodes
* `REPLICAS`: number of replicas, default: '1', number of nodes in the cluster, this variable must be same for all nodes
* `INTER_BROKER_LISTENER_NAME`: default `BROKER_LISTENER` (config property: `inter.broker.listener.name`)
* `CONTROLLER_LISTENER_NAMES`: default `CONTROLLER` (config property: `controller.listener.names`)
* `LISTENERS`: default `CONTROLLER://:19092,BROKER_LISTENER://:19093,LOCAL://:9092,EXTERNAL://:9093` (config
  property: `listeners`)
* `ADVERTISED_LISTENERS`: (config property: `advertised.listeners`) default:
    * For docker: `BROKER_LISTENER://broker-$NODE_ID:19093,LOCAL://localhost:9092,EXTERNAL://localhost:9093`
    * For
      kubernetes: `BROKER_LISTENER://kafka-$NODE_ID.$SERVICE.$NAMESPACE.svc.cluster.local:19093,LOCAL://localhost:9092,EXTERNAL://localhost:9093`
* `LISTENER_SECURITY_PROTOCOL_MAP`:
  default `CONTROLLER:PLAINTEXT,BROKER_LISTENER:PLAINTEXT,LOCAL:PLAINTEXT,EXTERNAL:PLAINTEXT` (config
  property: `listener.security.protocol.map`)
* more coming soon ...


### Authors:

* Konstantine Dvalishvili 

