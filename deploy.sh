#!/bin/bash

. ./config.sh
. ./scripts/resourceGroup.sh
. ./scripts/network.sh

# az login

create_resource_group

echo "CREATING VM $PREFIX-01-vm"

az vm create \
    --resource-group $RESOURCE_GROUP_NAME \
    --name $PREFIX-01-vm \
    --image CentOS \
    --admin-username hsimpson \
    --size Standard_D4s_v3 \
    --os-disk-name $PREFIX-01-os-disk \
    --authentication-type ssh \
    --generate-ssh-keys

echo "CREATED VM $PREFIX-01-vm"