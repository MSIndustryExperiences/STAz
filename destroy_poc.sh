#! /bin/bash

. ./config/config.sh
. ./scripts/resource_group.sh

# Sign in on the command line with this command or uncomment this line
# az login

delete_resource_group

# might destroy network watcher. Have to look into it a bit more.