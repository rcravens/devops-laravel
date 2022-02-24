#!/bin/bash

# we are inside the dated releases directory

# create symlinks

if [ "$is_laravel" = true ]; then
  if [ ! -f .env ]; then
      sudo /bin/ln -sf $deploy_directory/.env .env
  fi

  if [ ! -d $deploy_directory/cache ]; then
      sudo mkdir $deploy_directory/cache
      sudo chown -R $username:$username $deploy_directory/cache
  fi
  if [ ! -d public/cache ]; then
      sudo -u $username /bin/ln -sf $deploy_directory/cache public/cache
  fi

  if [ ! -d $deploy_directory/data ]; then
      sudo mkdir $deploy_directory/data
      sudo chown -R $username:$username $deploy_directory/data
  fi
  if [ ! -d public/data ]; then
      sudo /bin/ln -sf $deploy_directory/data public/data
  fi

  if [ ! -d $deploy_directory/storage ]; then
      sudo mkdir $deploy_directory/storage
      sudo mkdir $deploy_directory/storage/backups
      sudo mkdir $deploy_directory/storage/app
      sudo mkdir $deploy_directory/storage/framework
      sudo mkdir $deploy_directory/storage/framework/cache
      sudo mkdir $deploy_directory/storage/framework/sessions
      sudo mkdir $deploy_directory/storage/framework/views
      sudo mkdir $deploy_directory/storage/logs
      sudo /bin/chown -R $username:$username $deploy_directory/storage
  fi

  sudo /bin/rm -rf storage
  sudo /bin/ln -sf $deploy_directory/storage storage
fi

cd $deploy_directory
sudo /usr/bin/unlink current
sudo /bin/ln -sf $deploy_directory/releases/$foldername current
sudo chown $username:$username $deploy_directory/current

