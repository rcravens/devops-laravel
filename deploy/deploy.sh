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
    cd $foldername
    echo 'after cloning'
    pwd

    # initial setup
    if [ "$is_laravel" = true ]; then
      if [ ! -f $deploy_directory/.env ]; then
          sudo cp $parent_path/.env $deploy_directory/.env
          sudo sed -i "s|APP_URL=.*|APP_URL=http://$app_domain|" $deploy_directory/.env
          echo 'about to generate key'
          pwd
          php artisan key:generate
      fi
      if [ ! -f /etc/nginx/sites-available/laravel.conf ]; then
          sudo cp $parent_path/laravel.conf /etc/nginx/sites-available/laravel.conf
          sudo sed -i "s/server_name;/server_name $app_domain;/" /etc/nginx/sites-available/laravel.conf
          sudo sed -i "s|root;|root $deploy_directory/current/public;|" /etc/nginx/sites-available/laravel.conf
          sudo ln -s /etc/nginx/sites-available/laravel.conf /etc/nginx/sites-enabled/laravel.conf
          sudo service nginx restart
      fi
    fi

    # composer install
    title "Dependencies"
    sudo -u $username /usr/bin/composer install
    sudo -u $username /usr/bin/npm install

    # create symlinks
    title Activation
    source $parent_path/activate.sh

    # migrations
    if [ "$is_laravel" = true ]; then
      if [ ! -f $deploy_directory/.env ]; then
          echo "NO .env FILE FOUND AT $deploy_directory/.env"
      else
        title Migrations
        cd $deploy_directory/releases/$foldername
        php artisan migrate --force
      fi
    fi

    # restart services
    source $parent_path/restart.sh

    # cleanup
    source $parent_path/clean_up.sh
} 2>&1

# Return back to the original directory
cd $initial_working_directory
