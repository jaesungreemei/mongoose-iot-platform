#!/bin/bash

# 스크립트 실행 전에 API 서버를 종료하기 위한 코드
# 저장된 PID 파일을 읽어서 해당 PID의 프로세스를 종료
pid=$(<4-produce-data/producer_pid)
sudo kill $pid

# 가상 환경 디렉토리 설정
VENV_DIR="iot-venv"

# 가상 환경 생성 (이미 존재하는 경우 건너뜀)
python3 -m venv $VENV_DIR

# 가상 환경 활성화
source $VENV_DIR/bin/activate

# 필요한 패키지 설치
pip install kafka-python

echo "Starting the Kafka producer script in the background..."

# Python 스크립트를 백그라운드에서 실행하고 로그를 파일로 저장
nohup python3 4-produce-data/produce-data.py > 4-produce-data/data_producer.log 2>&1 &

echo $! > 4-produce-data/producer_pid

echo "Producer script is running. Logs are being written to 4-produce-data/data_producer.log"
echo "Producer PID is saved to 4-produce-data/producer_pid"

# 가상 환경 비활성화
deactivate