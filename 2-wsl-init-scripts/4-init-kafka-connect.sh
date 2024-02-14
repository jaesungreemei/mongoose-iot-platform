#!/bin/bash

echo "Starting Kafka Connect configuration and setup..."

# Kafka Connect의 설치 경로
KAFKA_DIR="/opt/kafka_2.13-3.6.1"
echo "Kafka installation directory is set to $KAFKA_DIR."

# Kafka Connect의 설정 파일 경로
CONNECT_CONFIG="$KAFKA_DIR/config/connect-distributed.properties"

# key.converter를 StringConverter로 변경
echo "Updating key.converter to StringConverter..."
sudo sed -i 's/key.converter=org.apache.kafka.connect.json.JsonConverter/key.converter=org.apache.kafka.connect.storage.StringConverter/g' $CONNECT_CONFIG

# plugin.path 설정 변경
echo "Setting plugin.path to $KAFKA_DIR/connectors..."
sudo sed -i "s|^#plugin.path=.*|plugin.path=${KAFKA_DIR}/connectors|g" $CONNECT_CONFIG

echo "connect-distributed.properties has been updated successfully."


echo "Downloading and installing Cassandra Connect connector..."

wget -O /tmp/kafka-connect-cassandra-sink.tar.gz "https://downloads.datastax.com/kafka/kafka-connect-cassandra-sink.tar.gz"
sudo mkdir -p "$KAFKA_DIR/connectors"
sudo tar -xzvf /tmp/kafka-connect-cassandra-sink.tar.gz -C $KAFKA_DIR
sudo rm /tmp/kafka-connect-cassandra-sink.tar.gz
sudo cp $KAFKA_DIR/kafka-connect-cassandra-sink-1.4.0/kafka-connect-cassandra-sink-1.4.0.jar $KAFKA_DIR/connectors

echo "Cassandra Connect connector has been installed successfully."


echo "Creating Kafka Connect service file..."

# Kafka Connect 서비스 파일 경로
SERVICE_FILE="/etc/systemd/system/kafka-connect.service"

# Kafka Connect 서비스 파일 생성 및 구성
cat <<EOF | sudo tee $SERVICE_FILE
[Unit]
Description=Kafka Connect
Requires=network.target
After=network.target

[Service]
Type=simple
ExecStart=$KAFKA_DIR/bin/connect-distributed.sh $CONNECT_CONFIG
User=$(whoami)
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF
echo "Kafka Connect service file has been created successfully."

# Kafka Connect 서비스 시작
echo "Starting Kafka Connect service..."

sudo systemctl daemon-reload
sudo systemctl enable kafka-connect
sudo systemctl start kafka-connect

echo "Kafka Connect service has started successfully."

echo "Kafka Connect with Cassandra Connect has been configured and started in distributed mode."