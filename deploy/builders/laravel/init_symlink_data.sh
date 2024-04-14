#!/bin/bash

# Assumption: We are in the deployed directory
echo "Current Directory: $PWD"
symlink_directory="$PWD/../../"
echo "Symlink directory: $symlink_directory"

# Save current directory and cd into script path
parent_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )

# Load the helpers
source $parent_path/../../../common/helpers.sh

# Load the config file
source $parent_path/../../../config.sh


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
source $parent_path/init_symlinks.sh