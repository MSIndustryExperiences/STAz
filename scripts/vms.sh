#!/bin/bash

create_vm () {
    
    local vm_name=$1
    local disk_name=$2
    local vm_size=$3
    
    local os_disk="$vm_name-os"
    local data_disk="$vm_name-data"
    local app_disk="$vm_name-app"

    echo "CREATING VM: $vm_name"

    az vm create \
        --resource-group $RESOURCE_GROUP_NAME \
        --name $vm_name \
        --image CentOS \
        --admin-username $VM_ADMIN_UID \
        --size $vm_size \
        --os-disk-name $os_disk \
        --authentication-type ssh \
        --generate-ssh-keys \
        --vnet-name 
        --subnet 

    # create new software disk and attach it
    echo "ATTACHING APP DISK: $app_disk"
    az vm disk attach \
        -g $RESOURCE_GROUP_NAME \
        --vm-name $vm_name \
        --name $app_disk \
        --new \
        --size-gb 40 \
        --sku StandardSSD_LRS

    # create new data disk and attach it
    echo "ATTACHING DATA DISK: $data_disk"
    az vm disk attach \
        -g $RESOURCE_GROUP_NAME \
        --vm-name $vm_name \
        --name $data_disk \
        --new \
        --size-gb 100 \
        --sku StandardSSD_LRS        

    echo "CREATED VM $vm_name"
}