#!/bin/bash

# Initial setup for Ubuntu
echo "Updating package lists and installing necessary packages..."
sudo apt-get update && sudo apt-get upgrade
sudo apt-get install -y curl wget net-tools git openjdk-11-jdk
echo "Package installation completed."


# 환경 변수 설정
echo "Applying environment variables..."
echo 'export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64' >> ~/.bashrc
echo 'export PATH=$PATH:$JAVA_HOME/bin' >> ~/.bashrc
source ~/.bashrc

# Enable systemd for WSL2
# echo "Enable systemd for WSL2..."
# sudo -b unshare --pid --fork --mount-proc /lib/systemd/systemd --system-unit=basic.target
# sudo -E nsenter --all -t $(pgrep -xo systemd) runuser -P -l $USER -c "exec $SHELL"

echo "Initialization completed."