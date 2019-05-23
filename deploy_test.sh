#!/bin/bash -e

. ./config/config_test.sh
. ./scripts/network.sh
. ./scripts/resource_group.sh
. ./scripts/vms.sh

# Sign in on the command line with this command or uncomment this line
# az login

create_resource_group

create_vnet $VNET_NAME 10.1.0.0/16

create_subnet "$PREFIX-front-subnet" 10.1.1.0/24 $VNET_NAME
create_subnet "$PREFIX-back-subnet" 10.1.2.0/24 $VNET_NAME

echo "CREATING JUMPBOX VM"
server_name="$PREFIX-01-vm"
create_vm Standard_DS2_v2 $server_name "$PREFIX-front-subnet" $VNET_NAME 32 
attach_disk Standard_LRS 32 "$PREFIX-01-srv" $server_name
attach_disk Standard_LRS 100 "$PREFIX-01-data" $server_name

echo "CREATING TEST MACHINE"
server_name="$PREFIX-02-vm"
create_vm Standard_DS12_v2 $server_name "$PREFIX-back-subnet" $VNET_NAME 32 
attach_disk Standard_LRS 40 "$PREFIX-02-srv" $server_name
attach_disk Standard_LRS 320 "$PREFIX-02-data" $server_name

