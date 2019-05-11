#! /bin/bash

. ./config.sh
. ./scripts/resourceGroup.sh

# az login

echo "This could take some time and will destroy all resources in the Resource Group."
delete_resource_group