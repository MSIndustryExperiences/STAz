#!/bin/bash

# Deploy resource group, managed idenity, VM, storage account, assing role 
az login

azSubscriptionId=""
az account set -s $azSubscriptionId

resourceGroup="ErcVmManagedIdent"
az group create --name $resourceGroup --location eastus2

identityName="vmIdentity"
az identity create -g $resourceGroup -n $identityName

vmName="ercidentityvm"
az vm create -g $resourceGroup --name $vmName --image UbuntuLTS --admin-username ercadmin --admin-password S3cr3tP@ssw0rd1 --assign-identity vmIdentity

storageAccountName="ercvmident"
az storage account create --name $storageAccountName -g $resourceGroup --location eastus2 --sku Standard_RAGRS --kind StorageV2

export AZURE_STORAGE_ACCOUNT=$storageAccountName
export AZURE_STORAGE_KEY=$(az storage account keys list --account-name $storageAccountName -g $resourceGroup --query "[?keyName=='key1'].value" --output tsv)

spId=$(az identity list -g $resourceGroup --query "[?name=='"$identityName"'].{principalId:principalId}" --output tsv)

containerName="test"
az storage container create --name $containerName 

scope="/subscriptions/"$azSubscriptionId"/resourceGroups/"$resourceGroup"/providers/Microsoft.Storage/storageAccounts/"$storageAccountName"/blobServices/default/containers/"$containerName

az role assignment create --role "Storage Blob Data Contributor" --assignee $spId --scope $scope

# On the vm

echo "one two three" >> blobcontent

# Install CLI https://docs.microsoft.com/en-us/cli/azure/install-azure-cli-apt?view=azure-cli-latest
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

# login using the user created managed identity
userName="/subscriptions/"$azSubscriptionId"/resourcegroups/"$resourceGroup"/providers/Microsoft.ManagedIdentity/userAssignedIdentities/"$identityName

az login --identity -u $userName

# Upload the blob
az storage blob upload --account-name ercvmident --container-name "test" --file ./blobcontent --name blocontent --auth-mode login
