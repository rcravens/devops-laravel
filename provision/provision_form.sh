#!/bin/bash

# Save current directory and cd into script path
initial_working_directory=$(pwd)
my_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )

# Load common
source $my_path/../common/helpers.sh

title "Create Provisioning Configuration"

swap_space=0
read -p "Create swap space? " answer
if [ "$answer" != "${answer#[Yy]}" ] ;then
    swap_space=1
fi

nginx=0
read -p "Install Nginx? " answer
if [ "$answer" != "${answer#[Yy]}" ] ;then
    nginx=1
fi

php=0
php_version=8.3
read -p "Install Nginx? " answer
if [ "$answer" != "${answer#[Yy]}" ] ;then
    php=1
    read -p "Which PHP version (e.g., 8.3)? " php_version
fi

composer=0
read -p "Install Composer? " answer
if [ "$answer" != "${answer#[Yy]}" ] ;then
    composer=1
fi

node_and_npm=0
read -p "Install Node and NPM? " answer
if [ "$answer" != "${answer#[Yy]}" ] ;then
    node_and_npm=1
fi

redis=0
read -p "Install Redis? " answer
if [ "$answer" != "${answer#[Yy]}" ] ;then
    redis=1
fi

sqlite=0
read -p "Install SQlite? " answer
if [ "$answer" != "${answer#[Yy]}" ] ;then
    sqlite=1
fi

mysql=0
mariadb=0
db_root_password=secret
read -p "Install MySql? " answer
if [ "$answer" != "${answer#[Yy]}" ] ;then
    mysql=1
    read -p "DB root password? " db_root_password
else
  read -p "Install MariaDB? " answer
  if [ "$answer" != "${answer#[Yy]}" ] ;then
      mariadb=1
      read -p "DB root password? " db_root_password
  fi
fi

certbot=0
read -p "Install Certbot? " answer
if [ "$answer" != "${answer#[Yy]}" ] ;then
    certbot=1
fi

apache=0
read -p "Install Apache? " answer
if [ "$answer" != "${answer#[Yy]}" ] ;then
    apache=1
fi

memcache=0
read -p "Install MemCache? " answer
if [ "$answer" != "${answer#[Yy]}" ] ;then
    memcache=1
fi

beanstalk=0
read -p "Install Beanstalk? " answer
if [ "$answer" != "${answer#[Yy]}" ] ;then
    beanstalk=1
fi

mailhog=0
read -p "Install Mailhog? " answer
if [ "$answer" != "${answer#[Yy]}" ] ;then
    mailhog=1
fi

ngrok=0
read -p "Install Ngrok? " answer
if [ "$answer" != "${answer#[Yy]}" ] ;then
    ngrok=1
fi

postfix=0
read -p "Install Postfix? " answer
if [ "$answer" != "${answer#[Yy]}" ] ;then
    postfix=1
fi

config_file=$my_path/../config.sh

# Create the new app config
sudo sed -i "s|swap_space=|swap_space=$swap_space|" $config_file
sudo sed -i "s|nginx=|nginx=$nginx|" $config_file
sudo sed -i "s|php=|php=$php|" $config_file
sudo sed -i "s|php_version=|php_version=$php_version|" $config_file
sudo sed -i "s|composer=|composer=$composer|" $config_file
sudo sed -i "s|node_and_npm=|node_and_npm=$node_and_npm|" $config_file
sudo sed -i "s|redis=|redis=$redis|" $config_file
sudo sed -i "s|sqlite=|sqlite=$sqlite|" $config_file
sudo sed -i "s|mysql=|mysql=$mysql|" $config_file
sudo sed -i "s|mariadb=|mariadb=$mariadb|" $config_file
sudo sed -i "s|db_root_password=|db_root_password=$db_root_password|" $config_file
sudo sed -i "s|certbot=|certbot=$certbot|" $config_file
sudo sed -i "s|apache=|apache=$apache|" $config_file
sudo sed -i "s|memcache=|memcache=$memcache|" $config_file
sudo sed -i "s|beanstalk=|beanstalk=$beanstalk|" $config_file
sudo sed -i "s|mailhog=|mailhog=$mailhog|" $config_file
sudo sed -i "s|ngrok=|ngrok=$ngrok|" $config_file
sudo sed -i "s|postfix=|postfix=$postfix|" $config_file

title "Status"
if [ -f $config_file ]; then
  echo "A new application config file has been created at:"
  status "$config_file"
  echo ""
  echo ""
  echo "Next Steps:"
  status "1. Review the config file"
  status "2. Provision the server by running ./provision/provision_ubuntu_20_04.sh"
else
  error "Failed to create provisioning config file."
fi

# Return back to the original directory
cd $initial_working_directory || exit
