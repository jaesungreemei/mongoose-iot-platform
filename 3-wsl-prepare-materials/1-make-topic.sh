#!/bin/bash

KAFKA_DIR="/opt/kafka_2.13-3.6.1"

/opt/kafka_2.13-3.6.1/bin/kafka-topics.sh --create --topic iot-platform-1 --bootstrap-server 121.184.96.123:8092
