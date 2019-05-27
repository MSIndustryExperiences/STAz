#!/bin/bash

create_admin_vm () {
    
    local vm_size=$1
    local vm_name=$2
    local sub_net_name=$3
    local os_disk_size=$4
    
    local os_disk_name="$vm_name-os"

    echo "CREATING ADMIN VM: $vm_name"

    az vm create \
        --admin-username $VM_ADMIN_UID \
        --authentication-type ssh \
        --image CentOS \
        --generate-ssh-keys \
        --name $vm_name \
        --nsg "$vm_name-nsg" \
        --nsg-rule SSH \
        --os-disk-name $os_disk_name \
        --os-disk-size-gb $os_disk_size \
        --output table \
        --public-ip-address-allocation static \
        --resource-group $RESOURCE_GROUP_NAME \
        --size $vm_size \
        --subnet $sub_net_name \
        --vnet-name $VNET_NAME

    echo "CREATED ADMIN VM: $vm_name"
}

create_worker_vm() {
    
    local vm_size=$1
    local vm_name=$2
    local sub_net_name=$3
    local os_disk_size=$4
    
    local os_disk_name="$vm_name-os"

    echo "CREATING VM: $vm_name"

    az vm create \
        --admin-username $VM_ADMIN_UID \
        --authentication-type ssh \
        --image CentOS \
        --name $vm_name \
        --nsg "$vm_name-nsg" \
        --nsg-rule SSH \
        --os-disk-name $os_disk_name \
        --os-disk-size-gb $os_disk_size \
        --output table \
        --public-ip-address "" \
        --resource-group $RESOURCE_GROUP_NAME \
        --size $vm_size \
        --subnet $sub_net_name \
        --vnet-name $VNET_NAME
}

open_port_on_vm () {

    local vm_name=$1
    local port=$2

    az vm open-port \
        --resource-group $RESOURCE_GROUP_NAME \
        --name $vm_name  \
        --port $port
}

attach_disk() {

    local disk_sku=$1
    local disk_capacity=$2
    local disk_name=$3
    local vm_name=$4

    echo "ATTACHING DISK: $disk_name: $disk_id"

    az vm disk attach \
        --name $disk_name \
        --size-gb $disk_capacity \
        --sku $disk_sku \
        --vm-name $vm_name \
        --group-name $RESOURCE_GROUP_NAME \
        --new 

    echo "ATTACHED: $disk_name"

}
