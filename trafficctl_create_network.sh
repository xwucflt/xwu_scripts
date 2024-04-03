## Set region and cloud.
CLOUD="AWS"   ## e.g "AWS"
REGION="us-gov-east-1"  ## e.g "us-west-2"
NETWORK_NAME="public-network-confluent-04-02" ## e.g public-network-confluent-<date>
REALM="087359091383" ## cc-us-gov-infra-data-plane-1 /  e.g. GCP:cc-prod-1/AWS:050879227952

network=$(trafficctl --ccloud infra-us-gov networking network create \
  --cloud "${CLOUD}" \
  --env t0 \
  --name "${NETWORK_NAME}" \
  --region "${REGION}" \
  --connection PUBLIC \
  --realm "${REALM}" \
  --enable-regional-static-egress true \
  --needs-static-egress-edge true \ ## remove this flag for Azure and GCP networks as they do not support it yet
| jq -r '.network')
echo "${network}"
nid=$(echo "${network}" | jq -r '.meta.id')
