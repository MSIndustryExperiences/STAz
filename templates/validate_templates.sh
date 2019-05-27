. ../config/config_test.sh

# validate the nsg provisioning template
az group deployment validate \
  --resource-group $RESOURCE_GROUP_NAME \
  --template-file nsg.json \
  --parameters @nsg_parameters.json  

