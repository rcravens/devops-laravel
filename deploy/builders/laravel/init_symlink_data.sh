#!/bin/bash

# Save current directory and cd into script path
my_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )

# Assumption: This is part of a deployment and is being run under the deployment user
app_name=$(whoami)

# Load common
source $my_path/../../../common/load_common.sh

symlink_directory=$deploy_directory/symlinks
echo "symlink_directory=$symlink_directory"

# Create the initial symlinked repository
if [ ! -d $symlink_directory ]; then
  mkdir -p $symlink_directory
fi
if [ "$app_type" = "laravel" ]; then

  if [ ! -f $symlink_directory/.env ]; then
    cp .env $symlink_directory/.env
  fi
  if [ ! -d $symlink_directory/public ]; then
   mkdir -p $symlink_directory/public
  fi
  if [ ! -d $symlink_directory/public/cache ]; then
   cp -r public/cache $symlink_directory/public/cache
  fi
  if [ ! -d $symlink_directory/public/data ]; then
   cp -r public/data $symlink_directory/public/data
  fi
  if [ ! -d $symlink_directory/storage ]; then
    cp -r storage $symlink_directory/storage
    mkdir -p $symlink_directory/storage
    mkdir -p $symlink_directory/storage/backups
    mkdir -p $symlink_directory/storage/app
    mkdir -p $symlink_directory/storage/framework
    mkdir -p $symlink_directory/storage/framework/cache
    mkdir -p $symlink_directory/storage/framework/sessions
    mkdir -p $symlink_directory/storage/framework/views
    mkdir -p $symlink_directory/storage/logs
  fi
  if [ ! -f $symlink_directory/database.sqlite ]; then
    cp -r database/database.sqlite $symlink_directory/database.sqlite
  fi
fi

# Activate the newly created symlink sources
title "Recreating Symlinks"
source $my_path/symlinks.sh