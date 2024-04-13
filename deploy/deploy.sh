#!/bin/bash

# Save current directory and cd into script path
initial_working_directory=$(pwd)
my_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
cd $my_path

# Load the helpers
source $my_path/../common/helpers.sh

# Load the config file
source $my_path/../config.sh

# Application to deploy is same as current username
app_name=$(whoami)

# Load the application config file
source $my_path/../common/app_config.sh

echo "here we are"
exit

# Assuming this file is being run as the deployment user
current_user=$(whoami)
if [ ! "$username" == "$current_user" ]; then
  error "Expected user: $username"
  error "Current user: $current_user"
  error "Try running like sudo -u app_name deploy.sh"
  exit 1
fi


title "Starting Deployment: $username"

# Initialize the deployment directory structure
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
source $my_path/deploy_symlinks.sh

# Build the application
title "Building"

status "Composer Install"
composer install

status "NPM Install"
npm install

status "Migrations"
php artisan migrate --force

status "Build Front End Assets"
npm run build

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

# publish git hash into .env
title "Updating GIT_HASH in the .env"
if [ -f $deploy_directory/symlinks/.env ]; then
  echo "remote_hash=$remote_hash"
  sed -i "s|GIT_HASH=.*|GIT_HASH=$remote_hash|" $deploy_directory/symlinks/.env
fi

# Return back to the original directory
cd $initial_working_directory
