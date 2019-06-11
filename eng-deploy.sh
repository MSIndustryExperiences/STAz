#!/bin/bash -e
set -e

#############################################
# Some machine creation is commented out to 
# create a smaller group of machines for
# development and testing purposes.
# Uncomment them if you want to install the whole
# solution. 
# 
# Remember to open ports on the same machine
# app gateway creation shoud you change them.
# will find a better solution for this (array as arg)
#############################################

. ./config/config_eng.sh
. ./scripts/app_gateway.sh
. ./scripts/network.sh
. ./scripts/resource_group.sh
. ./scripts/scale_set.sh
. ./scripts/vms.sh

# Sign in on the command line with this command or uncomment this line
# az login

create_resource_group

echo "CREATING NETWORK"

create_vnet $VNET_NAME $VNET_IP

create_subnet $ADMIN_SUBNET_NAME $ADMIN_SUBNET_IP
create_subnet $GATEWAY_SUBNET_NAME $GATEWAY_SUBNET_IP
create_subnet $WORKER_SUBNET_NAME $WORKER_SUBNET_IP

echo "CREATING JUMPBOX"
create_admin_vm "10.2.1.5"

echo "CREATING WORKER VMs"
create_worker_vm Standard_D4s_v3 "$PREFIX-01-vm" "10.2.2.10" 80 40 100 # FRONT END - zk, Solr, Tomcat
create_worker_vm Standard_D4s_v3 "$PREFIX-02-vm" "10.2.2.11" 80 40 100 # FRONT END - zk, Solr, Tomcat
# create_worker_vm Standard_D4s_v3 "$PREFIX-03-vm" "10.2.2.12" 80 40 100 # FRONT END - zk, Solr, Tomcat
# create_worker_vm Standard_D4s_v3 "$PREFIX-04-vm" "10.2.2.13" 80 40 100 # ActiveMQ
# create_worker_vm Standard_D4s_v3 "$PREFIX-05-vm" "10.2.2.14" 80 40 400 # Solr, MongoDB
# create_worker_vm Standard_D4s_v3 "$PREFIX-06-vm" "10.2.2.15" 80 40 100 # seed, Solr, Tomcat
# create_worker_vm Standard_D4s_v3 "$PREFIX-07-vm" "10.2.2.16" 80 40 100 # Solr, Tomcat
create_worker_vm Standard_D8s_v3 "$PREFIX-08-vm" "10.2.2.17" 32 40 400 # Nuance
create_worker_vm Standard_DS1_v2 "$PREFIX-09-vm" "10.2.2.18" 32 40 # nagios, nrpe

echo "OPENING PORTS"
open_nsg_inbound_ports "$PREFIX-01-vm-nsg" 80 8009 8005 2181 8983 7983 2888 3888 # FRONT END - zk, Solr, Tomcat
open_nsg_inbound_ports "$PREFIX-02-vm-nsg" 80 8009 8005 2181 8983 7983 2888 3888 # FRONT END - zk, Solr, Tomcat
# open_nsg_inbound_ports "$PREFIX-03-vm-nsg" 80 8009 8005 2181 8983 7983 2888 3888 # FRONT END - zk, Solr, Tomcat
# open_nsg_inbound_ports "$PREFIX-04-vm-nsg" 1802 1801 1099 2099 8161 # ActiveMQ
# open_nsg_inbound_ports "$PREFIX-05-vm-nsg" 8983 7983 27017 # Solr, MongoDB
# open_nsg_inbound_ports "$PREFIX-06-vm-nsg" 8983 7983 8080 8009 8005 # seed, Solr, Tomcat
# open_nsg_inbound_ports "$PREFIX-07-vm-nsg" 8983 7983 8080 8009 8005 # Solr, Tomcat
open_nsg_inbound_ports "$PREFIX-08-vm-nsg" # don't know
open_nsg_inbound_ports "$PREFIX-09-vm-nsg" 5666 # nagios, nrpe

create_app_gateway "10.2.3.5" "$PREFIX-gw-pip"

# create_scale_set

