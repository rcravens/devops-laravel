#!/bin/bash

# Save current directory and cd into script path
common_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
root_path="$common_path/.."

# Load the helpers
source $common_path/helpers.sh

# Load the config file
source $root_path/config.sh

# Load the application config file
source $common_path/app_config.sh