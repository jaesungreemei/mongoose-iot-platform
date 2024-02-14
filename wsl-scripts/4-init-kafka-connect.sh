#!/bin/bash

# 저장소 공개 키 추가를 위한 패키지 설치
sudo apt install apt-transport-https

# 저장소의 공개 키 추가
echo "Adding Cassandra repository keys..."
wget -q -O - https://www.apache.org/dist/cassandra/KEYS | sudo apt-key add -

# Cassandra 공식 저장소 추가
echo "Adding Cassandra repository..."
echo "deb http://www.apache.org/dist/cassandra/debian 311x main" | sudo tee -a /etc/apt/sources.list.d/cassandra.sources.list

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
echo "Configuring cluster_name..."
sudo sed -i "s/cluster_name: 'Test Cluster'/cluster_name: 'IoT-Platform'/g" $CASSANDRA_CONFIG

# listen_address 설정 변경
# 클러스터 내부 통신을 위한 주소이기 때문에, localhost로 유지함
# echo "Configuring listen_address..."
# sudo sed -i '/^listen_address:/c\listen_address: 0.0.0.0' $CASSANDRA_CONFIG

# rpc_address 설정 변경
# 클라이언트 요청을 수신하는 데 사용되는 IP 주소
# localhost로 하면, localhost에서만 접속 가능
echo "Configuring rpc_address..."
sudo sed -i '/^rpc_address:/c\rpc_address: 0.0.0.0' $CASSANDRA_CONFIG

# broadcast_rpc_address 주석 해제 및 설정 변경
echo "Configuring broadcast_rpc_address..."
read -p "Enter the IP address for broadcast_rpc_address configuration: " broadcast_rpc_ip
sudo sed -i "/^# broadcast_rpc_address:/c\broadcast_rpc_address: $broadcast_rpc_ip" $CASSANDRA_CONFIG

# Cassandra 서비스 재시작
echo "Restarting Cassandra service..."
sudo systemctl start cassandra

echo "Cassandra installation and configuration completed."