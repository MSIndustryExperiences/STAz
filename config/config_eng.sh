echo "LOADING CONFIG"

CUSTOMER_NAME="st-eng"
LOCATION="eastus" # the region where you want to deploy resources
VM_ADMIN_UID="centos"

PREFIX="$CUSTOMER_NAME" #prepended to resources

# Networking

VNET_NAME="$PREFIX-vnet"
VNET_IP="10.2.0.0/16"

ADMIN_SUBNET_NAME="$PREFIX-paw-subnet"
ADMIN_SUBNET_IP="10.2.1.0/24"

WORKER_SUBNET_NAME="$PREFIX-worker-subnet"
WORKER_SUBNET_IP="10.2.2.0/24"

GATEWAY_SUBNET_NAME="$PREFIX-gateway"
GATEWAY_SUBNET_IP="10.2.3.0/24"

RESOURCE_GROUP_NAME="$PREFIX-rg"