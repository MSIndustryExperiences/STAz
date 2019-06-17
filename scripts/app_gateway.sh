create_app_gateway() {

    local private_ip=$1
    local public_ip_name="$PREFIX-gw-pip"

    echo "CREATING GATEWAY"

    az network application-gateway create \
        --capacity 2 \
        --frontend-port 80 \
        --http-settings-cookie-based-affinity Enabled \
        --http-settings-port 80 \
        --http-settings-protocol Http \
        --location $LOCATION \
        --name "$PREFIX-gw" \
        --private-ip-address $private_ip \
        --public-ip-address-allocation Static \
        --resource-group $RESOURCE_GROUP_NAME \
        --servers "10.2.2.10" "10.2.2.11" "10.2.2.12" \
        --sku Standard_Medium \
        --subnet $GATEWAY_SUBNET_NAME \
        || (echo "FAILED TO CREATE GATEWAY: $PREFIX-gw" && exit 1)

    echo "az network public-ip show"
    az network public-ip show \
        --resource-group $RESOURCE_GROUP_NAME \
        --name $public_ip_name \
        --query [ipAddress] \
        --output tsv

    echo "CREATED GATEWAY"
}
