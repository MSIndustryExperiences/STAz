
#!/bin/bash -e

. ./config/config_eng.sh
. ./scripts/network.sh
. ./scripts/resource_group.sh
. ./scripts/vms.sh

# Sign in on the command line with this command or uncomment this line
# az login

create_resource_group

echo "CREATING NETWORK"
create_vnet $VNET_NAME $VNET_IP
create_subnet $ADMIN_SUBNET_NAME $ADMIN_SUBNET_IP
create_subnet $WORKER_SUBNET_NAME $WORKER_SUBNET_IP

echo "CREATING VMs"
create_admin_vm "10.2.1.5"
create_worker_vm Standard_D4s_v3 "$PREFIX-eng-01-vm" "10.2.2.10" 80 40 100 # zk, Solr, Tomcat
create_worker_vm Standard_D4s_v3 "$PREFIX-eng-02-vm" "10.2.2.11" 80 40 100 # ActiveMQ
create_worker_vm Standard_D4s_v3 "$PREFIX-eng-03-vm" "10.2.2.12" 80 40 400 # Solr, MongoDB
# create_worker_vm Standard_D4s_v3 "$PREFIX-eng-04-vm" "10.2.2.13" 80 40 100 # seed, Solr, Tomcat
# create_worker_vm Standard_D4s_v3 "$PREFIX-eng-05-vm" "10.2.2.14" 80 40 100 # Solr, Tomcat
# create_worker_vm Standard_D8s_v3 "$PREFIX-eng-06-vm" "10.2.2.15" 16 40 400 # Nuance
# create_worker_vm Standard_DS1_v2 "$PREFIX-eng-07-vm" "10.2.2.16" 16 40 # nagios, nrpe

echo "OPENING PORTS"
open_nsg_inbound_ports "$PREFIX-eng-01-vm-nsg" 8080 8009 8005 2181 2888 3888 8983 7983 # zk, Solr, Tomcat
open_nsg_inbound_ports "$PREFIX-eng-02-vm-nsg" 1802 1099 2099 8161 # ActiveMQ
open_nsg_inbound_ports "$PREFIX-eng-03-vm-nsg" 8983 7983 27017 # Solr, MongoDB
# open_nsg_inbound_ports "$PREFIX-eng-04-vm-nsg" 8983 7983 8080 8009 8005 # seed, Solr, Tomcat
# open_nsg_inbound_ports "$PREFIX-eng-05-vm-nsg" 8983 7983 8080 8009 8005 # Solr, Tomcat
## open_nsg_inbound_ports "$PREFIX-eng-06-vm-nsg" # don't know
# open_nsg_inbound_ports "$PREFIX-eng-07-vm-nsg" 206 5666 # nagios, nrpe