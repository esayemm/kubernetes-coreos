##
# Run this script ONCE per cluster
##

# Pin this script to it's location
parent_path=$( cd "$(dirname "${BASH_SOURCE}")" ; pwd -P )
cd "$parent_path"

ETCD_CLUSTER_SIZE=2
MASTER_CLUSTER_SIZE=1
MINION_CLUSTER_SIZE=2

# Flannel range for docker containers
POD_NETWORK='10.2.0.0/16'
SERVICE_IP_RANGE='10.3.0.0/24'
KUBERNETES_SERVICE_IP='10.3.0.1'
DNS_SERVICE_IP='10.3.0.10'

_ETCD_DISCOVERY_URL=$(curl -s https://discovery.etcd.io/new?size=$ETCD_CLUSTER_SIZE)
ETCD_DISCOVERY_TOKEN=${_ETCD_DISCOVERY_URL##*/}
K8S_VERSION=$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)

CONFIG_PARAMS="{
  \"ETCD_CLUSTER_SIZE\": \"$ETCD_CLUSTER_SIZE\",
  \"ETCD_DISCOVERY_TOKEN\": \"$ETCD_DISCOVERY_TOKEN\",
  \"MASTER_CLUSTER_SIZE\": \"$MASTER_CLUSTER_SIZE\",
  \"MINION_CLUSTER_SIZE\": \"$MINION_CLUSTER_SIZE\",
  \"K8S_VERSION\": \"$K8S_VERSION\",
  \"POD_NETWORK\": \"$POD_NETWORK\",
  \"SERVICE_IP_RANGE\": \"$SERVICE_IP_RANGE\",
  \"KUBERNETES_SERVICE_IP\": \"$KUBERNETES_SERVICE_IP\",
  \"DNS_SERVICE_IP\": \"$DNS_SERVICE_IP\"
}"

echo "Generating config.env..."
echo "$CONFIG_PARAMS"
hbs-templater compile --params "$CONFIG_PARAMS" --input ./config_tpl --output . -l --overwrite
