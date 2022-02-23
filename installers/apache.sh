#!/bin/bash

username=$1

# Install Apache
apt-get install -y apache2 libapache2-mod-fcgid
sed -i "s/www-data/$username/" /etc/apache2/envvars

# Enable FPM
a2enconf php8.0-fpm

# Assume user wants mode_rewrite support
sudo a2enmod rewrite

# Turn on HTTPS support
sudo a2enmod ssl

# Turn on proxy & fcgi
sudo a2enmod proxy proxy_fcgi

# Turn on headers support
sudo a2enmod headers actions alias

# Add Mutex to config to prevent auto restart issues
if [ -z "$(grep '^Mutex posixsem$' /etc/apache2/apache2.conf)" ]
then
    echo 'Mutex posixsem' | sudo tee -a /etc/apache2/apache2.conf
fi

a2dissite 000-default
systemctl disable apache2