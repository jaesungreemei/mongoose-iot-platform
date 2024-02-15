#!/bin/bash
# 스크립트 실행 시 오류 발생 시 중단
set -e
# 스크립트 파일들의 경로 배열
scripts=(
    "3-wsl-create-materials-scripts/1-create-topic.sh"
    "3-wsl-create-materials-scripts/2-create-table.sh"
    "3-wsl-create-materials-scripts/3-create-connector.sh"
)
# Unix 스타일의 줄바꿈으로 변환 및 스크립트 실행
for script in "${scripts[@]}"; do
    sed -i 's/\r$//' "$script" # Windows 줄바꿈(CR) 제거
    bash "$script"             # 스크립트 실행
done
echo "[3-create-materials-scripts] All scripts executed successfully."
