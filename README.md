# mongoose-iot-platform
MongooseAI IoT Data Streaming Platform

# How to Use (Client)

## (1) API Specification

### 1. Endpoint

`http://121.184.96.123:8012/api/data/query`

This endpoint allows querying data based on machine IDs, date, time range, and specific columns.

### 2. Method: `GET`

### 3. Query Parameters

- `machines` (optional): Comma-separated list of machine IDs or 'all' for all machines. Default is 'all'.
- `date` (required): Date in YYYYMMDD format.
- `start_time` (optional): Start time in HHMMSS format. Must be used in conjunction with `end_time`.
- `end_time` (optional): End time in HHMMSS format.
- `columns` (optional): Comma-separated list of data columns to return or 'all' for all columns. Default is 'all'.

### 4. Success Response

- **Code**: 200 OK
- **Content**: List of objects containing the requested data.

### 5. Error Response

- **Code**: 400 Bad Request (if required parameters are missing or invalid)
- **Content**: { "error": "Invalid request parameters" }

### 6.Example

- Request

    ```bash
    curl "http://121.184.96.123:8012/api/data/query?machine=100&date=20240215&start_time=093000&end_time=095959"
    ```

- Response

    ```json
    []
    ```

## (2) Realtime API

### 1. Endpoint Configuration

Make sure to replace '121.184.96.123:8092' with the address of your Kafka broker and 'iot-platform-1' with the name of your Kafka topic.

```python
# realtime-api/realtime-api.py

KAFKA_ENDPOINT = '121.184.96.123:8092'
KAFKA_TOPIC = 'iot-platform-1'
```

### 2. Environment Setup

```bash
# Linux or macOS:
source iot-venv/bin/activate

# Windows:
iot-venv\Scripts\activate
```

### 3. Run Realtime API

Script takes two main arguments: --folder-name for specifying the directory where the data will be saved, and --machine for specifying the machine ID to filter messages by.

```bash
cd realtime-api

# To consume messages from all machines and save the data in a folder named dataFolder
python realtime-api.py --folder-name dataFolder --machine all

# To consume messages from a specific machine, replace all with the machine ID:
python realtime-api.py --folder-name dataFolder --machine 100
```

### 4. Data Storage Structure

The script will save the data in CSV files within the specified directory (data/dataFolder). Files are named according to the timestamp, for example, 2024-02-12.05.csv for messages received during the 5 AM hour on February 12, 2024. Each file contains a header followed by the message data, structured as follows:

```
date,time,machine,value1,value2,value3,value4,value5,value6,value7,value8,value9
```

# How to Install (Server)

## (1) [Windows] WSL Install & Configuration

###  1. Windows 컴퓨터에 git clone

```
git clone git@github.com:Mongoose-AI/mongoose-iot-platform.git
```

### 2. WSL 설치 스크립트 실행 (컴퓨터 자동 재부팅)

```
# powershell 관리자 권한 실행
.\1-windows-scripts\1-wsl-install.ps1
```

### 3. WSL 포트 포워딩 및 windows 방화벽 설정

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

### 4. 공유기 포트포워딩 (시작점)

Windows ipconfig -> 이더넷 어댑터 이더넷:기본 게이트웨이(172.30.1.254)

|외부 IP|외부 PORT|내부 IP|내부 PORT|설명|
|--|--|--|--|--|
|121.184.96.123|8012|172.30.1.37|9012|wsl-api|
|121.184.96.123|8042|172.30.1.37|9042|wsl-cassandra|
|121.184.96.123|8092|172.30.1.37|9092|wsl-kafka|

### 5. Project Repository Windows -> WSL 내부로 복사

## (2) [WSL] Init & Configuration

```bash
bash 2-wsl-init-scripts/run-init.sh

# run-init.sh 내부:
# 1-init.sh
# 2-init-kafka.sh
# 3-init-cassandra.sh
# 4-init-kafka-connect.sh

# 중간 중간에 ip configuration 직접 입력해야 함
```

## (3) [WSL] Create Materials

```bash
bash 3-wsl-create-materials-scripts/run-create-materials.sh

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
    date int,
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
    PRIMARY KEY ((date, machine), time)
) WITH CLUSTERING ORDER BY (time DESC)
```

## (4) [WSL] Produce Data

```bash
bash 4-produce-data/run-produce-data.sh

# producer_pid: 백그라운드로 돌아가는 producer pid
# kill -9 $(pid)
```

## (5) [WSL] Deploy API

```bash
bash 5-deploy-api/run-deploy-api.sh

# api_server_pid: 백그라운드로 돌아가는 api server pid
# kill -9 $(pid)
```