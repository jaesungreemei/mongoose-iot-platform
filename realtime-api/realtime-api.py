import os
import argparse
from kafka import KafkaConsumer
import json
from datetime import datetime
import csv
import sys

KAFKA_ENDPOINT = '121.184.96.123:8092'
KAFKA_TOPIC = 'iot-platform-1'


def parse_arguments():
    """명령줄 인수 처리"""
    
    parser = argparse.ArgumentParser(description='Kafka Consumer to save filtered messages into CSV files.')
    parser.add_argument('--folder-name', required=True, help='The name of the folder to store the CSV files.')
    parser.add_argument('--machine', default='all', help='The machine ID to filter the messages. Use "all" to get messages from all machines.')
    
    return parser.parse_args()


def setup_data_folder(data_folder):
    """데이터 폴더 설정"""
    
    data_path = f"data/{data_folder}"
    if os.path.exists(data_path):
        print("Error: Folder already exists.")
        sys.exit(1)
    else:
        os.makedirs(data_path)
        
    return data_path


def create_consumer():
    """Kafka Consumer 설정"""
    
    consumer = KafkaConsumer(
        KAFKA_TOPIC,
        bootstrap_servers=[KAFKA_ENDPOINT],
        auto_offset_reset='latest',
        value_deserializer=lambda m: json.loads(m.decode('ascii')))
    
    return consumer


def save_message_to_csv(message, file_path):
    """단일 메시지를 CSV 파일에 저장"""
    
    fieldnames = ['day', 'time', 'machine', 'value1', 'value2', 'value3', 'value4', 'value5', 'value6', 'value7', 'value8', 'value9']
    file_exists = os.path.isfile(file_path)
    
    with open(file_path, mode='a', newline='') as file:
        writer = csv.DictWriter(file, fieldnames=fieldnames)
        
        if not file_exists:
            writer.writeheader()  # 파일이 새로 생성될 때만 헤더 작성
            
        writer.writerow(message)
        file.flush()  # 변경 사항을 즉시 디스크에 반영


def consume_messages(consumer, data_path, machine_id):
    """Kafka 메시지 소비 및 파일 저장, 시간대별로 파일 분리"""
    current_hour = None
    counter = 0
    
    for message in consumer:
        message_value = message.value
        
        if machine_id.lower() == 'all' or str(message_value['machine']) == machine_id:
            now = datetime.now()
            message_hour = now.strftime("%Y-%m-%d.%H")
            
            # 현재 시간대에 해당하는 파일 경로 생성
            file_path = os.path.join(data_path, f"{message_hour}.csv")
            
            if current_hour != message_hour:
                # 시간대가 변경되었다면, 현재 시간대를 업데이트
                current_hour = message_hour
                
            # 메시지를 현재 시간대의 파일에 즉시 저장
            save_message_to_csv(message_value, file_path)
            counter += 1
            
            # 프로그레스 바 업데이트
            print_progress(counter)  # 메시지 길이나 다른 적절한 지표로 프로그레스 업데이트
            
    sys.stdout.write("\n")


def print_progress(iteration):
    """데이터 저장 중 프로그레스 바를 출력하는 함수"""
    
    symbols = ['/', '|', '\\', '-']
    sys.stdout.write(f"\rData saving... {symbols[iteration % len(symbols)]}")
    sys.stdout.flush()


def main():
    print("Realtime API Consumer Started.")
    args = parse_arguments()
    data_path = setup_data_folder(args.folder_name)
    consumer = create_consumer()
    consume_messages(consumer, data_path, args.machine)


if __name__ == "__main__":
    main()
