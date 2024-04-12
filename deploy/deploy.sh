#!/bin/bash

function title {
    echo "-------------------------------------"
    echo ""
    echo "$1"
    echo ""
    echo "-------------------------------------"
}

title "Deploying...."

# Save current directory and cd into script path
initial_working_directory=$(pwd)
parent_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
cd "$parent_path"

# Load the config file
source $parent_path/../config.sh

deploy_directory=/home/$username/deployments

date_string=$(date +"%Y-%m-%d-%H-%M-%S")
remote_hash='xxx'
local_hash='yyy'
sudo su - $username <<DEPLOY
if [ ! -d $deploy_directory ]; then
  mkdir -p $deploy_directory
fi

echo "date_string=$date_string"

# git short hash of remote repo
if [ -d $deploy_directory/current ]; then
  cd $deploy_directory/current/
  remote_git_line=$(git ls-remote | head -n 1)
  remote_hash=${remote_git_line:0:7}
  local_hash=$(git rev-parse --short HEAD 2> /dev/null | sed "s/\(.*\)/\1/")
  echo "remote_hash=$remote_hash, local_hash=$local_hash"
#  if [ $remote_hash = $local_hash ]; then
#    echo "Nothing new to deploy."
#    exit 1
#  fi
fi

# create a directory for git clone
foldername="$date_string-$remote_hash"
echo "Deploying: $foldername"

# create the directory structure
if [ ! -d $deploy_directory/releases ]; then
    mkdir -p $deploy_directory/releases
fi
cd $deploy_directory/releases
echo  "folder=$deploy_directory/releases/$foldername"

# git clone into this new directory
#git clone --depth 1 $repo $foldername
#cd $deploy_directory/releases/$foldername

# create symlinks
#title "Create symlinks"
#source $parent_path/create_symlinks.sh

# build the application
#source $parent_path/build.sh

# Activate this version
#title "Activate"
#source $parent_path/activate.sh


## restart services
#title "Restarting"
#source $parent_path/restart.sh
#
## cleanup
#title "Cleanup"
#source $parent_path/clean_up.sh
DEPLOY

# Return back to the original directory
cd $initial_working_directory
