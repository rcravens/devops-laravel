#!/bin/bash

function title {
    echo "-------------------------------------"
    echo ""
    echo "$1"
    echo ""
    echo "-------------------------------------"
}

# Save current directory and cd into script path
initial_working_directory=$(pwd)
parent_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
cd "$parent_path"

# Load the config file
source ../config.sh

# create a directory for git clone
foldername=$(date +%Y%m%d%H%M%S)

{
    # create the directory structure
    title "Deploying: $foldername"
    if [ ! -d $deploy_directory/releases ]; then
        sudo mkdir -p $deploy_directory/releases
        sudo chown -R $username:$username $deploy_directory/releases
    fi
    cd $deploy_directory/releases
    echo  "folder=$deploy_directory/releases/$foldername"

    # git clone into this new directory
    sudo git clone --depth 1 $repo $foldername
    sudo chown -R $username:$username $deploy_directory/releases/$foldername

    # composer install
    title "Dependencies"
    cd $foldername
    sudo -u $username /usr/bin/composer install
    sudo -u $username /usr/bin/npm install

    # create symlinks
    title Activation
    source $parent_path/activate.sh

    # migrations
    title Migrations
    php artisan migrate --force

    # restart services
    source $parent_path/restart.sh

    # cleanup
    source $parent_path/clean_up.sh
} 2>&1

# Return back to the original directory
cd $initial_working_directory
