from confluent_kafka import Consumer, KafkaError, TopicPartition
import time

# Kafka topic and timestamp
topic = "mirror_sample_data"
timestamp_ms = int(time.time() * 1000)  # current time in milliseconds

# Kafka consumer configuration
conf = {
    'bootstrap.servers': 'localhost:9092',
    'group.id': 'my_consumer_group',
    'auto.offset.reset': 'earliest'
}

# Create Kafka consumer
consumer = Consumer(conf)

# Seek to timestamp
tp = TopicPartition(topic, 0)
consumer.assign([tp])
offset = consumer.offsets_for_times({tp: timestamp_ms})[tp].offset
consumer.seek(tp, offset)

# Consume messages
try:
    while True:
        msg = consumer.poll(1.0)
        if msg is None:
            continue
        if msg.error():
            if msg.error().code() == KafkaError._PARTITION_EOF:
                continue
            else:
                print(msg.error())
                break
        print('Received message: {}'.format(msg.value().decode('utf-8')))
except KeyboardInterrupt:
    pass
finally:
    consumer.close()
