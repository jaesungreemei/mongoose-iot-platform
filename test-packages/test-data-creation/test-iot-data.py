import time
import random
from confluent_kafka import Producer

# ---------------------------------------------------------------- #
# Kafka Configurations

KAFKA_BOOTSTRAP_SERVERS = 'localhost:9092'

def delivery_report(err, msg):
    if err is not None:
        print('Message delivery failed: {}'.format(err))
    else:
        print('Message delivered to {} [{}]'.format(msg.topic(), msg.partition()))

# ---------------------------------------------------------------- #
# Data Generation

def generate_data():
    timestamp = time.strftime('%Y%m%d%H%M%S')
    random_long_number = random.randint(1, 1000000)
    return f'{timestamp},{random_long_number}'

def generate_data():
    timestamp = time.strftime('%Y%m%d%H%M%S')
    random_long_number = random.randint(1, 1000000)
    return f'{timestamp},{random_long_number}'

def produce_data(producer, topic):
    try:
        while True:
            data = generate_data()
            producer.produce(topic, value=data, callback=delivery_report)
            producer.flush()  # Flush to ensure the message is delivered immediately
            time.sleep(1)  # Wait for 1 second

    except KeyboardInterrupt:
        pass  # Allow the script to be interrupted by Ctrl+C

# ---------------------------------------------------------------- #
def main():
    producer_conf = {
        'bootstrap.servers': KAFKA_BOOTSTRAP_SERVERS,
        'client.id': 'python-producer'
    }

    # Create Kafka producer
    producer = Producer(producer_conf)

    # Kafka topic
    kafka_topic = 'iot-raw-data'

    try:
        # Produce data to Kafka indefinitely with a 1-second lag
        produce_data(producer, kafka_topic)
    finally:
        # Close Kafka producer in case of interruption
        producer.close()

if __name__ == "__main__":
    main()
