echo "LOADING CONFIG"

LOCATION="westus2" # the region where you want to deploy resources

CUSTOMER_NAME="sytrue"

PREFIX="ec01-$CUSTOMER_NAME" #prepended to resources

RESOURCE_GROUP_NAME="$PREFIX-rg"

VNET_NAME="$PREFIX-test-vnet"

VM_ADMIN_UID="cheri"

