#!/bin/bash

# while getopts "a:b:" arg; do
#   case $arg in
#     a) private=$OPTARG;;
#     b) public=$OPTARG;;
#     c) link=$OPTARG;;
#   esac
# done
# echo "Private PKC: $private";
# echo "Public PKC: $public";
# echo "Cluster Linking: $link";

PUBLIC_DESTINATION_PKC_ID="pkc-devcj890w2"
PRIVATE_DESTINATION_PKC_ID=""
CMD_COUNT_KAFKA_POD="kubectl get pods -n ${PUBLIC_DESTINATION_PKC_ID} | grep -v 'healthcheck' | grep "kafka-" | wc -l"
CMD_EXEC_GET_LAG="kubectl -n ${PUBLIC_DESTINATION_PKC_ID} exec -it kafka-$i -- /bin/bash -c 'curl -s http://localhost:7778/metrics | grep kafka_server_cluster_link_metrics_mirror_topic_lag'"

num_of_pods=$(eval "$CMD_COUNT_KAFKA_POD")

for ((i = 0; i < num_of_pods; i++)); do
    # echo "Executing to kafka pod with $CMD_EXEC_GET_LAG"
    output=$(eval "$CMD_EXEC_GET_LAG")
    filtered_output=$(echo "$output" | grep -o 'tenant=.*' | grep -v 'healthcheck') 
    echo "$filtered_output" >> lags.txt
done