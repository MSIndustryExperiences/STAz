#!/bin/bash -e

. ./config/config_poc.sh
. ./scripts/network.sh
. ./scripts/resource_group.sh
. ./scripts/vms.sh

# Sign in on the command line with this command or uncomment this line
# az login

# create_resource_group

# create_vnet 10.1.0.0/16
# create_subnet $ADMIN_SUBNET 10.1.1.0/24
# create_subnet 10.1.2.0/24

# create_availability_set # resilience - not at this time

# create scale_set #redundancy

# create_admin_vm

echo "CREATING poc VMs"
ports_to_open=("8080" "8009" "8005")
drive_sizes=("80" "40" "100")
create_worker_vm Standard_D4s_v3 "$PREFIX-01-vm" $drive_sizes $ports_to_open "yes" # zk, Solr, Tomcat

# create_worker_vm Standard_D4s_v3 "$PREFIX-02-vm" "" 80 40 100 # ActiveMQ
# create_worker_vm Standard_D4s_v3 "$PREFIX-03-vm" "" 80 40 200 # Solr, MongoDB
# create_worker_vm Standard_D4s_v3 "$PREFIX-04-vm" "" 80 40 100 # seed, Solr, Tomcat
# create_worker_vm Standard_D4s_v3 "$PREFIX-05-vm" "" 80 40 100 # in availability set - Solr, Tomcat
# create_worker_vm Standard_DS1_v2 "$PREFIX-06-vm" "" 80 40 100 # nagios

# echo "CREATING test VM"
# create_worker_vm Standard_D4s_v3 "$PREFIX-01-vm" "" 80 40 320 

# Open ports on subnet
# tomcat: 8080, 8009, 8005
# solr: 8983, 7983
# zk: 2181, 2888, 3888
# mongod: 27017
# amq: 1802, 1099, 2099, 8161
# nrpe: 5666
