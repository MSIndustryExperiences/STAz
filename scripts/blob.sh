#!/bin/bash -e
set -e

create_blob_roles() {

    echo "The function create_blob_role is not yet implemented"
    echo "A permissive role should be created here, assignments into that role, and then apply the role on the database"
    echo "Finally, remove roles on the storage that you do not want to have access"

}

create_blob_storage() {

    az group create \
        --name $RESOURCE_GROUP_NAME \
        --location $LOCATION

    (
        deployment_name=$(uuidgen)
        echo "DEPLOYMENT_NAME: $deployment_name"

        az group deployment create \
            --resource-group $RESOURCE_GROUP_NAME \
            --template-file "./templates/blob.json" \
            --parameters "./templates/blob.parameters.json" \
            --name $deployment_name
    )

    if [ $?  == 0 ];
    then
        echo "Blob storage has been successfully deployed"
    fi
}