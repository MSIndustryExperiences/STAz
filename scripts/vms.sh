#!/bin/bash

create_vm () {
    
    local vm_name=$1
    local disk_name=$2
    local vm_size=$3

    echo "CREATING VM: $vm_name"

    az vm create \
        --resource-group $RESOURCE_GROUP_NAME \
        --name $vm_name \
        --image CentOS \
        --admin-username $VM_ADMIN_UID \
        --size $vm_size \
        --os-disk-name $disk_name \
        --authentication-type ssh \
        --generate-ssh-keys
    

    echo "CREATED VM $vm_name"
}