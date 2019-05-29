#!/bin/bash

create_admin_vm () {
    
    local vm_name="$PREFIX-admin-vm"

    echo ">>>>>>>> CREATING ADMIN MACHINE $vm_name <<<<<<<<<<<"

    az vm create \
        --admin-username $VM_ADMIN_UID \
        --authentication-type ssh \
        --image CentOS \
        --generate-ssh-keys \
        --name $vm_name \
        --nsg "$vm_name-nsg" \
        --nsg-rule SSH \
        --os-disk-name "$vm_name-os" \
        --os-disk-size-gb 32 \
        --output table \
        --public-ip-address-allocation static \
        --resource-group $RESOURCE_GROUP_NAME \
        --size Standard_DS2_v2 \
        --subnet "$PREFIX-admin-subnet" \
        --vnet-name $VNET_NAME
    
    create_nsg "$vm_name-nsg"

    open_inbound_ports "$vm_name-nsg" 22 80 443 5666

    attach_disk StandardSSD_LRS "$PREFIX-srv" $vm_name 32 
    attach_disk StandardSSD_LRS "$PREFIX-data" $vm_name 100
    
    echo ">>>>>>>> CREATED ADMIN VM: $vm_name <<<<<<<<<<<"
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

    echo "CREATED VM: $vm_name"
}

attach_disk() {

    local disk_sku=$1
    local disk_name=$2
    local vm_name=$3
    local disk_capacity=$4

    echo "ATTACHING DISK: $disk_name"

    az vm disk attach \
        --name $disk_name \
        --resource-group $RESOURCE_GROUP_NAME \
        --size-gb $disk_capacity \
        --sku $disk_sku \
        --vm-name $vm_name \
        --new 

    echo "DISK ATTACHED: $disk_name"

}

create_test_worker_vm() {
    
    echo ">>>>>>>> CREATING TEST WORKER MACHINE <<<<<<<<<<<"

    local vm_name="$PREFIX-test"

    vm_name="$PREFIX-worker"
    create_worker_vm Standard_DS2_v2 $vm_name "$PREFIX-worker-subnet" 32

    create_nsg "$vm_name-nsg"

    open_inbound_ports "$vm_name-nsg" 22 8080 8009 8005 8983 7983 2181 2888 3888 27017 1802 1099 2099 8161 5666

    attach_disk StandardSSD_LRS "$PREFIX-01-srv" $vm_name 32 
    attach_disk StandardSSD_LRS "$PREFIX-01-data" $vm_name 100

    echo ">>>>>>>> CREATED TEST WORKER MACHINE $vm_name <<<<<<<<<<<"
}
