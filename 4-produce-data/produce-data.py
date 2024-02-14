import json
import time
from datetime import datetime
import random
from kafka import KafkaProducer

# Kafka Producer 설정
producer = KafkaProducer(bootstrap_servers=['localhost:9092'],
                         key_serializer=str.encode,
                         value_serializer=lambda m: json.dumps(m).encode('ascii'))

cnt = 0

while True:
    # 현재 시간 및 날짜
    now = datetime.now()
    day = now.strftime("%Y%m%d")
    current_time = now.strftime("%H%M%S")

    for machine in range(100, 1000, 100):
        # 메시지 생성
        message = {
            "day": int(day),
            "time": int(current_time),
            "machine": machine,
            "value1": round(random.random(), 4),
            "value2": round(random.random(), 4),
            "value3": round(random.random(), 4),
            "value4": round(random.random(), 4),
            "value5": round(random.random(), 4),
            "value6": round(random.random(), 4),
            "value7": round(random.random(), 4),
            "value8": round(random.random(), 4),
            "value9": round(random.random(), 4),
        }

        # 메시지를 'iot-platform-1' 토픽으로 produce
        producer.send('iot-platform-1', key=str(machine), value=message)
        producer.flush()
        
        cnt += 1
        if cnt % 100 == 0:
            print(f"Produced {cnt} messages.")
            print(f"message: {message}")

    time.sleep(1)  # 1초 대기