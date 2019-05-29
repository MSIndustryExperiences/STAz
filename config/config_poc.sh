echo "LOADING CONFIG"

CUSTOMER_NAME="sytrue"
LOCATION="westus2" # the region where you want to deploy resources
VM_ADMIN_UID="cheri"

PREFIX="poc-$CUSTOMER_NAME" #prepended to resources
ADMIN_SUBNET="$PREFIX-admin-subnet"
RESOURCE_GROUP_NAME="$PREFIX-rg"
VNET_NAME="$PREFIX-vnet"
WORKER_SUBNET="$PREFIX-worker-subnet"
