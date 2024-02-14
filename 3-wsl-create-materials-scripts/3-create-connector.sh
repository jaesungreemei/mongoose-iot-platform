#!/bin/bash

echo "Creating the Cassandra Sink Connector..."

curl -X POST -H "Content-Type: application/json" --data @/home/seok/local-iot-platform/3-wsl-create-materials-scripts/cassandra-sink-connector.json http://localhost:8083/connectors

echo "Cassandra Sink Connector created successfully."