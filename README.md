# mongoose-iot-platform
MongooseAI IoT Data Streaming Platform

# How to Use

-

# How to Install

## (1) [Windows] WSL Install & Configuration

1. Windows 컴퓨터에 git clone

    ```
    git clone git@github.com:Mongoose-AI/mongoose-iot-platform.git
    ```

1. WSL 설치 스크립트 실행 (컴퓨터 자동 재부팅)

    ```
    # powershell 관리자 권한 실행
    .\1-windows-scripts\1-wsl-install.ps1
    ```

2. WSL 포트 포워딩 및 windows 방화벽 설정

    ```
    # powershell 관리자 권한 실행
    .\1-windows-scripts\2-wsl-settings.ps1
    ```

    인바운드 규칙 및 WSL 포트포워딩

    |Windows Port|WSL Port|설명|
    |--|--|--|
    |9012|9012|wsl-api|
    |9042|9042|wsl-cassandra|
    |9092|9092|wsl-kafka|

## (2) 공유기 포트포워딩 (시작점)

Windows ipconfig -> 이더넷 어댑터 이더넷:기본 게이트웨이(172.30.1.254)

|외부 IP|외부 PORT|내부 IP|내부 PORT|설명|
|--|--|--|--|--|
|121.184.96.123|8012|172.30.1.37|9012|wsl-api|
|121.184.96.123|8042|172.30.1.37|9042|wsl-cassandra|
|121.184.96.123|8092|172.30.1.37|9092|wsl-kafka|

## (3) [WSL] Init & Configuration

1. project repo WSL 내부로 복사하기
2. Run Script

    ```bash
    sudo chmod +x 2-wsl-init-scripts/*
    sudo ./2-wsl-init-scripts/run-init.sh

    # run-init.sh 내부:
    # 1-init.sh
    # 2-init-kafka.sh
    # 3-init-cassandra.sh
    # 4-init-kafka-connect.sh

    # 중간 중간에 ip configuration 직접 입력해야 함
    ```

## (4) [WSL] Prepare Materials

1.
