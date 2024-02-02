package com.mongooseai;

import org.apache.kafka.clients.producer.Producer;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

public class App 
{

    // Kafka Variables
    private static final String KAFKA_BOOTSTRAP_SERVERS = "localhost:9092";
    private static final String KAFKA_TOPIC = "iot-raw-data";
    private static final int DELAY_TIME_MS = 1000;

    // Setup Logging
    private static final Logger logger = LogManager.getLogger(App.class);

    public static void main( String[] args )
    {
        logger.info("Starting application... ");

        // (Step 1) Connect to Kafka Producer
        Producer<String, String> producer = KafkaConnector.createKafkaProducer(KAFKA_BOOTSTRAP_SERVERS);
        logger.info("Connected to Kafka Producer.");

        // (Step 2) Add Shutdown Hook
        Runtime.getRuntime().addShutdownHook(new Thread(producer::close));
        logger.info("Added Shutdown Hook.");

        // Produce Data
        try {
            KafkaConnector.produceData(producer, "iot-raw-data", DELAY_TIME_MS);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }

    }
}
