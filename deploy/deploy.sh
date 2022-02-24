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

{
    # git short hash of remote repo
    cd $deploy_directory/current/
    remote_git_line=$(git ls-remote | head -n 1)
    remote_hash=${remote_git_line:0:7}
    local_hash=$(git rev-parse --short HEAD 2> /dev/null | sed "s/\(.*\)/\1/")
    echo "remote_hash=$remote_hash, local_hash=$local_hash"
    if [ $remote_hash = $local_hash ]; then
      echo "Nothing new to deploy."
      exit 1
    fi

    # create a directory for git clone
    foldername=$remote_hash
    title "Deploying: $foldername"

    # create the directory structure
    if [ ! -d $deploy_directory/releases ]; then
        sudo mkdir -p $deploy_directory/releases
        sudo chown -R $username:$username $deploy_directory/releases
    fi
    cd $deploy_directory/releases
    echo  "folder=$deploy_directory/releases/$foldername"

    # git clone into this new directory
    sudo -u $username git clone --depth 1 $repo $foldername
    cd $deploy_directory/releases/$foldername
    sudo chown -R $username:$username $deploy_directory/releases/$foldername

    # composer install
    title "Dependencies"
    sudo -u $username /usr/bin/composer install
    sudo -u $username /usr/bin/npm install

    # create symlinks
    title "Activation"
    is_new_dot_env=false
    if [ ! -f $deploy_directory/.env ]; then
      is_new_dot_env=true
    fi
    source $parent_path/activate.sh

    # migrations
    if [ "$is_laravel" = true ]; then
      if [ ! -f $deploy_directory/.env ]; then
          echo "NO .env FILE FOUND AT $deploy_directory/.env"
      else
        title "Migrations"
        cd $deploy_directory/releases/$foldername
        if [ "$is_new_dot_env" = true ]; then
          sudo -u $username php artisan key:generate
        fi
        sudo -u $username php artisan migrate --force

        # publish git hash into .env
        if grep -Fxq "GIT_HASH=" $deploy_directory/.env
        then
          echo 'GIT_HASH= was found (new hash=$remote_hash)'
          sudo -u $username sed -i "s|GIT_HASH=.*;|GIT_HASH=$remote_hash|" $deploy_directory/.env
        else
          echo 'GIT_HASH= was not found'
          sudo -u $username bash -c 'echo "GIT_HASH=$remote_hash" >> $deploy_directory/.env'
        fi
      fi
    fi

    # restart services
    title "Restarting"
    source $parent_path/restart.sh

    # cleanup
    title "Cleanup"
    source $parent_path/clean_up.sh
} 2>&1

# Return back to the original directory
cd $initial_working_directory
