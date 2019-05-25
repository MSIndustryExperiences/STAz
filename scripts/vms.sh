#!/bin/bash

create_vm () {
    
    local vm_size=$1
    local vm_name=$2
    local sub_net_name=$3
    local vnet_name=$4
    local os_disk_size=$5
    local app_disk_size=$6
    local data_disk_size=$7

    local os_disk_name="$vm_name-os"

    echo "CREATING VM: $vm_name"

    response=$(az vm create \
        --admin-username $VM_ADMIN_UID \
        --authentication-type ssh \
        --generate-ssh-keys \
        --image CentOS \
        --name $vm_name \
        --os-disk-name $os_disk_name \
        --os-disk-size-gb $os_disk_size \
        --output table \
        --resource-group $RESOURCE_GROUP_NAME \
        --size $vm_size \
        --subnet $sub_net_name \
        --vnet-name $vnet_name)

    echo "$response"
}

attach_disk() {

    local disk_sku=$1
    local disk_capacity=$2
    local disk_name=$3
    local vm_name=$4

    echo "ATTACHING APP DISK: $disk_name"

    az vm disk attach \
        --name $disk_name \
        --new \
        --size-gb $disk_capacity \
        --sku $disk_sku \
        --vm-name $vm_name \
        -g $RESOURCE_GROUP_NAME

    echo "$disk_name was attached"
}