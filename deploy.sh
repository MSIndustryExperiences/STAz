#!/bin/bash -e

. ./config.sh
. ./scripts/resourceGroup.sh
. ./scripts/network.sh
. ./scripts/vms.sh

# Sign in on the command line with this command or uncomment this line
# az login

create_resource_group

create_vnet $VNET_NAME 10.0.0.0/16

create_subnet "$PREFIX-poc-subnet" 10.0.1.0/24 $VNET_NAME 
create_subnet "$PREFIX-eng-subnet" 10.0.2.0/24 $VNET_NAME
create_subnet "$PREFIX-prod-subnet" 10.0.3.0/24 $VNET_NAME

create_vm "$PREFIX-poc-01-vm" Standard_D4s_v3 "$PREFIX-poc-subnet" 80 40 100
create_vm "$PREFIX-poc-02-vm" Standard_D4s_v3 "$PREFIX-poc-subnet" 80 40 100
create_vm "$PREFIX-poc-03-vm" Standard_D4s_v3 "$PREFIX-poc-subnet" 80 40 100