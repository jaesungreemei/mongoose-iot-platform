# Kafka
sudo less /opt/kafka_2.13-3.6.1/logs/server.log

sudo systemctl status kafka
sudo systemctl restart kafka

sudo journalctl -u kafka
sudo journalctl -fu kafka

# Cassandra
sudo less /var/log/cassandra/system.log

sudo systemctl status cassandra
sudo systemctl restart cassandra

sudo journalctl -u cassandra
sudo journalctl -fu cassandra

# Kafka-Connect

sudo less /opt/kafka_2.13-3.6.1/logs/connect.log

sudo systemctl status kafka-connect
sudo systemctl restart kafka-connect

sudo journalctl -u kafka-connect
sudo journalctl -fu kafka-connect
