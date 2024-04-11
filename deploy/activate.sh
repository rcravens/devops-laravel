#!/bin/bash

# we are inside the dated releases directory

# create symlinks
parent_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )

source $parent_path/../config.sh

deploy_directory=/home/$username/deployments

if [ "$is_laravel" = true ]; then

  # .env
  if [ ! -f $deploy_directory/symlinks/.env ]; then
      echo "-----------------------MISSING .env---------------------------"
      echo "Create a .env file for the laravel application in the following location:"
      echo $deploy_directory/symlinks/.env
      echo "-----------------------MISSING .env---------------------------"
  fi
  if [ ! -f .env ]; then
      ln -sf $deploy_directory/symlinks/.env .env
  fi

  # public/cache
  if [ ! -d $deploy_directory/symlinks/public/cache ]; then
      mkdir $deploy_directory/symlinks/public/cache
  fi
  if [ ! -d public/cache ]; then
      ln -sf $deploy_directory/symlinks/public/cache public/cache
  fi

  # public/data
  if [ ! -d $deploy_directory/symlinks/public/data ]; then
      mkdir $deploy_directory/symlinks/public/data
  fi
  if [ ! -d public/data ]; then
      ln -sf $deploy_directory/symlinks/public/data public/data
  fi

  # storage
  if [ ! -d $deploy_directory/symlinks/storage ]; then
      mkdir $deploy_directory/symlinks/storage
      mkdir $deploy_directory/symlinks/storage/backups
      mkdir $deploy_directory/symlinks/storage/app
      mkdir $deploy_directory/symlinks/storage/framework
      mkdir $deploy_directory/symlinks/storage/framework/cache
      mkdir $deploy_directory/symlinks/storage/framework/sessions
      mkdir $deploy_directory/symlinks/storage/framework/views
      mkdir $deploy_directory/symlinks/storage/logs
  fi
  rm -rf storage
  ln -sf $deploy_directory/symlinks/storage storage
fi

if [ -f $deploy_directory/current ]; then
  unlink $deploy_directory/current
fi
ln -sf $PWD $deploy_directory/current
