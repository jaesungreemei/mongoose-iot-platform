# mongoose-iot-platform
MongooseAI IoT Data Streaming Platform

# How to Use (Client)

## (1) API Specification

### 1. Base Endpoint

`http://121.184.96.123:8012/api`

This base endpoint serves as the root for accessing various resources and actions related to machine data querying and management.

### 2. Available Endpoints

#### 2.1 /data

Allows querying machine data based on machine IDs, date, time range, and specific values.

- Method: `GET`
- Query Parameters:
    - `date` (required): Date in YYYYMMDD format.
    - `machines` (optional): Comma-separated list of machine IDs or 'all' for all machines. Default is 'all'.
    - `start_time` (optional): Start time in HHMMSS format. Must be used in conjunction with end_time.
    - `end_time` (optional): End time in HHMMSS format.
    - `data_columns` (optional): Comma-separated list of data columns to return or 'all' for all columns. Default is 'all'.
- Success Response:
    - **Code**: 200 OK
    - **Content**: List of objects containing the requested data.
- Error Response:
    - **Code**: 400 Bad Request (if required parameters are missing or invalid)
    - **Content**: { "error": "Invalid request parameters" }, { "error": "Invalid data columns in query. Please check your query parameters." }

#### 2.2 /machines

Provides access to machine-specific operations, such as listing all machines or retrieving specific machine details.

- Method: `GET`
- Success Response:
    - **Code**: 200 OK
    - **Content**: List of all machines or details of a specific machine.

#### 2.3 /data_columns

Allows querying available data columns, which can be used in the /data/query endpoint.

- Method: `GET`
- Success Response:
    - **Code**: 200 OK
    - **Content**: List of all available data columns.

### 3. Request Example

```bash
# 특정 날짜 전체 machine 데이터 조회
GET /api/data?date=20240215

# 특정 날짜, 특정 machine 데이터 조회
GET /api/data?machines=100&date=20240215

# 특정 날짜, 특정 machine, 특정 구간 데이터 조회
GET /api/data?machines=100&date=20240215&start_time=180000&end_time=185959

# 특정 날짜, 특정 machines, 특정 values 조회
GET /api/data?machines=100,200,400&date=20240215&data_columns=value1,value5,value8

# 전체 machine list 조회
GET /api/machines

# 전체 data column list 조회
GET /api/data_columns
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
python3 -m venv "iot-venv"

# Linux or macOS:
source iot-venv/bin/activate

# Windows:
iot-venv\Scripts\activate

pip install -r requirements.txt
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

# Installing, this may take a few minutes...에서 멈출 시, 엔터 눌러야 함
# Ubuntu 20.04 로그인 되었으면, exit 입력
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
sudo apt update
sudo apt install dos2unix

cd mongoose-iot-platform

# DOS/Windows 시스템에서 사용하는 줄바꿈 문자를 UNIX/Linux 시스템의 줄바꿈 문자로 전환
dos2unix */*.sh
```

```bash
bash 2-wsl-init-scripts/run-init.sh

# run-init.sh 내부:
# 1-init.sh
# 2-init-kafka.sh
# 3-init-cassandra.sh
# 4-init-kafka-connect.sh

# 중간 중간에 ip configuration 직접 입력해야 함

[Kafka] Enter the IP address for advertised.listeners configuration:
121.184.96.123
[Kafka] Enter the port for advertised.listeners configuration:
8092
[Cassandra] Enter the IP address for broadcast_rpc_address configuration:
121.184.96.123
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

# producer.pid: 백그라운드로 돌아가는 producer pid
# kill -9 $(pid)
```

## (5) [WSL] Deploy API

```bash
bash 5-deploy-api/run-deploy-api.sh

# api_server.pid: 백그라운드로 돌아가는 api server pid
# kill -9 $(pid)
```
