#!/bin/bash

# we are inside the dated releases directory

# create symlinks

if [ "$is_laravel" = true ]; then

  # initial setup
  if [ ! -f $deploy_directory/.env ]; then
      sudo cp $parent_path/.env $deploy_directory/.env
      sudo sed -i "s|APP_URL=.*|APP_URL=http://$app_domain|" $deploy_directory/.env
  fi
  if [ ! -f /etc/nginx/sites-available/laravel.conf ]; then
      sudo cp $parent_path/laravel.conf /etc/nginx/sites-available/laravel.conf
      sudo sed -i "s/server_name;/server_name $app_domain;/" /etc/nginx/sites-available/laravel.conf
      sudo sed -i "s|root;|root $deploy_directory/current/public;|" /etc/nginx/sites-available/laravel.conf
      sudo ln -s /etc/nginx/sites-available/laravel.conf /etc/nginx/sites-enabled/laravel.conf
      sudo service nginx restart
  fi

  if [ ! -f .env ]; then
      sudo /bin/ln -sf $deploy_directory/.env .env
  fi

  if [ ! -d $deploy_directory/cache ]; then
      sudo mkdir $deploy_directory/cache
  fi
  if [ ! -d public/cache ]; then
      sudo /bin/ln -sf $deploy_directory/cache public/cache
  fi

  if [ ! -d $deploy_directory/data ]; then
      sudo mkdir $deploy_directory/data
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
  fi

  sudo /bin/rm -rf storage
  sudo /bin/ln -sf $deploy_directory/storage storage
fi

cd $deploy_directory
sudo /usr/bin/unlink current
sudo /bin/ln -sf $deploy_directory/releases/$foldername current

sudo chown -R $username:$username $deploy_directory