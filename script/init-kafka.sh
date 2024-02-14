#!/bin/bash

# (1-1) Download kafka from web and extract Kafka
KAFKA_URL="https://downloads.apache.org/kafka/3.6.1/kafka_2.13-3.6.1.tgz"
KAFKA_DIR="/opt/kafka_2.13-3.6.1"

echo "Downloading Kafka from $KAFKA_URL..."
if command -v curl &> /dev/null; then
    curl -o /tmp/kafka.tgz $KAFKA_URL
else
    wget -O /tmp/kafka.tgz $KAFKA_URL
fi

echo "Extracting Kafka to $KAFKA_DIR..."
mkdir -p $KAFKA_DIR
tar -xzf /tmp/kafka.tgz -C /opt
mv /opt/kafka_2.13-3.6.1/* $KAFKA_DIR

# (1-2) or Install Kafka offline 
# KAFKA_DIR="/opt/kafka_2.13-3.6.1"


# (2) Prompt user for IP and port for advertised.listeners
echo "Configuring listeners and advertised.listeners in server.properties..."
read -p "Enter the IP address for advertised.listeners configuration: " listener_ip
read -p "Enter the port for advertised.listeners configuration: " listener_port

# (3) Update server.properties with listener configurations
echo "listeners=PLAINTEXT://0.0.0.0:9092" >> $KAFKA_DIR/config/server.properties
echo "advertised.listeners=PLAINTEXT://$listener_ip:$listener_port" >> $KAFKA_DIR/config/server.properties

# (4) Check if UFW is active
UFW_STATUS=$(sudo ufw status verbose | grep "Status: active")

if [ -n "$UFW_STATUS" ]; then
    echo "Configuring firewall to allow traffic on Kafka port 9092..."
    sudo ufw allow 9092/tcp
else
    echo "UFW is inactive. No changes made to firewall rules."
fi

# (5) Create Zookeeper service file
echo "Creating Zookeeper service file..."
cat <<EOF | sudo tee /etc/systemd/system/zookeeper.service
[Unit]
Description=Apache Zookeeper server
Documentation=http://zookeeper.apache.org
Requires=network.target
After=network.target

[Service]
Type=simple
ExecStart=$KAFKA_DIR/bin/zookeeper-server-start.sh $KAFKA_DIR/config/zookeeper.properties
ExecStop=$KAFKA_DIR/bin/zookeeper-server-stop.sh
Restart=on-abnormal

[Install]
WantedBy=multi-user.target
EOF

# (6) Create Kafka service file
echo "Creating Kafka service file..."
cat <<EOF | sudo tee /etc/systemd/system/kafka.service
[Unit]
Description=Apache Kafka Server
Documentation=http://kafka.apache.org/documentation.html
Requires=zookeeper.service
After=zookeeper.service

[Service]
Type=simple
ExecStart=/bin/sh -c '$KAFKA_DIR/bin/kafka-server-start.sh $KAFKA_DIR/config/server.properties'
ExecStop=$KAFKA_DIR/bin/kafka-server-stop.sh
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

# (7) Reload systemd to apply new service files
echo "Reloading systemd daemon..."
sudo systemctl daemon-reload

# (8) Enable and start Zookeeper service
echo "Enabling and starting Zookeeper service..."
sudo systemctl enable zookeeper.service
sudo systemctl start zookeeper.service

# (9) Enable and start Kafka service
echo "Enabling and starting Kafka service..."
sudo systemctl enable kafka.service
sudo systemctl start kafka.service

echo "Kafka and Zookeeper services are configured to start on boot."

echo "Kafka configuration completed successfully."