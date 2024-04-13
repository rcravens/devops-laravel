#!/bin/bash

# Global variables that are used by the scripts
db_root_password=secret



# Add in the application specific configuration
if [ $# -eq 0 ]; then
  echo "No app specified, go with the current user"
  app_name=$(whoami)
else
  app_name="$1"
fi

root_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )

# Load the helpers
source $root_path/helpers.sh

# Load the application configuration file
app_config_file=$root_path/apps/$app_name.sh
if [[ ! -f $app_config_file ]]; then
  error "Configuration file not found: $app_config_file"
  existing_apps=$(ls apps/ | sed -e 's|\.[^.]*$||')
  error "Try one of these applications:"
  status "$existing_apps"
  exit 1
fi
source $app_config_file

# DO NOT CHANGE - Computed variables
deploy_directory=/home/$username/deployments