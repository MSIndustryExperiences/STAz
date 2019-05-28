echo "LOADING CONFIG"

CUSTOMER_NAME="sytrue"

LOCATION="westus2" # the region where you want to deploy resources

PREFIX="01-$CUSTOMER_NAME" #prepended to resources

RESOURCE_GROUP_NAME="$PREFIX-rg"

VM_ADMIN_UID="cheri"

VNET_NAME="$PREFIX-test-vnet"