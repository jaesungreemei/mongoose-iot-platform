#!/bin/bash
sed -i 's/\r$//' wsl-scripts/1-init.sh
sed -i 's/\r$//' wsl-scripts/2-init-kafka.sh
sed -i 's/\r$//' wsl-scripts/3-init-cassandra.sh
sed -i 's/\r$//' wsl-scripts/4-init-kafka-connect.sh
sed -i 's/\r$//' wsl-scripts/5-init-materials.sh
sudo bash wsl-scripts/1-init.sh
sudo bash wsl-scripts/2-init-kafka.sh
sudo bash wsl-scripts/3-init-cassandra.sh
sudo bash wsl-scripts/4-init-kafka-connect.sh
sudo bash wsl-scripts/5-init-materials.sh