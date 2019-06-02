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

# Create network
create_vnet $VNET_NAME $VNET_IP
create_subnet $ADMIN_SUBNET_NAME $ADMIN_SUBNET_IP
create_subnet $WORKER_SUBNET_NAME $WORKER_SUBNET_IP

# create VMs
create_admin_vm "10.1.1.5"
create_test_worker_vm "10.1.2.5"