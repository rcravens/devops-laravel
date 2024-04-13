#!/bin/bash

common_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )

# Load the application configuration file
app_config_file=$common_path/../apps/$app_name.sh
if [[ ! -f $app_config_file ]]; then
  error "Configuration file not found: $app_config_file"
  existing_apps=$(ls $common_path/../apps/ | sed -e 's|\.[^.]*$||')
  error "Try one of these applications:"
  echo "$existing_apps"
  exit 1
fi
source $app_config_file

deploy_directory=/home/$username/deployments