#!/bin/bash -e

. ./config/config_test.sh
. ./scripts/network.sh
. ./scripts/resource_group.sh
. ./scripts/vms.sh

# Sign in on the command line with this command or uncomment this line
# az login

create_resource_group

create_vnet $VNET_NAME 10.1.0.0/16

echo ">>>>>>>> CREATING ADMIN MACHINE <<<<<<<<<<<"
server_name="$PREFIX-admin-vm"
create_subnet "$PREFIX-admin-subnet" 10.1.1.0/24
create_admin_vm Standard_DS2_v2 $server_name "$PREFIX-admin-subnet" 32

create_nsg "$server_name-nsg"

open_inbound_ports "$server_name-nsg" 22 80 443 5666

attach_disk StandardSSD_LRS 32 "$PREFIX-srv" $server_name
attach_disk StandardSSD_LRS 100 "$PREFIX-data" $server_name

echo ">>>>>>>> CREATING TEST WORKER MACHINE <<<<<<<<<<<"
server_name="$PREFIX-worker-vm"
create_subnet "$PREFIX-worker-subnet" 10.1.2.0/24
create_worker_vm Standard_DS2_v2 $server_name "$PREFIX-worker-subnet" 32

create_nsg "$server_name-nsg"

open_inbound_ports "$server_name-nsg" 22 8080 8009 8005 8983 7983 2181 2888 3888 27017 1802 1099 2099 8161 5666
open_outbound_ports "$server_name-nsg" 22 8080 8009 8005 8983 7983 2181 2888 3888 27017 1802 1099 2099 8161 5666

attach_disk StandardSSD_LRS 32 "$PREFIX-01-srv" $server_name
attach_disk StandardSSD_LRS 100 "$PREFIX-01-data" $server_name