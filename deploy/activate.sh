#!/bin/bash

# we are inside the dated releases directory

# create symlinks
parent_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )

source $parent_path/../config.sh

deploy_directory=$PWD


if [ "$is_laravel" = true ]; then

  # .env
#  if [ ! -f $deploy_directory/.env ]; then
#      sudo cp $parent_path/.env $deploy_directory/.env
#      sudo sed -i "s|APP_URL=.*|APP_URL=http://$app_domain|" $deploy_directory/.env
#  fi
  if [ ! -f .env ]; then
      sudo /bin/ln -sf $deploy_directory/symlinks/.env .env
  fi

  # public/cache
  if [ ! -d $deploy_directory/symlinks/public/cache ]; then
      sudo mkdir $deploy_directory/symlinks/public/cache
  fi
  if [ ! -d public/cache ]; then
      sudo /bin/ln -sf $deploy_directory/symlinks/publiccache public/cache
  fi

  # public/data
  if [ ! -d $deploy_directory/symlinks/public/data ]; then
      sudo mkdir $deploy_directory/symlinks/public/data
  fi
  if [ ! -d public/data ]; then
      sudo /bin/ln -sf $deploy_directory/symlinks/public/data public/data
  fi

  # storage
  if [ ! -d $deploy_directory/symlinks/storage ]; then
      sudo mkdir $deploy_directory/symlinks/storage
      sudo mkdir $deploy_directory/symlinks/storage/backups
      sudo mkdir $deploy_directory/symlinks/storage/app
      sudo mkdir $deploy_directory/symlinks/storage/framework
      sudo mkdir $deploy_directory/symlinks/storage/framework/cache
      sudo mkdir $deploy_directory/symlinks/storage/framework/sessions
      sudo mkdir $deploy_directory/symlinks/storage/framework/views
      sudo mkdir $deploy_directory/symlinks/storage/logs
  fi
  sudo /bin/rm -rf storage
  sudo /bin/ln -sf $deploy_directory/symlinks/storage storage
fi

cd $deploy_directory
unlink current
ln -sf $deploy_directory/releases/$foldername current

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
