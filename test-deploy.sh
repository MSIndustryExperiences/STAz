#!/bin/bash -e

. ./config/config_test.sh
. ./scripts/network.sh
. ./scripts/resource_group.sh
. ./scripts/vms.sh

# Sign in on the command line with `az login` command or uncomment 
# the following line to log in at script execution time
# az login


create_resource_group

# create_load_balancer

create_vnet $VNET_NAME 10.1.0.0/16
create_subnet $ADMIN_SUBNET 10.1.1.0/24
create_subnet $WORKER_SUBNET 10.1.2.0/24

create_admin_vm
create_test_worker_vm