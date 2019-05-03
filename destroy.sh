#! /bin/bash

. ./config.sh

az login

if az group exists --name $RESOURCE_GROUP_NAME
then
    echo "DELETING RESOURCE GROUP: $RESOURCE_GROUP_NAME"
    az group delete --name $RESOURCE_GROUP_NAME
    echo "DELETED RESOURCE GROUP: $RESOURCE_GROUP_NAME"
fi