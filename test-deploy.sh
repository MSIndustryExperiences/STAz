#!/bin/bash -e

. ./config/config_test.sh
. ./scripts/network.sh
. ./scripts/resource_group.sh
. ./scripts/vms.sh

# Sign in on the command line with `az login` command or uncomment 
# the following line to log in at script execution time
# az login

create_resource_group

# Create network
create_vnet $VNET_NAME $VNET_IP
create_subnet $ADMIN_SUBNET_NAME $ADMIN_SUBNET_IP
create_subnet $WORKER_SUBNET_NAME $WORKER_SUBNET_IP

# create VMs
create_admin_vm "10.2.1.5"

test_vm_name="$PREFIX-worker-vm"
create_test_worker_vm "10.2.2.5" $test_vm_name
open_vm_inbound_ports $test_vm_name 301 22 8080 8009 8005 8983 7983 2181 2888 3888 27017 1802 1099 2099 8161 5666
open_nsg_inbound_ports "$test_vm_name-nsg" 351 22 8080 8009 8005 8983 7983 2181 2888 3888 27017 1802 1099 2099 8161 5666
