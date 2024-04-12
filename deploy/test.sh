#!/bin/bash

# Save current directory and cd into script path
initial_working_directory=$(pwd)
parent_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
cd "$parent_path"

# Load the config file
source ../config.sh

deploy_directory=/home/$username/deployments

# Create supervisor conf
if [ ! -f /etc/supervisor/conf.d/$username.conf ]; then
    sudo cp $parent_path/horizon.conf /etc/supervisor/conf.d/$username.conf
    sudo sed -i "s|program:|program:horizon_$username|" /etc/supervisor/conf.d/$username.conf
    sudo sed -i "s|command=|command=php $deploy_directory/current/artisan horizon|" /etc/supervisor/conf.d/$username.conf
    sudo sed -i "s|user=|user=$username|" /etc/supervisor/conf.d/$username.conf
    sudo sed -i "s|stdout_logfile=|stdout_logfile=$deploy_directory/current/storage/logs/horizon.log|" /etc/supervisor/conf.d/$username.conf
    sudo supervisorctl reread
    sudo supervisorctl update
fi

# Return back to the original directory
cd $initial_working_directory || exit