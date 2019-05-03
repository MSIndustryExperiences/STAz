#!/bin/bash

create_resource_group() {
    
    if $(az group exists --name $RESOURCE_GROUP_NAME)
    then
        echo "RESOURCE GROUP $RESOURCE_GROUP_NAME ALREADY EXISTS"
    else 
        echo "CREATING RESOURCE GROUP: $RESOURCE_GROUP_NAME"
        az group create --location $LOCATION --name $RESOURCE_GROUP_NAME
    fi
}

delete_resource_group() {
    if $(az group exists -n $RESOURCE_GROUP_NAME)
    then
        echo "DELETING RESOURCE GROUP: $RESOURCE_GROUP_NAME"
        az group delete --name $RESOURCE_GROUP_NAME
        echo "DELETED RESOURCE GROUP: $RESOURCE_GROUP_NAME"
    else
        echo "RESOURCE GROUP: $RESOURCE_GROUP_NAME DOES NOT EXIST"
    fi
}

