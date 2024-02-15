#!/bin/bash

# 가상 환경 디렉토리 설정
VENV_DIR="iot-venv"

# 가상 환경 활성화
source $VENV_DIR/bin/activate

cd realtime-api
python realtime-api.py --folder-name test1 --machine all

deactivate
cd ..