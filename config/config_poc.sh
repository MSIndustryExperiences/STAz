echo "LOADING CONFIG"

LOCATION="westus" # the region where you want to deploy resources

CUSTOMER_NAME="customer"

PREFIX="st-$CUSTOMER_NAME" #prepended to resources

RESOURCE_GROUP_NAME="$PREFIX-rg"

VNET_NAME="$PREFIX-poc-vnet"

VM_ADMIN_UID="cheri"