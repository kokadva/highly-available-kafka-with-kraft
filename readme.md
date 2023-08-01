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

### Authors:

Konstantine Dvalishvili

