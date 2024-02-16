/opt/kafka_2.13-3.6.1/bin/zookeeper-server-start.sh /opt/kafka_2.13-3.6.1/config/zookeeper.properties
/opt/kafka_2.13-3.6.1/bin/kafka-server-start.sh /opt/kafka_2.13-3.6.1/config/server.properties

/opt/kafka_2.13-3.6.1/bin/kafka-topics.sh --create --topic temp-topic3 --bootstrap-server localhost:9092
/opt/kafka_2.13-3.6.1/bin/kafka-console-producer.sh --topic temp-topic1 --bootstrap-server localhost:9092
/opt/kafka_2.13-3.6.1/bin/kafka-console-consumer.sh --topic iot-platform-1 --bootstrap-server localhost:9092

/opt/kafka_2.13-3.6.1/bin/kafka-topics.sh --list --bootstrap-server localhost:9092

/opt/kafka_2.13-3.6.1/bin/kafka-console-consumer.sh --topic iot-platform-1 --bootstrap-server localhost:9092
/opt/kafka_2.13-3.6.1/bin/kafka-topics.sh --delete --topic iot-platform-1 --bootstrap-server localhost:9092