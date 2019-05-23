#!/bin/bash

function create_vnet () {

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

function create_subnet() {
    
    local subnet_name=$1
    local address_prefix=$2
    local vnet_name=$3

    echo "CREATING SUBNET $subnet_name"

    az network vnet subnet create \
        --name $subnet_name \
        --resource-group $RESOURCE_GROUP_NAME \
        --address-prefixes $address_prefix \
        --vnet-name $vnet_name  \
        || (echo "FAILED TO CREATE $subnet_name" && exit 1)

    echo "CREATED SUBNET $subnet_name"

}

create_nsg() {

    echo "DREATING A NSG"
    # az network nsg create \
    #   --resource-group $RESOURCE_GROUP_NAME \
    #   --name st-nsg \
    #   --location $LOCATION

}