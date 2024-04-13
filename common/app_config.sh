#!/bin/bash

# Expecting an app_name variable
if [[ ! -v app_name ]]; then
  error "Variable app_name is not set"
  exit 1
fi

# Load the application configuration file
app_config_file=$root_path/apps/$app_name.sh
if [[ ! -f $app_config_file ]]; then
  error "Configuration file not found: $app_config_file"
  existing_apps=$(ls $root_path/apps/ | sed -e 's|\.[^.]*$||')
  error "Try one of these applications:"
  echo "$existing_apps"
  echo ""
  echo ""
  exit 1
fi
source $app_config_file

deploy_directory=/home/$username/deployments