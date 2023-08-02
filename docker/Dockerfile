FROM openjdk:17-bullseye


ARG kafkaversion=3.3.1
ARG scalaversion=2.13
ARG kafkaurl=https://archive.apache.org/dist/kafka/$kafkaversion/kafka_${scalaversion}-${kafkaversion}.tgz
WORKDIR /app

RUN apt update \
    && apt install -y --no-install-recommends wget \
    && wget ${kafkaurl} -O kafka.tgz \
    && tar xvzf kafka.tgz \
    && mv kafka_${scalaversion}-${kafkaversion} kafka \
    && rm kafka.tgz


WORKDIR /app/kafka

COPY ./server.properties .
COPY ./entrypoint.sh .

RUN chmod +x entrypoint.sh

ENTRYPOINT [ "./entrypoint.sh" ]
