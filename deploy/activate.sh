#!/bin/bash

# we are inside the dated releases directory

# create symlinks
parent_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )

deploy_directory=$PWD
echo "pwd=$PWD"
echo "deploy_director=$deploy_directory"
echo "parent_path=$parent_path"
echo "is_laravel="$is_laravel
#
#if [ "$is_laravel" = true ]; then
#
#  # .env
#  if [ ! -f $deploy_directory/.env ]; then
#      sudo cp $parent_path/.env $deploy_directory/.env
#      sudo sed -i "s|APP_URL=.*|APP_URL=http://$app_domain|" $deploy_directory/.env
#  fi
#
#  if [ ! -f .env ]; then
#      sudo /bin/ln -sf $deploy_directory/.env .env
#  fi
#
#  if [ ! -d $deploy_directory/cache ]; then
#      sudo mkdir $deploy_directory/cache
#  fi
#  if [ ! -d public/cache ]; then
#      sudo /bin/ln -sf $deploy_directory/cache public/cache
#  fi
#
#  if [ ! -d $deploy_directory/data ]; then
#      sudo mkdir $deploy_directory/data
#  fi
#  if [ ! -d public/data ]; then
#      sudo /bin/ln -sf $deploy_directory/data public/data
#  fi
#
#  if [ ! -d $deploy_directory/storage ]; then
#      sudo mkdir $deploy_directory/storage
#      sudo mkdir $deploy_directory/storage/backups
#      sudo mkdir $deploy_directory/storage/app
#      sudo mkdir $deploy_directory/storage/framework
#      sudo mkdir $deploy_directory/storage/framework/cache
#      sudo mkdir $deploy_directory/storage/framework/sessions
#      sudo mkdir $deploy_directory/storage/framework/views
#      sudo mkdir $deploy_directory/storage/logs
#  fi
#
#  sudo /bin/rm -rf storage
#  sudo /bin/ln -sf $deploy_directory/storage storage
#fi
#
#cd $deploy_directory
#sudo /usr/bin/unlink current
#sudo /bin/ln -sf $deploy_directory/releases/$foldername current
#
#sudo chown -R $username:$username $deploy_directory
#
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
