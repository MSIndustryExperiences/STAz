echo "LOADING CONFIG"

CUSTOMER_NAME="st"
LOCATION="eastus" # the region where you want to deploy resources
VM_ADMIN_UID="centos"

PREFIX="dms-$CUSTOMER_NAME-10" #prepended to resources

# Networking

VNET_NAME="$PREFIX-vnet"
VNET_IP="10.2.0.0/16"

ADMIN_SUBNET_NAME="$PREFIX-paw-subnet"
ADMIN_SUBNET_IP="10.2.1.0/24"

WORKER_SUBNET_NAME="$PREFIX-worker-subnet"
WORKER_SUBNET_IP="10.2.2.0/24"

GATEWAY_SUBNET_NAME="$PREFIX-gw-subnet"
GATEWAY_SUBNET_IP="10.2.3.0/24"

RESOURCE_GROUP_NAME="$PREFIX-rg"