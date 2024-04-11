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

## nginx conf
#if [ ! -f /etc/nginx/sites-available/laravel.conf ]; then
#    sudo cp $parent_path/laravel.conf /etc/nginx/sites-available/laravel.conf
#    sudo sed -i "s/server_name;/server_name $app_domain;/" /etc/nginx/sites-available/laravel.conf
#    sudo sed -i "s|root;|root $deploy_directory/current/public;|" /etc/nginx/sites-available/laravel.conf
#    sudo ln -s /etc/nginx/sites-available/laravel.conf /etc/nginx/sites-enabled/laravel.conf
#    sudo service nginx restart
#fi
#
## supervisor conf
#if [ ! -f /etc/supervisor/conf.d/horizon.conf ]; then
#    sudo cp $parent_path/horizon.conf /etc/supervisor/conf.d/horizon.conf
#    sudo sed -i "s|command=|command=php $deploy_directory/current/artisan horizon|" /etc/supervisor/conf.d/horizon.conf
#    sudo sed -i "s|user=|user=$username|" /etc/supervisor/conf.d/horizon.conf
#    sudo sed -i "s|stdout_logfile=|stdout_logfile=$deploy_directory/current/storage/logs/horizon.log|" /etc/supervisor/conf.d/horizon.conf
#    sudo supervisorctl reread
#    sudo supervisorctl update
#    sudo superviosrctl start horizon
#fi
