#!/bin/bash

KAFKA_DIR="/opt/kafka_2.13-3.6.1"

$KAFKA_DIR/bin/kafka-topics.sh --create --topic iot-platform-1 --bootstrap-server localhost:9092
