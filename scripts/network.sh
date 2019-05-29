#!/bin/bash

create_subnet() {
    
    local subnet_name=$1
    local address_prefix=$2

    local nsg_name="$subnet_name"

    echo "CREATING SUBNET $subnet_name"

    az network vnet subnet create \
        --name $subnet_name \
        --resource-group $RESOURCE_GROUP_NAME \
        --address-prefixes $address_prefix \
        --vnet-name $VNET_NAME \
        || (echo "FAILED TO CREATE SUBNET: $subnet_name" && exit 1)

    echo "CREATED SUBNET $subnet_name"

}

create_vnet () {

    local vnet_name=$1
    local address_prefixes=$2

    echo "CREATING VNET $vnet_name"

    az network vnet create \
        --name $vnet_name \
        --resource-group $RESOURCE_GROUP_NAME \
        --address-prefixes $address_prefixes \
        --location $LOCATION \
         || (echo "FAILED TO CREATE $vnet_name" && exit 1)

    echo "CREATED VNET $vnet_name"
}

create_nsg() {

    local nsg_name=$1
    
    echo "CREATING AN NSG: $nsg_name"
    
    az network nsg create \
        --resource-group $RESOURCE_GROUP_NAME \
        --name "$nsg_name" \
        --location $LOCATION \
        || (echo "FAILED TO CREATE NSG: $nsg_name" && exit 1)
}

open_inbound_ports() {
    
    local nsg_name=$1
    local priority=300
    
    echo "OPENING INBOUND PORTS: $nsg_name"

    for i in "${@:2}"
    do
        echo "Opening inbound port: $i"

        az network nsg rule create \
            --access Allow \
            --destination-port-range $i \
            --direction Inbound \
            --name "open_$i" \
            --nsg-name $nsg_name \
            --priority $priority \
            --protocol tcp \
            --resource-group $RESOURCE_GROUP_NAME \
            || (echo "FAILED TO CREATE NSG Rule: $nsg_name" && exit 1)
        
         ((priority++))
    done
}