#!/bin/bash

# Configurations
IS_PUBLIC_CLUSTER=true
PUBLIC_CLUSTER_BOOTSTRAP_SERVER="pkc-devcxrx5yk.us-west-2.aws.devel.cpdev.cloud:9092"
CUTOVER_TIME_MILI=1713824486945
PUBLIC_CLUSTER_TOPIC="sample_data"
PRIVATE_CLUSTER_TOPIC="lkc-devc1oj7wj_sample_data"
if $IS_PUBLIC_CLUSTER; then
    CMD_GET_OFFSETS_BY_TIMESTAMP="/bin/bash -c 'sh kafka-get-offsets.sh --bootstrap-server $PUBLIC_CLUSTER_BOOTSTRAP_SERVER --command-config public-consumer.config --topic $PUBLIC_CLUSTER_TOPIC --time $CUTOVER_TIME_MILI'"
else
    CMD_GET_OFFSETS_BY_TIMESTAMP="/bin/bash -c 'sh kafka-get-offsets.sh --bootstrap-server localhost:9071 --topic $PRIVATE_CLUSTER_TOPIC --time $CUTOVER_TIME_MILI'"
if
# Read partition/offset pairs from a timestamp
output=$(eval "$CMD_GET_OFFSETS_BY_TIMESTAMP")
echo $output

# Iterate all offsets and fetch the latest message
min_value=0
while IFS= read -r line; do
    p=$(echo "$line" | cut -d':' -f2)
    # kafka-get-offsets.sh --time will return the smallest offset >= the timestamp, we want to give some buffer space so minus one offset to make sure the message never pass the cutover time
    ((o=$(echo "$line" | cut -d':' -f3)-1))
    if $IS_PUBLIC_CLUSTER; then
        CMD_GET_MESSAGE_BY_PARTITION_OFFSET="/bin/bash -c 'sh kafka-console-consumer.sh --bootstrap-server $PUBLIC_CLUSTER_BOOTSTRAP_SERVER --consumer.config public-consumer.config --topic $PUBLIC_CLUSTER_TOPIC --partition $p --offset $o --max-messages 1'"
    else
        CMD_GET_MESSAGE_BY_PARTITION_OFFSET="/bin/bash -c 'sh kafka-console-consumer.sh --bootstrap-server localhost:9071 --topic $PRIVATE_CLUSTER_TOPIC --partition $p --offset $o --max-messages 1'"
    fi
    message=$(eval "$CMD_GET_MESSAGE_BY_PARTITION_OFFSET")
    ts_ms=$(echo "$message" | jq -r '.ts_ms')

    # find the message with max ts_ms among all partitions before cutover time
    if ((ts_ms >= min_value)); then
        min_value=$ts_ms
        window_left_boundary=$(echo "$message" | jq -r '.after.modified')
    fi
done <<< "$output"
echo  $min_value
echo "Replay Window: [ $window_left_boundary  $CUTOVER_TIME_MILI ]"