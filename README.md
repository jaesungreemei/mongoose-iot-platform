# mongoose-iot-platform
MongooseAI IoT Data Streaming Platform

# TODO
- JAVA Backend 만들기
- API 명세서 작성
- Realtime API 만들기

# How to Use

```
curl "http://121.184.96.123:8012/data?machine=100&day=20240214"
```

# How to Install

## (1) [Windows] WSL Install & Configuration

1. Windows 컴퓨터에 git clone

    ```
    git clone git@github.com:Mongoose-AI/mongoose-iot-platform.git
    ```

2. WSL 설치 스크립트 실행 (컴퓨터 자동 재부팅)

    ```
    # powershell 관리자 권한 실행
    .\1-windows-scripts\1-wsl-install.ps1
    ```

3. WSL 포트 포워딩 및 windows 방화벽 설정

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

4. 공유기 포트포워딩 (시작점)

    Windows ipconfig -> 이더넷 어댑터 이더넷:기본 게이트웨이(172.30.1.254)

    |외부 IP|외부 PORT|내부 IP|내부 PORT|설명|
    |--|--|--|--|--|
    |121.184.96.123|8012|172.30.1.37|9012|wsl-api|
    |121.184.96.123|8042|172.30.1.37|9042|wsl-cassandra|
    |121.184.96.123|8092|172.30.1.37|9092|wsl-kafka|

5. Project Repository Windows -> WSL 내부로 복사

## (2) [WSL] Init & Configuration

```bash
sudo chmod +x 2-wsl-init-scripts/*
sudo chmod +x 3-wsl-prepare-materials-scripts/*
sudo chmod +x 4-produce-data/*
sudo chmod +x 5-deploy-api/*
```

```bash
sudo ./2-wsl-init-scripts/run-init.sh

# run-init.sh 내부:
# 1-init.sh
# 2-init-kafka.sh
# 3-init-cassandra.sh
# 4-init-kafka-connect.sh

# 중간 중간에 ip configuration 직접 입력해야 함
```

## (3) [WSL] Create Materials

```bash
sudo ./3-wsl-create-materials-scripts/run-create-materials.sh

# run-create-materials.sh 내부:
# 1-create-topic.sh
# 2-create-table.sh
# 3-create-connector.sh
```

|Key|Value|
|--|--|
|Kafka Topic|iot-platform-1|
|Cassandra Keyspace|iot_platform|
|Cassandra Table|data_table_1|
|Kafka Connector|iot-platform-sink|
|Kafka Connector Config File|cassandra-sink-connector.json|


```sql
-- Cassandra Table: data_table_1
CREATE TABLE IF NOT EXISTS data_table_1 (
    day int,
    time int,
    machine int,
    value1 float,
    value2 float,
    value3 float,
    value4 float,
    value5 float,
    value6 float,
    value7 float,
    value8 float,
    value9 float,
    PRIMARY KEY ((day, machine), time)
) WITH CLUSTERING ORDER BY (time DESC)
```

## (4) [WSL] Produce Data

```bash
sudo ./4-produce-data/run-produce-data.sh

# producer_pid: 백그라운드로 돌아가는 producer pid
# sudo kill $(pid)
```

## (5) [WSL] Deploy API

```bash
sudo ./5-deploy-api/run-deploy-api.sh

# api_server_pid: 백그라운드로 돌아가는 api server pid
# sudo kill $(pid)
```