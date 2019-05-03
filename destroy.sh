#! /bin/bash

. ./config.sh
. ./scripts/resourceGroup.sh

# az login -u $USER_NAME -p $PW
az login

delete_resource_group