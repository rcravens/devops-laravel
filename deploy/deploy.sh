#!/bin/bash

source ../helpers.sh

# Save current directory and cd into script path
initial_working_directory=$(pwd)
parent_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
cd "$parent_path"

# Load the config file
source $parent_path/../config.sh

# Assuming this file is being run as the deployment user
current_user=$(whoami)
if [ ! "$username" == "$current_user" ]; then
  error "Expected user: $username"
  error "Current user: $current_user"
  error "Try running like sudo -u $username deploy.sh"
  exit 1
fi


title "Starting Deployment: $username"

error "This is a test error"

# Initialize the deployment directory structure
deploy_directory=/home/$username/deployments
if [ ! -d $deploy_directory/releases ]; then
    mkdir -p $deploy_directory/releases
fi

# Deployments will be prefixed with the current timestamp
date_string=$(date +"%Y-%m-%d-%H-%M-%S")

# Deployments are post fixed with the shortened git hash
if [ -d $deploy_directory/current ]; then
  cd $deploy_directory/current/
  remote_git_line=$(git ls-remote | head -n 1)
  remote_hash=${remote_git_line:0:7}
  local_hash=$(git rev-parse --short HEAD 2> /dev/null | sed "s/\(.*\)/\1/")
  status "remote_hash=$remote_hash, local_hash=$local_hash"
  if [ $remote_hash = $local_hash ]; then
    status "No code changes detected...but deploying anyway!"
  fi
fi

# Create the directory name
foldername="$date_string-$remote_hash"
status "Folder Name: $foldername"
status "Deployment Directory: $deploy_directory/releases/$foldername"

# Git clone into this new directory
cd $deploy_directory/releases
git clone --depth 1 $repo $foldername
cd $deploy_directory/releases/$foldername

# Create symlinks for files that persist across deployments
title "Create Symlinks"
source $parent_path/create_symlinks.sh

# Build the application
title "Building"
source $parent_path/build.sh

# Activate this version
title "Activate"
if [[ -h $deploy_directory/current ]]; then
  current_link=$(readlink $deploy_directory/current)
  status "Unlinking: $current_link"
  unlink $deploy_directory/current
fi
status "  Linking: $deploy_directory/releases/$foldername"
ln -sf $deploy_directory/releases/$foldername $deploy_directory/current

# Cleanup Old Deployments
max_to_keep=6
title "Cleanup (keeping the most recent $max_to_keep deployments)"
ls -dt $deploy_directory/releases/* | tail -n +$max_to_keep | xargs rm -rf

# Return back to the original directory
cd $initial_working_directory
