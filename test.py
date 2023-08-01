from velikafkaclient.producer import KafkaEventProducer
from velikafkaclient.topicmanager import KafkaTopicManager

# while True:
#     text = input()

 # kafka-topics.sh --describe \
 #   --topic test \
 #   --bootstrap-server localhost:9092

"""
localhost:9092
./kafka-topics.sh --describe   --topic test --bootstrap-server localhost:9092
./kafka-topics.sh --bootstrap-server localhost:9092 --create --replication-factor 1 --partitions 3 --topic test

./kafka-console-consumer.sh --topic test1 --bootstrap-server localhost:9092 --group test-consumers --from-beginning
./kafka-console-producer.sh --topic test1 --broker-list localhost:9092

kafka-consumer-groups.sh --bootstrap-server localhost:9092 --reset-offsets --group test-consumers --topic test --to-earliest
kafka-topics.sh --bootstrap-server localhost:9092 --delete --topic test
kafka-topics.sh --bootstrap-server localhost:9092 --list
./kafka-topics.sh --bootstrap-server localhost:9092 --list

./kafka-topics.sh --bootstrap-server localhost:9092 --create --replication-factor 1 --partitions 1 --topic test1

./kafka-broker-api-versions.sh --bootstrap-server localhost:9092

"""



# producer = KafkaEventProducer('localhost:9092')
# producer.produce_easy_event('test', {'yes': 'yooo'})
#
manager = KafkaTopicManager('localhost:9092')
manager.create_topic('test', 1, 2)
print(manager.list_topics())
