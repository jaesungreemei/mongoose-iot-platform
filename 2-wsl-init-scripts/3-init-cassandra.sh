#!/bin/bash

# 저장소 공개 키 추가를 위한 패키지 설치
sudo apt install apt-transport-https

# Cassandra 공식 저장소 추가
echo "Adding Cassandra repository..."
echo "deb https://debian.cassandra.apache.org 40x main" | sudo tee -a /etc/apt/sources.list.d/cassandra.sources.list

# 저장소의 공개 키 추가
echo "Adding Cassandra repository keys..."
curl https://downloads.apache.org/cassandra/KEYS | sudo apt-key add -

# 패키지 목록 업데이트
echo "Updating package list..."
sudo apt-get update

# Cassandra 설치
echo "Installing Cassandra..."
sudo apt-get install -y cassandra


# Cassandra 설정 수정
echo "Configuring Cassandra Config..."
CASSANDRA_CONFIG="/etc/cassandra/cassandra.yaml"

sudo systemctl stop cassandra
sudo rm -rf /var/lib/cassandra/data/*
sudo rm -rf /var/lib/cassandra/commitlog/*
sudo rm -rf /var/lib/cassandra/saved_caches/*


# cluster_name 설정 변경
echo "[Cassandra] Configuring cluster_name..."
sudo sed -i "s/cluster_name: 'Test Cluster'/cluster_name: 'IoT-Platform'/g" $CASSANDRA_CONFIG

# listen_address 설정 변경
# 클러스터 내부 통신을 위한 주소이기 때문에, localhost로 유지함
# echo "Configuring listen_address..."
# sudo sed -i '/^listen_address:/c\listen_address: 0.0.0.0' $CASSANDRA_CONFIG

# rpc_address 설정 변경
# 클라이언트 요청을 수신하는 데 사용되는 IP 주소
# localhost로 하면, localhost에서만 접속 가능
echo "[Cassandra] Configuring rpc_address..."
sudo sed -i '/^rpc_address:/c\rpc_address: 0.0.0.0' $CASSANDRA_CONFIG

# broadcast_rpc_address 주석 해제 및 설정 변경
echo "[Cassandra] Configuring broadcast_rpc_address..."
read -p "[Cassandra] Enter the IP address for broadcast_rpc_address configuration: " broadcast_rpc_ip
sudo sed -i "/^# broadcast_rpc_address:/c\broadcast_rpc_address: $broadcast_rpc_ip" $CASSANDRA_CONFIG




echo "[Cassandra] Enabling authentication..."
# authenticator 설정 변경
sudo sed -i "s/authenticator: AllowAllAuthenticator/authenticator: PasswordAuthenticator/g" $CASSANDRA_CONFIG
echo "[Cassandra] Authentication enabled successfully."



# jna 설정
echo "[Cassandra] Configuring jna-5.14.0..."
wget -O /tmp/jna-5.14.0.jar https://repo1.maven.org/maven2/net/java/dev/jna/jna/5.14.0/jna-5.14.0.jar
sudo mv /tmp/jna-5.14.0.jar /usr/share/cassandra/lib


CASSANDRA_ENV_CONFIG="/etc/cassandra/cassandra-env.sh"

# MAX_HEAP_SIZE 설정
echo "[Cassandra] Configuring MAX_HEAP_SIZE..."
sudo sed -i '/^#MAX_HEAP_SIZE="4G"/c\MAX_HEAP_SIZE="4G"' $CASSANDRA_ENV_CONFIG

# HEAP_NEWSIZE 설정
echo "[Cassandra] Configuring HEAP_NEWSIZE..."
sudo sed -i '/^#HEAP_NEWSIZE="800M"/c\HEAP_NEWSIZE="512M"' $CASSANDRA_ENV_CONFIG

echo "[Cassandra] Configuration update complete."


JVM_OPTIONS_FILE="/etc/cassandra/jvm-server.options"

# -Xms와 -Xmx 설정 업데이트
echo "[Cassandra] Updating -Xms and -Xmx to 4G..."
sudo sed -i 's/^#-Xms4G/-Xms4G/' $JVM_OPTIONS_FILE
sudo sed -i 's/^#-Xmx4G/-Xmx4G/' $JVM_OPTIONS_FILE

# -Xmn 설정 업데이트
echo "[Cassandra] Updating -Xmn to 400M..."
sudo sed -i 's/^#-Xmn800M/-Xmn400M/' $JVM_OPTIONS_FILE

echo "[Cassandra] JVM options update complete."

echo "JVM options configuration complete."

# Cassandra 서비스 재시작
echo "Restarting Cassandra service..."
sudo systemctl start cassandra

echo "Cassandra installation and configuration completed."