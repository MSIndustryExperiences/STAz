
#!/bin/bash -e

. ./config/config_eng.sh
. ./scripts/network.sh
. ./scripts/resource_group.sh
. ./scripts/vms.sh

# Sign in on the command line with this command or uncomment this line
# az login

create_resource_group

# Create network
create_vnet $VNET_NAME $VNET_IP
create_subnet $ADMIN_SUBNET_NAME $ADMIN_SUBNET_IP
create_subnet $WORKER_SUBNET_NAME $WORKER_SUBNET_IP

# create VMs
create_admin_vm "10.2.1.5"

create_worker_vm Standard_D4s_v3 "$PREFIX-eng-01-vm" "10.2.2.10" 80 40 100 # zk, Solr, Tomcat
create_worker_vm Standard_D4s_v3 "$PREFIX-eng-02-vm" "10.2.2.11" 80 40 100 # ActiveMQ
create_worker_vm Standard_D4s_v3 "$PREFIX-eng-03-vm" "10.2.2.12" 80 40 400 # Solr, MongoDB
create_worker_vm Standard_D4s_v3 "$PREFIX-eng-04-vm" "10.2.2.13" 80 40 100 # seed, Solr, Tomcat
create_worker_vm Standard_D4s_v3 "$PREFIX-eng-05-vm" "10.2.2.14" 80 40 100 # in availability set - Solr, Tomcat
create_worker_vm Standard_D8s_v3 "$PREFIX-eng-07-vm" "10.2.2.15" 16 40 400 # Nuanzce
create_worker_vm Standard_DS1_v2 "$PREFIX-eng-06-vm" "10.2.2.16" 16 40 # nagios