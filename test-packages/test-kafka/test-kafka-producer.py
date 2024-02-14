from confluent_kafka import Producer

def delivery_report(err, msg):
    if err is not None:
        print('Message delivery failed: {}'.format(err))
    else:
        print('Message delivered to {} [{}]'.format(msg.topic(), msg.partition()))

producer_conf = {
    'bootstrap.servers': 'localhost:9092',
    'client.id': 'python-producer'
}

producer = Producer(producer_conf)

for i in range(5):
    message = 'Hello Kafka! Message {}'.format(i)
    producer.produce('test-topic', value=message, callback=delivery_report)

producer.flush()
