#!/bin/bash

# Save current directory and cd into script path
parent_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )

# Load the helpers
source $parent_path/../common/helpers.sh

# Load the config file
source $parent_path/../config.sh

cd $deploy_directory/current/

# Create the initial symlinked repository
if [ ! -d $deploy_directory/symlinks ]; then
  mkdir -p $deploy_directory/symlinks
fi
if [ "$app_type" = "laravel" ]; then

  if [ ! -f $deploy_directory/symlinks/.env ]; then
    cp .env $deploy_directory/symlinks/.env
  fi
  if [ ! -d $deploy_directory/symlinks/public ]; then
   mkdir -p $deploy_directory/symlinks/public
  fi
  if [ ! -d $deploy_directory/symlinks/public/cache ]; then
   cp -r public/cache $deploy_directory/symlinks/public/cache
  fi
  if [ ! -d $deploy_directory/symlinks/public/data ]; then
   cp -r public/data $deploy_directory/symlinks/public/data
  fi
  if [ ! -d $deploy_directory/symlinks/storage ]; then
    cp -r storage $deploy_directory/symlinks/storage
    mkdir -p $deploy_directory/symlinks/storage
    mkdir -p $deploy_directory/symlinks/storage/backups
    mkdir -p $deploy_directory/symlinks/storage/app
    mkdir -p $deploy_directory/symlinks/storage/framework
    mkdir -p $deploy_directory/symlinks/storage/framework/cache
    mkdir -p $deploy_directory/symlinks/storage/framework/sessions
    mkdir -p $deploy_directory/symlinks/storage/framework/views
    mkdir -p $deploy_directory/symlinks/storage/logs
  fi
  if [ ! -f $deploy_directory/symlinks/database.sqlite ]; then
    cp -r database/database.sqlite $deploy_directory/symlinks/database.sqlite
  fi
fi

# Activate the newly created symlink sources
title "Recreating Symlinks"
source $parent_path/deploy_symlinks.sh