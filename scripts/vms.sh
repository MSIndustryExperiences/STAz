#!/bin/bash

create_admin_vm() {

    local private_ip_address=$1
    local vm_name="$PREFIX-admin-vm"

    echo ">>>>>>>> CREATING ADMIN MACHINE $vm_name <<<<<<<<<<<"

    az vm create \
        --admin-username $VM_ADMIN_UID \
        --authentication-type ssh \
        --data-disk-sizes-gb 32 100 \
        --image CentOS \
        --generate-ssh-keys \
        --name $vm_name \
        --nsg "$vm_name-nsg" \
        --nsg-rule SSH \
        --os-disk-name "$vm_name-os" \
        --os-disk-size-gb 32 \
        --output table \
        --private-ip-address $private_ip_address \
        --public-ip-address "$vm_name-public_ip" \
        --public-ip-address-allocation static \
        --public-ip-sku Standard \
        --resource-group $RESOURCE_GROUP_NAME \
        --size Standard_DS2_v2 \
        --subnet $ADMIN_SUBNET_NAME \
        --vnet-name $VNET_NAME

    echo ">>>>>>>> CREATED ADMIN VM: $vm_name <<<<<<<<<<<"
}

create_test_worker_vm() {

    echo ">>>>>>>> CREATING TEST WORKER MACHINE <<<<<<<<<<<"

    local private_ip_address=$1
    local vm_name="$PREFIX-worker-vm"

    az vm create \
        --admin-username $VM_ADMIN_UID \
        --authentication-type ssh \
        --data-disk-sizes-gb 40 100 \
        --image CentOS \
        --generate-ssh-keys \
        --name $vm_name \
        --nsg "$vm_name-nsg" \
        --nsg-rule SSH \
        --os-disk-name "$vm_name-os" \
        --os-disk-size-gb 80 \
        --output table \
        --public-ip-address "" \
        --private-ip-address $private_ip_address \
        --resource-group $RESOURCE_GROUP_NAME \
        --size Standard_DS2_v2 \
        --subnet $WORKER_SUBNET_NAME \
        --vnet-name $VNET_NAME




    # create_worker_vm Standard_DS2_v2 $vm_name $private_ip_address 32

    # create_nsg "$vm_name-nsg"
    open_nsg_inbound_ports "$vm_name-nsg" 22 8080 8009 8005 8983 7983 2181 2888 3888 27017 1802 1099 2099 8161 5666

    # attach_disk StandardSSD_LRS "$PREFIX-01-srv" $vm_name 32
    # attach_disk StandardSSD_LRS "$PREFIX-01-data" $vm_name 100

    echo ">>>>>>>> CREATED TEST WORKER MACHINE $vm_name <<<<<<<<<<<"
}

create_worker_vm() {

    echo ">>>>>>>> CREATING WORKER MACHINE <<<<<<<<<<<"

    local vm_size=$1
    local vm_name=$2
    local vm_ip=$3
    local os_disk_size=$4
    local app_disk_size=$5
    local svr_disk_size=$6

    local os_disk_name="$vm_name-os"

    echo "CREATING VM: $vm_name"

    echo "######## $vm-ip"

    az vm create \
        --admin-username $VM_ADMIN_UID \
        --authentication-type ssh \
        --data-disk-sizes-gb 40 100 \
        --image CentOS \
        --generate-ssh-keys \
        --name $vm_name \
        --nsg "$vm_name-nsg" \
        --nsg-rule SSH \
        --os-disk-name "$vm_name-os" \
        --os-disk-size-gb 80 \
        --output table \
        --public-ip-address "" \
        --private-ip-address $vm_ip \
        --resource-group $RESOURCE_GROUP_NAME \
        --size $1 \
        --subnet $WORKER_SUBNET_NAME \
        --vnet-name $VNET_NAME

    # az vm create \
    #     --name $vm_name \
    #     --resource-group $RESOURCE_GROUP_NAME \
    #     --admin-username $VM_ADMIN_UID \
    #     --authentication-type ssh \
    #     --data-disk-sizes-gb $app_disk_size $svr_disk_size \
    #     --image CentOS \
    #     --location $LOCATION \
    #     --nsg "$vm_name-nsg" \
    #     --nsg-rule SSH \
    #     --os-disk-name $os_disk_name \
    #     --os-disk-size-gb $os_disk_size \
    #     --output table \
    #     --private-ip-address $vm_ip \ 
    #     --public-ip-address "" \
    #     --size $vm_size \
    #     --subnet $WORKER_SUBNET_NAME \
    #     --vnet-name $VNET_NAME



    echo ">>>>>>>> CREATED WORKER MACHINE $vm_name <<<<<<<<<<<"
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

