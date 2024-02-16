#!/bin/bash

# Initial setup for Ubuntu
echo "Updating package lists and installing necessary packages..."
sudo apt-get update && sudo apt-get upgrade -y
sudo apt-get install -y curl wget net-tools git openjdk-8-jdk
echo "Package installation completed."


# 환경 변수 설정
echo "Applying environment variables..."
echo 'export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64' >> ~/.bashrc
echo 'export PATH=$PATH:$JAVA_HOME/bin' >> ~/.bashrc
source ~/.bashrc

sudo apt install -y python3-venv

# 가상 환경 디렉토리 설정
VENV_DIR="iot-venv"
python3 -m venv $VENV_DIR

source $VENV_DIR/bin/activate
pip install -r requirements.txt
deactivate

# git config --global user.email seok990301@gmail.com
# git config --global user.name seok0301
# git config --global core.editor "vim"

# Enable systemd for WSL2
# echo "Enable systemd for WSL2..."
# sudo -b unshare --pid --fork --mount-proc /lib/systemd/systemd --system-unit=basic.target
# sudo -E nsenter --all -t $(pgrep -xo systemd) runuser -P -l $USER -c "exec $SHELL"

echo "Initialization completed."