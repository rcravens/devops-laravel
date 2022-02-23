#!/bin/bash

username=$1

# Install Nginx
sudo apt-get install -y --allow-downgrades --allow-remove-essential --allow-change-held-packages nginx

sudo rm /etc/nginx/sites-enabled/default
sudo rm /etc/nginx/sites-available/default

# Create a configuration file for Nginx overrides.
sudo mkdir -p /home/$username/.config/nginx
sudo chown -R $username:$username /home/$username
sudo touch /home/$username/.config/nginx/nginx.conf
sudo ln -sf /home/$username/.config/nginx/nginx.conf /etc/nginx/conf.d/nginx.conf

# Disable XDebug On The CLI
sudo phpdismod -s cli xdebug

# Set The Nginx & PHP-FPM User
sudo sed -i "s/user www-data;/user $username;/" /etc/nginx/nginx.conf
sudo sed -i "s/# server_names_hash_bucket_size.*/server_names_hash_bucket_size 64;/" /etc/nginx/nginx.conf


sudo service nginx restart
sudo service php8.0-fpm restart