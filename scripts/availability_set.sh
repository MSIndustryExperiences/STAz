#!/bin/bash -e

create_availability_set () {

    echo "CREATING AVAILIBILTY SET $AVAILABILITY_SET_NAME"

    az vm availability-set create \
        --resource-group $RESOURCE_GROUP_NAME \
        --name $AVAILABILITY_SET_NAME \
        --platform-fault-domain-count 2 \
        --platform-update-domain-count 2

    echo "CREATED AVAILIBILTY SET $AVAILABILITY_SET_NAME"

}
