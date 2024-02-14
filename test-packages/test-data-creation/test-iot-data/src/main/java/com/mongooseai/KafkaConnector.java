package com.mongooseai;

import org.apache.kafka.clients.producer.KafkaProducer;
import org.apache.kafka.clients.producer.Producer;
import org.apache.kafka.clients.producer.ProducerRecord;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Properties;
import java.util.Random;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

public class KafkaConnector 
{

    // Setup Logging
    private static final Logger logger = LogManager.getLogger(KafkaConnector.class);

    public static Producer<String, String> createKafkaProducer(String bootstrapServers) {
        Properties properties = new Properties();
        properties.put("bootstrap.servers", bootstrapServers);
        properties.put("key.serializer", "org.apache.kafka.common.serialization.StringSerializer");
        properties.put("value.serializer", "org.apache.kafka.common.serialization.StringSerializer");

        Producer<String, String> producer = new KafkaProducer<>(properties);
        return producer;
    }

    public static void produceData(Producer<String, String> producer, String topic, int delayTime) throws InterruptedException {
        try {
            while (true) {
                String data = generateData();
                ProducerRecord<String, String> record = new ProducerRecord<>(topic, data);
                producer.send(record, (metadata, exception) -> {
                    if (exception == null) {
                        logger.info(String.format("[Message sent to topic=%s, partition=%d, offset=%d%n] %s", metadata.topic(), metadata.partition(), metadata.offset(), data));
                        System.out.printf("[Message sent to topic=%s, partition=%d, offset=%d%n] %s",metadata.topic(), metadata.partition(), metadata.offset(), data);
                    } else {
                        exception.printStackTrace();
                    }
                });

                Thread.sleep(delayTime);
            }
        } finally {
            producer.close();
        }
    }

    public static String generateData() {
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyyMMddHHmmss");
        String timestamp = dateFormat.format(new Date());

        Random random = new Random();
        long randomLong = random.nextLong();

        return timestamp + "," + randomLong;
    }
}
