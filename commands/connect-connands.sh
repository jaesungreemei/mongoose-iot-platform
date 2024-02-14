curl http://localhost:8083/connectors

curl -X POST -H "Content-Type: application/json" --data @/home/seok/local-iot-platform/3-wsl-create-materials-scripts/cassandra-sink-connector.json http://localhost:8083/connectors

curl http://localhost:8083/connectors/iot-platform-sink/status

curl -X DELETE http://localhost:8083/connectors/iot-platform-sink

"key.converter": "org.apache.kafka.connect.storage.StringConverter",
"value.converter": "org.apache.kafka.connect.json.JsonConverter",
"value.converter.schemas.enable": "false",