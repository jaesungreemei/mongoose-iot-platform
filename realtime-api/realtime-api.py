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
    """Parse command line arguments"""
    
    parser = argparse.ArgumentParser(description='Kafka Consumer to save filtered messages into CSV files.')
    parser.add_argument('--folder-name', required=True, help='The name of the folder to store the CSV files.')
    parser.add_argument('--machine', default='all', help='The machine ID to filter the messages. Use "all" to get messages from all machines.')
    
    return parser.parse_args()


def setup_data_folder(data_folder):
    """Set up the data folder"""
    
    data_path = f"data/{data_folder}"
    if os.path.exists(data_path):
        print("Error: Folder already exists.")
        sys.exit(1)
    else:
        os.makedirs(data_path)
        
    return data_path


def create_consumer():
    """Configure Kafka Consumer"""
    
    consumer = KafkaConsumer(
        KAFKA_TOPIC,
        bootstrap_servers=[KAFKA_ENDPOINT],
        auto_offset_reset='latest',
        value_deserializer=lambda m: json.loads(m.decode('ascii')))
    
    return consumer


def save_message_to_csv(message, file_path):
    """Save a single message to a CSV file"""
    
    fieldnames = ['day', 'time', 'machine', 'value1', 'value2', 'value3', 'value4', 'value5', 'value6', 'value7', 'value8', 'value9']
    file_exists = os.path.isfile(file_path)
    
    with open(file_path, mode='a', newline='') as file:
        writer = csv.DictWriter(file, fieldnames=fieldnames)
        
        if not file_exists:
            writer.writeheader()
            
        writer.writerow(message)
        file.flush()


def consume_messages(consumer, data_path, machine_id):
    """Consume Kafka messages and save to file, split by time period"""
    
    current_hour = None
    counter = 0
    
    for message in consumer:
        message_value = message.value
        
        if machine_id.lower() == 'all' or str(message_value['machine']) == machine_id:
            now = datetime.now()
            message_hour = now.strftime("%Y-%m-%d.%H")
            file_path = os.path.join(data_path, f"{message_hour}.csv")
            if current_hour != message_hour:
                current_hour = message_hour
                
            save_message_to_csv(message_value, file_path)
            counter += 1
            
            print_progress(counter)
            
    sys.stdout.write("\n")


def print_progress(iteration):
    """Print progress bar while saving data"""
    
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
