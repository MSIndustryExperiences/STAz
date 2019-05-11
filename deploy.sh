#!/bin/bash

. ./config.sh
. ./scripts/resourceGroup.sh
#. ./scripts/network.sh
. ./scripts/vms.sh

# az login

create_resource_group

create_vm "$PREFIX-01-vm" "$PREFIX-01-disk" Standard_D4s_v3
create_vm "$PREFIX-02-vm" "$PREFIX-02-disk" Standard_D4s_v3




