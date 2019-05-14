#!/bin/bash -e

. ./config.sh
. ./scripts/resourceGroup.sh
. ./scripts/network.sh
. ./scripts/vms.sh

# Sign in on the command line with this command or uncomment this line
# az login

create_resource_group

create_vnet "$PREFIX-outer-vnet" 10.0.0.0/16

create_subnet "$PREFIX-poc-subnet" 10.0.1.0/24 "$PREFIX-outer-vnet"
create_subnet "$PREFIX-eng-subnet" 10.0.2.0/24 "$PREFIX-outer-vnet"
create_subnet "$PREFIX-prod-subnet" 10.0.3.0/24 "$PREFIX-outer-vnet"

# create_vm "$PREFIX-01-vm" "$PREFIX-01-disk" Standard_D4s_v3
# create_vm "$PREFIX-02-vm" "$PREFIX-02-disk" Standard_D4s_v3