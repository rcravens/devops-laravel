#!/bin/bash

# Save current directory and cd into script path
initial_working_directory=$(pwd)
parent_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
cd "$parent_path"

# Load the config file
source ../config.sh

# Auto restart services
sudo sed -i 's/#$nrconf{restart} = '"'"'i'"'"';/$nrconf{restart} = '"'"'a'"'"';/g' /etc/needrestart/needrestart.conf

# Update Package List
sudo apt update

# Update System Packages
sudo apt upgrade -y

# Install Some Basic Packages....TODO: FILTER THROUGH THESE
sudo apt-get install -y software-properties-common curl gnupg debian-keyring debian-archive-keyring apt-transport-https \
ca-certificates build-essential dos2unix gcc git git-lfs libmcrypt4 libpcre3-dev libpng-dev chrony make pv \
python3-pip re2c supervisor unattended-upgrades whois vim cifs-utils bash-completion zsh zip unzip expect

# Install Nginx
source ./installers/nginx.sh

# Install PHP
php_version=8.3
source ./installers/php$php_version.sh

# Install composer
source ./installers/composer.sh

# Install node
source ./installers/node.sh

# Install redis
source ./installers/redis.sh

# Install sqlite
source ./installers/sqlite.sh

# Install either mysql or mariadb (cannot install both)
source ./installers/mysql.sh
#source ./installers/mariadb.sh

# Install certbot
source ./installers/certbot.sh

# Create deployment user
#sudo userdel -r $username
#sudo newusers users.txt
#sudo usermod -aG sudo $username
#sudo usermod -aG adm $username
#sudo usermod -aG www-data $username
#sudo mkdir /home/$username/.config
#sudo chown -R $username:$username /home/$username/.config


# Force Locale
#echo "LC_ALL=en_US.UTF-8" >> /etc/default/locale
#locale-gen en_US.UTF-8

# Set My Timezone
#sudo ln -sf /usr/share/zoneinfo/UTC /etc/localtime

# Install apache
#source ./installers/apache.sh

# Install memcache
#source ./installers/memcache.sh

# Install beanstalk
#source ./installers/beanstalk.sh

# Install mailhog
#source ./installers/mailhog.sh

# Install ngrok
#source ./installers/ngrok.sh

# Install postfix
#source ./installers/postfix.sh

# One last upgrade check
sudo apt upgrade -y

# Clean Up
sudo apt -y autoremove
sudo apt -y clean

# Return back to the original directory
cd $initial_working_directory


