#!/bin/bash -e
set -e

create_app_gateway() {

    local pip_name="$PREFIX-gw-pip"
    local app_gw_name="$PREFIX-gw"

    echo "az network public-ip create"
    az network public-ip create \
        --resource-group $RESOURCE_GROUP_NAME \
        --name $pip_name \
        --location $LOCATION \
        --allocation-method Static \
        --sku Standard

    echo "az network public-ip show"
    az network public-ip show \
        --name $pip_name \
        --resource-group $RESOURCE_GROUP_NAME

    echo "az network application-gateway create"
    az network application-gateway create \
        --resource-group $RESOURCE_GROUP_NAME \
        --capacity 3 \
        --cert-file "./certs/appgwcert.pfx" \
        --cert-password "password21!!" \
        --frontend-port 443 \
        --http-settings-cookie-based-affinity Enabled \
        --http-settings-port 80 \
        --http-settings-protocol Http \
        --location $LOCATION \
        --name $app_gw_name \
        --public-ip-address $pip_name \
        --public-ip-address-allocation Static \
        --servers "10.2.2.10" "10.2.2.11" "10.2.2.12" \
        --sku Standard_v2 \
        --subnet $GATEWAY_SUBNET_NAME \
        --vnet-name $VNET_NAME ||
        (echo "FAILED TO CREATE GATEWAY: $PREFIX-gw" && exit 1)

    ################################
    # ports
    ################################
    echo "az network application-gateway frontend-port create"
    az network application-gateway frontend-port create \
        --name port80 \
        --resource-group $RESOURCE_GROUP_NAME \
        --gateway-name $app_gw_name \
        --port 80

    echo "az network application-gateway frontend-port"
    az network application-gateway frontend-port list \
        --gateway-name $app_gw_name \
        --resource-group $RESOURCE_GROUP_NAME

    ################################
    # HTTP settings
    ################################
    echo "az network application-gateway http-settings create"
    az network application-gateway http-settings create \
        --gateway-name $app_gw_name \
        --name httpTo8080 \
        --port 8080 \
        --resource-group $RESOURCE_GROUP_NAME \
        --protocol Http \
        --cookie-based-affinity Enabled

    ################################
    # listeners
    ################################
    echo "az network application-gateway http-listener create"
    az network application-gateway http-listener create \
        --frontend-port port80 \
        --gateway-name $app_gw_name \
        --name port80Listener \
        --resource-group $RESOURCE_GROUP_NAME \
        --frontend-ip $pip_name

    echo "az network application-gateway http-listener list"
    az network application-gateway http-listener list \
        --gateway-name $app_gw_name \
        --resource-group $RESOURCE_GROUP_NAME

    ################################
    # Rules
    ################################
    echo "az network application-gateway rule create"
    az network application-gateway rule create \
        --gateway-name $app_gw_name \
        --name ruleHttp \
        --resource-group $RESOURCE_GROUP_NAME \
        --http-listener port80Listener \
        --http-settings httpTo8080 \
        --rule-type Basic

    echo "az network application-gateway rule show"
    az network application-gateway rule show \
        --gateway-name $app_gw_name
    

    echo "CREATED GATEWAY"
}
