#!/bin/bash

PID_FILE="4-produce-data/producer.pid"

# PID 파일이 존재하는지 확인
if [ -f "$PID_FILE" ]; then
    # 파일이 존재하면, PID를 읽고 해당 프로세스를 종료
    pid=$(<$PID_FILE)
    echo "Killing process with PID $pid..."
    kill -9 $pid
    
    # 종료 메시지 출력
    if [ $? -eq 0 ]; then
        echo "Process $pid has been successfully terminated."
    else
        echo "Failed to terminate process $pid."
    fi
else
    # 파일이 없으면, 사용자에게 메시지를 출력
    echo "$PID_FILE does not exist. Skipping process termination."
fi
# 가상 환경 디렉토리 설정
VENV_DIR="iot-venv"

# 가상 환경 활성화
source $VENV_DIR/bin/activate

echo "Starting the Kafka producer script in the background..."

# Python 스크립트를 백그라운드에서 실행하고 로그를 파일로 저장
nohup python3 4-produce-data/produce-data.py > 4-produce-data/data_producer.log 2>&1 &

echo $! > 4-produce-data/producer.pid

echo "Producer script is running. Logs are being written to 4-produce-data/data_producer.log"
echo "Producer PID is saved to 4-produce-data/producer.pid"

# 가상 환경 비활성화
deactivate