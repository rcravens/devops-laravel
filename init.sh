#!/bin/bash

# Save current directory and cd into script path
initial_working_directory=$(pwd)
parent_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
cd "$parent_path"

if [ -f $parent_path/new_config.sh ]; then
  # config file already exists.
  echo "here"
else
  # gather info and create the config file

  echo "The provisioning and deployment are done using a user created during provisioning."
  read -p 'username: ' username

  echo "The <root> DB user is used to configure the DB."
  read -sp '<root> user passord: ' db_root

  echo "Git repo "
fi

# Deployment
deploy_directory=/home/$username/web
repo=https://github.com/rcravens/laravel.git
app_domain=laravel-cravens.centralus.cloudapp.azure.com
is_laravel=true

# Return back to the original directory
cd $initial_working_directory
