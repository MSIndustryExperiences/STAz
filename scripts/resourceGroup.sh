#!/bin/bash

create_resource_group() {
    
    if $(az group exists --name $RESOURCE_GROUP_NAME)
    then
        echo "RESOURCE GROUP $RESOURCE_GROUP_NAME ALREADY EXISTS"
        exit 1
    else
        echo "CREATING RESOURCE GROUP: $RESOURCE_GROUP_NAME"
        az group create --location $LOCATION --name $RESOURCE_GROUP_NAME
        echo "CREATED RESOURCE GROUP: $RESOURCE_GROUP_NAME"
    fi
}

delete_resource_group() {

    if $(az group exists --name $RESOURCE_GROUP_NAME)
    then
        echo "DELETING RESOURCE GROUP: $RESOURCE_GROUP_NAME"
        echo "This could take some time and will destroy all resources in the Resource Group."
        az group delete --name $RESOURCE_GROUP_NAME
        echo "DELETED RESOURCE GROUP: $RESOURCE_GROUP_NAME"
    else
        echo "RESOURCE GROUP: $RESOURCE_GROUP_NAME DOES NOT EXIST"
        exit 1
    fi
}

