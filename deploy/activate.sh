#!/bin/bash

# we are inside the dated releases directory

# create symlinks
parent_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )

source $parent_path/../config.sh

deploy_directory=/home/$username/deployments

if [ -f $deploy_directory/current ]; then
  unlink $deploy_directory/current
fi
ln -sf $PWD $deploy_directory/current
