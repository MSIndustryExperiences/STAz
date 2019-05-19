echo "LOADING CONFIG"

CUSTOMER_NAME="customerA"

LOCATION="westus" # the region where you want to deploy resources

PREFIX="st-$CUSTOMER_NAME" #prepended to resources

RESOURCE_GROUP_NAME="$PREFIX-rg"

VNET_NAME_TEST=$PREFIX-test-vnet
VNET_NAME_POC=$PREFIX-poc-vnet
VNET_NAME_ENG=$PREFIX-eng-vnet

VM_ADMIN_UID="hsimpson"

# network definitions



