## Highly available Kafka with Kraft

### How to build and run for docker (in the `docker` directory):

* build docker image: `docker build -t kafka .`
* run `docker compose up`

If you want to run multiple brokers, add `broker-1` and `broker-2` services
in the docker compose, set `NODE_ID` to 1 and 2 accordingly

### How to build and run for kubernetes (in the `kubernetes` directory):

Important: You'll need to build the docker image on the OS which you have on your kube nodes !!!
You'll also need container image registry account (https://hub.docker.com/)

* login to your image registry: `docker login`
* build docker image: `docker build -t {your-username}/kafka .`
* push docker image: `docker push -t {your-username/kafka .`
* run in kubernetes `kubectl apply -f kafka.yml`

Current configuration runs 3 kafka brokers, adjust `kafka.yml` file
to your needs

### Kafka configuration:

Supported env variables:
* STORAGE_DIR: directory for saving logs, default: `/mtn`
* CLUSTER_ID: cluster id, default: `oh-sxaDRTcyAr6pFRbXyzA`, this variable must be same for all nodes
* NODE_ID: node id, default: `0`, each node must have unique node id, starting from 0 (config property: `node.id`)
* REPLICAS: number of replicas, default: '1', number of nodes in the cluster, this variable must be same for all nodes
* INTER_BROKER_LISTENER_NAME: default `BROKER_LISTENER` (config property: `inter.broker.listener.name`)
* CONTROLLER_LISTENER_NAMES: default `CONTROLLER` (config property: `controller.listener.names`)
* LISTENERS: default `CONTROLLER://:19092,BROKER_LISTENER://:19093,LOCAL://:9092,EXTERNAL://:9093` (config property: `listeners`)
* ADVERTISED_LISTENERS: (config property: `advertised.listeners`) default:
  * For docker: `BROKER_LISTENER://broker-$NODE_ID:19093,LOCAL://localhost:9092,EXTERNAL://localhost:9093` 
  * For kubernetes: `BROKER_LISTENER://kafka-$NODE_ID.$SERVICE.$NAMESPACE.svc.cluster.local:19093,LOCAL://localhost:9092,EXTERNAL://localhost:9093`
* LISTENER_SECURITY_PROTOCOL_MAP: default `CONTROLLER:PLAINTEXT,BROKER_LISTENER:PLAINTEXT,LOCAL:PLAINTEXT,EXTERNAL:PLAINTEXT` (config property: `listener.security.protocol.map`)
* more coming soon ...


### Authors:

Konstantine Dvalishvili

