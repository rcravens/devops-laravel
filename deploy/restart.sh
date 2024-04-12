#!/bin/bash

# Save current directory and cd into script path
initial_working_directory=$(pwd)
parent_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )

# Load the config file
source $parent_path/../config.sh

sudo /usr/sbin/service supervisor restart
sudo /usr/sbin/service php$php_version-fpm reload
