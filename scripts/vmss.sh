#!/bin/bash -e
set -e

create_scale_set() {

    echo "CREATING VMSS"

    az vmss create \
        --admin-username $VM_ADMIN_UID \
        --authentication-type ssh \
        --generate-ssh-keys \
        --image $VMSS_VM_IMAGE_NAME \
        --load-balancer "" \
        --location $LOCATION \
        --public-ip-address "" \
        --subnet $WORKER_SUBNET_NAME \
        --upgrade-policy-mode Automatic \
        --vnet-name $VNET_NAME \
        -g $RESOURCE_GROUP_NAME \
        -n "$PREFIX-vmss"

    ############################
    # CREATE AUTOSCALE PROFILE
    # AND RULES
    ############################
    
    echo "az monitor autoscale create"
    az monitor autoscale create \
        --count 2 \
        --max-count 10 \
        --min-count 2 \
        --name "autoscaler1" \
        --resource "$PREFIX-vmss" \
        --resource-group $RESOURCE_GROUP_NAME \
        --resource-type Microsoft.Compute/virtualMachineScaleSets

    az monitor autoscale rule create \
        --resource-group $RESOURCE_GROUP_NAME \
        --autoscale-name "autoscaler1" \
        --condition "Percentage CPU < 20 avg 5m" \
        --scale in 1

    az monitor autoscale rule create \
        --resource-group $RESOURCE_GROUP_NAME \
        --autoscale-name "autoscaler1" \
        --condition "Percentage CPU > 50 avg 5m" \
        --scale out 1
        # --resource "$PREFIX-vmss" \

    


}

create_vmss_image() {

    local vm_name="SyTrueCentOsVm"

    echo "CREATING VMSS IMAGE"

    az vm create \
        --admin-username $VM_ADMIN_UID \
        --authentication-type ssh \
        --data-disk-sizes-gb 40 100 \
        --image CentOS \
        --generate-ssh-keys \
        --name $vm_name \
        --os-disk-name "$vm_name-os" \
        --os-disk-size-gb 80 \
        --output table \
        --public-ip-address "" \
        --size Standard_D4s_v3 \
        --subnet $WORKER_SUBNET_NAME \
        --resource-group $RESOURCE_GROUP_NAME \
        --vnet-name $VNET_NAME  \
        || (echo "FAILED TO CREATE VM: $vm_name" && exit 1)

    #############################
    # open VM ports
    #############################
    echo "OPENING PORTS"
    az vm open-port \
        --name $vm_name \
        --port 8983 \
        --resource-group $RESOURCE_GROUP_NAME \
        --priority 400 \
        || (echo "FAILED TO CREATE VM RULE: $vm_name" && exit 1)

    az vm open-port \
        --name $vm_name \
        --port 7983 \
        --resource-group $RESOURCE_GROUP_NAME \
        --priority 401 \
        || (echo "FAILED TO CREATE VM RULE: $vm_name" && exit 1)

    az vm open-port \
        --name $vm_name \
        --port 27017 \
        --resource-group $RESOURCE_GROUP_NAME \
        --priority 402 \
        || (echo "FAILED TO CREATE VM RULE: $vm_name" && exit 1)

    #############################
    # creating the image
    #############################
    echo "CREATING IMAGE"

    az vm deallocate --resource-group $RESOURCE_GROUP_NAME --name $vm_name
    az vm generalize --resource-group $RESOURCE_GROUP_NAME --name $vm_name

    az image create \
        --resource-group $RESOURCE_GROUP_NAME \
        --name $VMSS_VM_IMAGE_NAME \
        --source $vm_name

    #############################
    # destroy the VM
    #############################
    echo "DELETING VM"
    az vm delete -g $RESOURCE_GROUP_NAME -n $vm_name --yes

    #############################
    # destroy unattached disks
    #############################

    # Set deleteUnattachedDisks=1 if you want to delete unattached Managed Disks
    # Set deleteUnattachedDisks=0 if you want to see the Id of the unattached Managed Disks
    deleteUnattachedDisks=1

    unattachedDiskIds=$(az disk list --query '[?managedBy==`null`].[id]' -o tsv)
    for id in ${unattachedDiskIds[@]}
    do
        if (( $deleteUnattachedDisks == 1 ))
        then

            echo "Deleting unattached Managed Disk with Id: "$id
            az disk delete --ids $id --yes
            echo "Deleted unattached Managed Disk with Id: "$id

        else
            echo $id
        fi
    done

}