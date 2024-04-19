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

CMD_COUNT_KAFKA_POD="kubectl get pods -n pkc-devcq8jovm | grep -v 'healthcheck' | grep "kafka-" | wc -l"
num_of_pods=$(eval "$CMD_COUNT_KAFKA_POD")

CUTOVER_TIME_MILI=1718442000000
seconds=$((CUTOVER_TIME_MILI / 1000))
dr_utc_time=$(date -u -d @"$seconds" +'%Y-%m-%dT%H:%M:%S.%3NZ')
echo "Cutover Time is: $dr_utc_time"

link_name="Link_0",topic="mirror_topic_1",} 0.0

for ((i = 0; i < num_of_pods; i++)); do
    CMD_EXEC_GET_LAG="kubectl -n pkc-devcq8jovm exec -it kafka-$i -- /bin/bash -c 'curl -s http://localhost:7778/metrics | grep kafka_server_cluster_link_metrics_mirror_topic_lag'"
    # echo "Executing to kafka pod with $CMD_EXEC_GET_LAG"
    output=$(eval "$CMD_EXEC_GET_LAG")
    # echo "$output"
    # | grep -oE '[0-9]+([.][0-9]+)?' | tail -n 1
    filtered_output=$(echo "$output" | grep -o 'link_name="Link_0".*' | grep -v 'healthcheck')
    echo "$filtered_output"
done


# Example Raw Topics: <private-lkc-id>__events.<db_table>.<table>
# lkc-kno1v6__events.atlas.certificate
# lkc-kno1v6__events.cc_control_plane_kafka.kafka_quota
# lkc-kno1v6__events.cc_kafka_api_service.kafka_quota
# lkc-kno1v6__events.deployment.account
# lkc-kno1v6__events.deployment.api_key_v2
# lkc-kno1v6__events.deployment.deployment
# lkc-kno1v6__events.deployment.events_heartbeat
# lkc-kno1v6__events.deployment.k8s_cluster
# lkc-kno1v6__events.deployment.logical_cluster
# lkc-kno1v6__events.deployment.org_membership
# lkc-kno1v6__events.deployment.organization
# lkc-kno1v6__events.deployment.physical_cluster
# lkc-kno1v6__events.deployment.realm
# lkc-kno1v6__events.deployment.region
# lkc-kno1v6__events.deployment.secret
# lkc-kno1v6__events.deployment.users
# lkc-kno1v6__events.deployment.zone
# lkc-kno1v6__events.mothershipdb
# lkc-kno1v6__events.rollout_service_events.phase_state_transition
# lkc-kno1v6__events.rollout_service_events.rollout_state_transition
# lkc-kno1v6__events.upgrader_events.task_state_transition

# Resource tables <private-lkc-id>_events.<app>
# lkc-kno1v6_events.account
# lkc-kno1v6_events.account_json
# lkc-kno1v6_events.apikey
# lkc-kno1v6_events.apikey.v3
# lkc-kno1v6_events.catalog.backing
# lkc-kno1v6_events.catalog.temp
# lkc-kno1v6_events.cdmum.dump
# lkc-kno1v6_events.certificate
# lkc-kno1v6_events.client_quota
# lkc-kno1v6_events.clusterlink.network
# lkc-kno1v6_events.data_catalog_source
# lkc-kno1v6_events.deactivate-org
# lkc-kno1v6_events.deployment
# lkc-kno1v6_events.flink-catalog-account
# lkc-kno1v6_events.flink_catalog_logical_cluster
# lkc-kno1v6_events.flink_catalog_organization
# lkc-kno1v6_events.flink_catalog_physical_cluster
# lkc-kno1v6_events.flink_catalog_topic_metadata
# lkc-kno1v6_events.k8s_cluster
# lkc-kno1v6_events.kafka.allowed_network
# lkc-kno1v6_events.logical_cluster
# lkc-kno1v6_events.logical_cluster_json
# lkc-kno1v6_events.logical_cluster_v2
# lkc-kno1v6_events.network_link_endpoint
# lkc-kno1v6_events.obelisk.privatelinkattachmentconnections
# lkc-kno1v6_events.org.lifecycle
# lkc-kno1v6_events.org_membership
# lkc-kno1v6_events.organization
# lkc-kno1v6_events.organization_billing
# lkc-kno1v6_events.organization_json
# lkc-kno1v6_events.physical_cluster
# lkc-kno1v6_events.physical_cluster_json
# lkc-kno1v6_events.physical_cluster_v2
# lkc-kno1v6_events.product_package
# lkc-kno1v6_events.rbac
# lkc-kno1v6_events.rbac.apikey
# lkc-kno1v6_events.rbac.logical_cluster
# lkc-kno1v6_events.realm
# lkc-kno1v6_events.region
# lkc-kno1v6_events.sds.rbac
# lkc-kno1v6_events.sr_config
# lkc-kno1v6_events.stream_catalog
# lkc-kno1v6_events.stream_catalog.backing
# lkc-kno1v6_events.stream_catalog.connect_backingc
# lkc-kno1v6_events.stream_catalog_control_plane.backing
# lkc-kno1v6_events.stream_catalog_flink.backing
# lkc-kno1v6_events.traffic_logical_cluster
# lkc-kno1v6_events.traffic_physical_cluster
# lkc-kno1v6_events.users
# lkc-kno1v6_events.zone


# Routing examples: <lck-id>_events.<pkc>.app
# lkc-xmnp5k_events.pkc-devc97950m.apikey
# lkc-xmnp5k_events.pkc-devc97950m.cc-cluster-link-network
# lkc-xmnp5k_events.pkc-devc97950m.cc-dump
# lkc-xmnp5k_events.pkc-devc97950m.logical_cluster
# lkc-xmnp5k_events.pkc-devc97950m.product_package
# lkc-xmnp5k_events.pkc-devc97950m.rbac
# lkc-xmnp5k_events.pkc-devc97950m.sr_config
# lkc-xmnp5k_events.pkc-devc97950m.stream_catalog
# ....
# ....