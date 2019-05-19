#!/bin/bash -e

. ./config.sh
. ./scripts/resourceGroup.sh
. ./scripts/network.sh
. ./scripts/vms.sh

# Sign in on the command line with this command or uncomment this line
# az login

create_resource_group

# Add availaliblity group here


echo "CREATING AVAILIBILTY SET $AVAILABILITY_SET_NAME"
az vm availability-set create \
    --resource-group $RESOURCE_GROUP_NAME \
    --name $AVAILABILITY_SET_NAME \
    --platform-fault-domain-count 2 \
    --platform-update-domain-count 2
echo "CREATED AVAILIBILTY SET $AVAILABILITY_SET_NAME"

create_vnet $VNET_NAME_ENG 10.3.0.0/16
# create_vnet $VNET_NAME_POC 10.2.0.0/16
# create_vnet $VNET_NAME_TEST 10.1.0.0/16

# to-do peering here

create_subnet "$PREFIX-eng-subnet" 10.3.2.0/23 $VNET_NAME_ENG --verbose
# create_subnet "$PREFIX-poc-subnet" 10.0.3.0/23 $VNET_NAME_POC
# create_subnet "$PREFIX-test-subnet" 10.0.1.0/23 $VNET_NAME_TEST

echo "CREATING eng VMs"
# create_vm Standard_D4s_v3 "$PREFIX-eng-01-vm" "$PREFIX-eng-subnet" $VNET_NAME_ENG "" 80 40 100 # zk, Solr, Tomcat
# create_vm Standard_D4s_v3 "$PREFIX-eng-02-vm" "$PREFIX-eng-subnet" $VNET_NAME_ENG "" 80 40 100 # ActiveMQ
# create_vm Standard_D4s_v3 "$PREFIX-eng-03-vm" "$PREFIX-eng-subnet" $VNET_NAME_ENG "" 15 40 400 # Solr, MongoDB
create_vm Standard_D4s_v3 "$PREFIX-eng-04-vm" "$PREFIX-eng-subnet" $VNET_NAME_ENG "yes" 8 40 100 # seed, Solr, Tomcat
create_vm Standard_D4s_v3 "$PREFIX-eng-05-vm" "$PREFIX-eng-subnet" $VNET_NAME_ENG "" 8 40 100 # in availability set - Solr, Tomcat
# create_vm Standard_DS1_v2 "$PREFIX-eng-07-vm" "$PREFIX-eng-subnet" $VNET_NAME_ENG "" 8 40 # nagios
# create_vm Standard_DS1_v2 "$PREFIX-eng-08-vm" "$PREFIX-eng-subnet" $VNET_NAME_ENG "" 8 40 400 # Nuance

# echo "CREATING poc VMs"
# create_vm Standard_D4s_v3 "$PREFIX-poc-01-vm" "$PREFIX-poc-subnet" $VNET_NAME_POC 80 40 100 # zk, Solr, Tomcat
# create_vm Standard_D4s_v3 "$PREFIX-poc-02-vm" "$PREFIX-poc-subnet" $VNET_NAME_POC 80 40 100 # ActiveMQ
# create_vm Standard_D4s_v3 "$PREFIX-poc-03-vm" "$PREFIX-poc-subnet" $VNET_NAME_POC 15 40 200 # Solr, MongoDB
# create_vm Standard_D4s_v3 "$PREFIX-poc-04-vm" "$PREFIX-poc-subnet" $VNET_NAME_POC 8 40 100 # seed, Solr, Tomcat
# create_vm Standard_D4s_v3 "$PREFIX-poc-05-vm" "$PREFIX-poc-subnet" $VNET_NAME_POC 8 40 100 # in availability set - Solr, Tomcat
# create_vm Standard_DS1_v2 "$PREFIX-poc-06-vm" "$PREFIX-poc-subnet" $VNET_NAME_POC 8 40 100 # nagios

# echo "CREATING test VM"
# create_vm Standard_D4s_v3 "$PREFIX-poc-01-vm" "$PREFIX-poc-subnet" $VNET_NAME_TEST 80 40 320 # eveything

