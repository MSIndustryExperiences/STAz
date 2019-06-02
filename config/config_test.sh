echo "LOADING CONFIG"

CUSTOMER_NAME="sytrue"
LOCATION="westus2" # the region where you want to deploy resources
VM_ADMIN_UID="cheri"

PREFIX="$CUSTOMER_NAME-01" #prepended to resources

# Networking
VNET_NAME="$PREFIX-vnet"
VNET_IP="10.1.0.0/16"

ADMIN_SUBNET_NAME="$PREFIX-admin-subnet"
ADMIN_SUBNET_IP="10.1.1.0/24"

WORKER_SUBNET_NAME="$PREFIX-worker-subnet"
WORKER_SUBNET_IP="10.1.2.0/24"

RESOURCE_GROUP_NAME="$PREFIX-rg"