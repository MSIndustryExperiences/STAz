#!/bin/bash

# echo "CREATING NETWORK"

# az group deployment create --resource-group $RESOURCE_GROUP_NAME --template-file ./templates/customer-rg.json


# Create a network security group (NSG) for the frontend subnet.
# az network nsg create \
#   --resource-group $RESOURCE_GROUP_NAME \
#   --name st-nsg \
#   --location $LOCATION

# # Create the frontend subnet
# az network vnet create \
#   --name st-perimeter-vnet \
#   --resource-group $RESOURCE_GROUP_NAME \
#   --subnet-name frontend-subnet

# # Create a back-end subnet
# az network vnet subnet create \
#   --address-prefix 10.0.2.0/24 \
#   --name backend-subnet \
#   --resource-group $RESOURCE_GROUP_NAME \
#   --vnet-name st-perimeter-vnet     

# show the results
# az network vnet subnet list -g $RESOURCE_GROUP_NAME --vnet-name st-perimeter-vnet --output table

# echo "CREATED NETWORK"