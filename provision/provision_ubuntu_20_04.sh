#!/bin/bash

# Save current directory and cd into script path
initial_working_directory=$(pwd)
parent_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
echo "parent_path = $parent_path"
echo "first var = $0"
echo "second var = $1"
cd $parent_path

exit 1

# Load the config file
source ./config.sh

# Create deployment user
username=deploy
sudo userdel -r $username
sudo newusers users.txt
sudo usermod -aG sudo $username
sudo usermod -aG adm $username
sudo usermod -aG www-data $username
sudo mkdir /home/$username/.config
sudo chown -R $username:$username /home/$username/.config

# Update Package List
sudo apt-get update

# Update System Packages
sudo apt-get upgrade -y

# Force Locale
echo "LC_ALL=en_US.UTF-8" >> /etc/default/locale
locale-gen en_US.UTF-8

sudo apt-get install -y software-properties-common curl gnupg debian-keyring debian-archive-keyring apt-transport-https \
ca-certificates

# Install Some Basic Packages
sudo apt-get install -y build-essential dos2unix gcc git git-lfs libmcrypt4 libpcre3-dev libpng-dev chrony unzip make pv \
python3-pip re2c supervisor unattended-upgrades whois vim cifs-utils bash-completion zsh graphviz avahi-daemon tshark

# Set My Timezone
sudo ln -sf /usr/share/zoneinfo/UTC /etc/localtime

# Install all versions of PHP
source ./installers/php_all.sh $username

# Disable not used PHP FPM
sudo systemctl disable php5.6-fpm
sudo systemctl disable php7.0-fpm
sudo systemctl disable php7.1-fpm
sudo systemctl disable php7.2-fpm
sudo systemctl disable php7.3-fpm
sudo systemctl disable php7.4-fpm
sudo systemctl disable php8.1-fpm

sudo update-alternatives --set php /usr/bin/php8.0
sudo update-alternatives --set php-config /usr/bin/php-config8.0
sudo update-alternatives --set phpize /usr/bin/phpize8.0
sudo update-alternatives --set phar.phar /usr/bin/phar.phar7.2
sudo update-alternatives --set php-config /usr/bin/php-config7.2

# Install composer
source ./installers/composer.sh $username

# Install apache
source ./installers/apache.sh $username

# Install nginx
source ./installers/nginx.sh $username

# Install node
source ./installers/node.sh $username

# Install sqllite
source ./installers/sqlite.sh $username

# Return back to the original directory
cd $initial_working_directory


