#!/bin/bash

echo "Creating Cassandra user 'mongoose'..."
# Cassandra의 기본 사용자(예: cassandra)로 cqlsh에 로그인하여 새 사용자 생성

# 가상 환경 비활성화
deactivate

CQL="CREATE ROLE IF NOT EXISTS mongoose WITH PASSWORD = '200305' AND LOGIN = true AND SUPERUSER = true;"
echo "$CQL" | cqlsh -u cassandra -p cassandra

echo "User 'mongoose' created successfully."

# 가상 환경 디렉토리 설정
VENV_DIR="iot-venv"

# 가상 환경 생성 (이미 존재하는 경우 건너뜀)
python3 -m venv $VENV_DIR

# 가상 환경 활성화
source $VENV_DIR/bin/activate

# 필요한 패키지 설치
pip install cassandra-driver

# make-table.py 실행
python3 3-wsl-prepare-materials-scripts/make-table.py

# 가상 환경 비활성화
deactivate
