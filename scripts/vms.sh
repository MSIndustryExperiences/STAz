#!/bin/bash

create_vm () {
    
    local vm_size=$1
    local vm_name=$2
    local sub_net_name=$3
    local vnet_name=$4
    local in_availability_set=$5
    local os_disk_size=$6
    local app_disk_size=$7
    local data_disk_size=$8

    local os_disk_name="$vm_name-os"
    local data_disk_name="$vm_name-data"
    local app_disk_name="$vm_name-app"

    local av_set_name=""

    echo "CREATING VM: $vm_name"

    if [ ! -z "$in_availability_set" ]
    then
        #create outside availability set
        az vm create \
            --admin-username $VM_ADMIN_UID \
            --authentication-type ssh \
            --data-disk-sizes-gb $os_disk_size \
            --generate-ssh-keys \
            --image CentOS \
            --name $vm_name \
            --output table \
            --resource-group $RESOURCE_GROUP_NAME \
            --size $vm_size \
            --subnet $sub_net_name \
            --vnet-name $vnet_name
    else
        #create inside availability set
        az vm create \
            --admin-username $VM_ADMIN_UID \
            --authentication-type ssh \
            --availability-set $AVAILABILITY_SET_NAME \
            --data-disk-sizes-gb $os_disk_size \
            --generate-ssh-keys \
            --image CentOS \
            --name $vm_name \
            --output table \
            --resource-group $RESOURCE_GROUP_NAME \
            --size $vm_size \
            --subnet $sub_net_name \
            --vnet-name $vnet_name
    fi



    # create new app disk and attach it
    echo "ATTACHING APP DISK: $app_disk_name"
    az vm disk attach \
        --name $app_disk_name \
        --new \
        --size-gb $app_disk_size \
        --sku StandardSSD_LRS \
        --vm-name $vm_name \
        -g $RESOURCE_GROUP_NAME
    
    # to-do - add support for no 3rd disk
    # create new data disk and attach it
    echo "ATTACHING DATA DISK: $data_disk_name"
    az vm disk attach \
        --name $data_disk_name \
        --new \
        --size-gb $data_disk_size \
        --sku StandardSSD_LRS \
        --vm-name $vm_name \
        -g $RESOURCE_GROUP_NAME

    echo "CREATED VM $vm_name"
}