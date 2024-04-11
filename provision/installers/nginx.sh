#!/bin/bash

# Install Nginx
sudo apt install -y nginx

# Remove the default site
sudo rm /etc/nginx/sites-enabled/default
#sudo rm /etc/nginx/sites-available/default

# Restart nginx
sudo service nginx restart