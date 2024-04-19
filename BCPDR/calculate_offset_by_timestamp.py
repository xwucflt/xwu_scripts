from kafka import TopicPartition, KafkaConsumer
import time

def get_offset_for_timestamp(bootstrap_servers, topic, timestamp_ms):
    consumer = KafkaConsumer(bootstrap_servers=bootstrap_servers, api_version=(2,0,2), consumer_timeout_ms=1000)
    offsets = {}
    try:
        topics = consumer.topics()
        print("Available topics:", topics)
    except Exception as e:
        print("Error:", e)
    partitions = consumer.partitions_for_topic(topic)
    print(partitions)
    for partition in range(6):
        tp = TopicPartition(topic, partition)
        print(tp)
        offsets[partition] = consumer.offsets_for_times({tp: timestamp_ms})
        print("done")

    consumer.close()
    # admin_client.close()
    return offsets

if __name__ == "__main__":
    # Kafka bootstrap servers
    bootstrap_servers = 'localhost:9092'

    # Kafka topic
    topic = 'lkc-devc5v75dn_mirror_sample_data'

    # Timestamp (in milliseconds since epoch)
    timestamp_ms = 1713503069000  # current time

    # Calculate offset based on timestamp
    offsets = get_offset_for_timestamp(bootstrap_servers, topic, timestamp_ms)
    
    print("Offsets for timestamp {}: ".format(timestamp_ms))
    for partition_id, offset_and_timestamp in offsets.items():
        offset_info = offset_and_timestamp[0]
        offset = offset_info.offset if offset_info else "N/A"
        print(f"Partition {partition_id}: Offset {offset}")
