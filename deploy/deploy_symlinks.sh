#!/bin/bash

# Save current directory and cd into script path
parent_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )

# Load the helpers
source $parent_path/../common/helpers.sh

# Load the config file
source $parent_path/../config.sh

# Assumption: We are in the deployed directory
status "Current Directory: $PWD"

if [ "$is_laravel" = true ]; then

  # .env
  if [ ! -f $deploy_directory/symlinks/.env ]; then
      error "-----------------------MISSING .env---------------------------"
      error "Create a .env file for the laravel application in the following location:"
      error $deploy_directory/symlinks/.env
      error "Then perform a new deployment using the deploy.sh script"
      error "-----------------------MISSING .env---------------------------"
  fi
  if [ -f $deploy_directory/symlinks/.env ]; then
    if [ -f .env ]; then
      rm .env
    fi
    ln -sf $deploy_directory/symlinks/.env .env
    status ".env symlink created"
  fi

  # sqlite
  if [ -f $deploy_directory/symlinks/database.sqlite ]; then
    if [ -f database/database.sqlite ]; then
      rm database/database.sqlite
    fi
    ln -sf $deploy_directory/symlinks/database.sqlite database/database.sqlite
    status "database.sqlite symlink created"
  fi

  # public/cache
  if [ -d $deploy_directory/symlinks/public/cache ]; then
    if [ -d public/cache ]; then
      rm -rf public/cache
    fi
      ln -sf $deploy_directory/symlinks/public/cache public/cache
      status "public/cache symlink created"
  fi

  # public/data
  if [ -d $deploy_directory/symlinks/public/data ]; then
    if [ -d public/data ]; then
      rm -rf public/data
    fi
    ln -sf $deploy_directory/symlinks/public/data public/data
    status "public/data symlink created"
  fi

  # storage
  if [ -d $deploy_directory/symlinks/storage ]; then
    if [ -d storage ]; then
      rm -rf storage
    fi
    ln -sf $deploy_directory/symlinks/storage storage
    status "storage symlink created"
  fi
fi