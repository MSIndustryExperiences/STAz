#!/bin/bash -e
set -e

. ./config/config_eng.sh
. ./scripts/network.sh
. ./scripts/resource_group.sh
. ./scripts/blob.sh

create_blob_storage
create_blob_roles



