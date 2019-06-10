create_app_gateway() {

    local private_ip=$1
    local pip_name=$2

    echo "CREATING PUBLIC IP FOR GW"

    az network public-ip create \
        --name $public_ip_name \
        --resource-group $RESOURCE_GROUP_NAME \
        --location $LOCATION \
        --allocation-method Static \
        --sku Standard

    echo "CREATING GATEWAY"

    az network application-gateway create \
        --resource-group $RESOURCE_GROUP_NAME \
        --capacity 2 \
        --frontend-port 80 \
        --http-settings-cookie-based-affinity Enabled \
        --http-settings-port 80 \
        --http-settings-protocol Http \
        --location $LOCATION \
        --name "$PREFIX-gw" \
        --private-ip-address $pip_name \
        --public-ip-address public_ip_name
        --public-ip-address-allocation Static \
        --servers "10.2.2.10" "10.2.2.11" "10.2.2.17" "10.2.2.18" \
        --sku Standard_v2 \
        --subnet $GATEWAY_SUBNET_NAME \
        --vnet-name $VNET_NAME \
        || (echo "FAILED TO CREATE GATEWAY: $PREFIX-gw" && exit 1)

    echo "CREATED GATEWAY"       
}