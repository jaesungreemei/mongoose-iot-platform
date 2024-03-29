#!/bin/bash

echo "Restart Cassandra service..."
sudo systemctl restart cassandra
sleep 15

echo "Creating Cassandra user 'mongoose'..."
# Cassandra의 기본 사용자(예: cassandra)로 cqlsh에 로그인하여 새 사용자 생성

CQL="CREATE ROLE IF NOT EXISTS mongoose WITH PASSWORD = '200305' AND LOGIN = true AND SUPERUSER = true;"
echo $CQL | cqlsh -u cassandra -p cassandra

echo "User 'mongoose' created successfully."

# Cassandra 'cassandra' 기본 사용자 삭제
DELETE_CASSANDRA_USER="DROP ROLE cassandra;"
echo $DELETE_CASSANDRA_USER | cqlsh -u mongoose -p 200305

echo "Cassandra default user 'cassandra' has been deleted."

# 가상 환경 디렉토리 설정
VENV_DIR="iot-venv"

# 가상 환경 활성화
source $VENV_DIR/bin/activate

# make-table.py 실행
python3 3-wsl-create-materials-scripts/make-table.py

# 가상 환경 비활성화
deactivate
