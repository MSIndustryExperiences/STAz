function create_scale_set() {

    local BE_POOL_NAME="sset-lb-backend-pool"

    echo "CREATING SCALE SET"

    az vmss create \
    --backend-pool-name $BE_POOL_NAME \
    --data-disk-sizes-gb 32 100 \
    --generate-ssh-keys \
    --image OpenLogic:CentOS:7.5:7.5.20180815 \
    --lb-sku Standard \
    --load-balancer "$PREFIX-lb" \
    --location $LOCATION \
    --name "$PREFIX-sset" \
    --priority Regular \
    --public-ip-address "" \
    --resource-group $RESOURCE_GROUP_NAME \
    --subnet $WORKER_SUBNET_NAME \
    --upgrade-policy-mode automatic \
    --vm-sku Standard_D4s_v3 \
    --vnet-name $VNET_NAME

    az vmss list --resource-group $RESOURCE_GROUP_NAME

    az vmss list-instances \
    --resource-group $RESOURCE_GROUP_NAME \
    --name "$PREFIX-sset" \
    --output table

    az vmss list-instance-connection-info \
    --resource-group myResourceGroup \
    --name myScaleSet

    echo "CREATED SCALE SET"

    az network lb rule create \
    --admin-username $VM_ADMIN_UID
    --resource-group $RESOURCE_GROUP_NAME \
    --name "$PREFIX-rule-01" \
    --lb-name "$PREFIX-lb" \
    --backend-pool-name $BE_POOL_NAME \
    --backend-port 0 \
    --frontend-ip-name "$PREFIX-ss-frontend-ip" \
    --frontend-port 0 \
    --protocol tcp

}