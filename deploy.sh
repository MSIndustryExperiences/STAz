#! /bin/bash

. ./config.sh

az login


if az group exists --name $RESOURCE_GROUP_NAME
then
    echo "$RESOURCE_GROUP_NAME already exists"
else 
    echo "CREATING RESOURCE GROUP: $RESOURCE_GROUP_NAME"
    az group create --location $LOCATION --name $RESOURCE_GROUP_NAME # --subscription $SUBSCRIPTION_ID
fi













