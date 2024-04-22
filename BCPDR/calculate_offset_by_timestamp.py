from kafka import TopicPartition, KafkaConsumer
import time
import sys
import json

def build_consumer(): 
    return KafkaConsumer(bootstrap_servers=config['bootstrap_servers'], 
                             security_protocol=config['security_protocol'],
                             sasl_mechanism=config['sasl_mechanism'],
                             sasl_plain_username=config['sasl_plain_username'],
                             sasl_plain_password=config['sasl_plain_password'],
                             api_version=(2,0,2), 
                             consumer_timeout_ms=1000)

def get_offset_for_timestamp(topic, timestamp_ms):
    consumer = build_consumer()
    offsets = {}
    try:
        topics = consumer.topics()
        print("Available topics:", topics)
    except Exception as e:
        print("Error:", e)
    partitions = consumer.partitions_for_topic(topic)
    print(f"Reading offsets from the following partitions {partitions}")
    for partition in partitions:
        tp = TopicPartition(topic, partition)
        offsets[partition] = consumer.offsets_for_times({tp: timestamp_ms})

    consumer.close()
    return offsets

def find_target_message(topic, m_partition, m_offest):
    consumer = build_consumer()
    topic_partition = TopicPartition(topic, m_partition)
    consumer.assign([topic_partition])
    consumer.seek(topic_partition, m_offest)

    # Read one message from the specified offset
    consumer.poll(timeout_ms=1000)
    for message in consumer:
        print(f"Message from topic {topic} from partition {m_partition} at offset {m_offest}: {message}")
        break
    consumer.close()

if __name__ == "__main__":
    with open('config.json') as f:
        config = json.load(f)
    print("Configuration loaded:")
    print(config)

    topic = config['topic']
    timestamp_ms = config['target_timestamp']

    # Calculate offset based on timestamp
    offsets = get_offset_for_timestamp(topic, timestamp_ms)
    
    last_message_timestamp = sys.maxsize
    last_massage_partition = -1
    last_message_offset = -1
    print("Offsets for timestamp {}: ".format(timestamp_ms))
    for partition_id, offset_and_timestamp in offsets.items():
        print(partition_id, offset_and_timestamp)
        offset_info = offset_and_timestamp[TopicPartition(topic, partition_id)]
        offset = offset_info.offset if offset_info else "N/A"
        if (offset_info.timestamp <= last_message_timestamp):
            last_massage_partition = partition_id
            last_message_offset = offset
            last_message_timestamp = offset_info.timestamp
        print(f"Partition {partition_id}: Offset {offset}")
    if (last_massage_partition != -1 and last_message_offset != -1):
        print("Last message at partition {} offset {} at timestamp {}".format(last_massage_partition, last_message_offset, last_message_timestamp))
    else:
        print("Error partition or offset equal to -1")

    # poll the target message and find replay window left boundary
    find_target_message(topic, last_massage_partition, last_message_offset)