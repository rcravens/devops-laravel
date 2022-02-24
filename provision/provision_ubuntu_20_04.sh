#!/bin/bash

# Save current directory and cd into script path
initial_working_directory=$(pwd)
parent_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
cd "$parent_path"

# Load the config file
source ../config.sh

# Create deployment user
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
source ./installers/composer.sh

# Install apache
source ./installers/apache.sh

# Install nginx
source ./installers/nginx.sh

# Install node
source ./installers/node.sh

# Install sqlite
source ./installers/sqlite.sh

# Install mysql
#source ./installers/mysql.sh

# Install redis
source ./installers/redis.sh

# Install memcache
source ./installers/memcache.sh

# Install beanstalk
source ./installers/beanstalk.sh

# Install mailhog
source ./installers/mailhog.sh

# Install ngrok
source ./installers/ngrok.sh

# Install postfix
source ./installers/postfix.sh

# Configure Supervisor
sudo systemctl enable supervisor.service
sudo service supervisor start

# One last upgrade check
sudo apt-get upgrade -y

# Clean Up
sudo apt -y autoremove
sudo apt -y clean
sudo chown -R $username:$username /home/$username
sudo chown -R $username:$username /usr/local/bin

# Delete Linux source
sudo dpkg --list \
    | sudo awk '{ print $2 }' \
    | sudo grep linux-source \
    | sudo xargs apt-get -y purge;

# delete docs packages
sudo dpkg --list \
    | sudo awk '{ print $2 }' \
    | sudo grep -- '-doc$' \
    | sudo xargs apt-get -y purge;

# Delete obsolete networking
sudo apt-get -y purge ppp pppconfig pppoeconf

# Configure chronyd to fix clock-drift when VM-host sleeps/hibernates.
sudo sed -i "s/^makestep.*/makestep 1 -1/" /etc/chrony/chrony.conf

# Delete oddities
sudo apt-get -y purge popularity-contest installation-report command-not-found friendly-recovery laptop-detect

# Remove docs
sudo rm -rf /usr/share/doc/*

# Remove caches
sudo find /var/cache -type f -exec rm -rf {} \;

# delete any logs that have built up during the install
sudo find /var/log/ -name *.log -exec rm -f {} \;

# Disable sleep https://github.com/laravel/homestead/issues/1624
sudo systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target

# What are you doing Ubuntu?
# https://askubuntu.com/questions/1250974/user-root-cant-write-to-file-in-tmp-owned-by-someone-else-in-20-04-but-can-in
sudo sysctl fs.protected_regular=0

# Enable Swap Memory
sudo /bin/dd if=/dev/zero of=/var/swap.1 bs=1M count=1024
sudo /sbin/mkswap /var/swap.1
sudo /sbin/swapon /var/swap.1

# Return back to the original directory
cd $initial_working_directory


