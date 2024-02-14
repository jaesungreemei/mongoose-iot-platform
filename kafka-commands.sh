# Start Zookeeper
.\bin\windows\zookeeper-server-start.bat .\config\zookeeper.properties

# Start Kafka
.\bin\windows\kafka-server-start.bat .\config\server.properties

# Create Topic
.\bin\windows\kafka-topics.bat --create --topic iot-raw-data --bootstrap-server localhost:9092 --partitions 1 --replication-factor 1
.\bin\windows\kafka-topics.bat --list --bootstrap-server localhost:9092

# Produce Messages
.\bin\windows\kafka-console-producer.bat --topic iot-raw-data --bootstrap-server localhost:9092

# Consume Messages
.\bin\windows\kafka-console-consumer.bat --topic iot-raw-data --bootstrap-server localhost:9092 --from-beginning
