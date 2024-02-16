#!/bin/bash

PID_FILE="5-deploy-api/api_server.pid"

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

# 가상 환경 생성 (이미 존재하는 경우 건너뜀)
python3 -m venv $VENV_DIR

# 가상 환경 활성화
source $VENV_DIR/bin/activate

# Flask 실행할 애플리케이션 파일 경로 지정
export FLASK_APP=5-deploy-api/api.py

echo "Starting the API server in the background..."

# API 스크립트를 백그라운드에서 실행하고 로그를 파일로 저장
nohup flask run --host=0.0.0.0 --port=9012 > 5-deploy-api/api_server.log 2>&1 &

echo $! > 5-deploy-api/api_server.pid

echo "API server is running. Logs are being written to 5-deploy-api/api_server.log"
echo "API server PID is saved to 5-deploy-api/api_server.pid"

# 가상 환경 비활성화
deactivate
