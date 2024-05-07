#!/bin/bash

# Save current directory and cd into script path
initial_working_directory=$(pwd)
parent_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
cd "$parent_path"

# Load the helpers
source $parent_path/../common/helpers.sh

# Load the config file
source $parent_path/../config.sh

# Auto restart services
title "Enabling Service Auto Restart"
sudo sed -i 's/#$nrconf{restart} = '"'"'i'"'"';/$nrconf{restart} = '"'"'a'"'"';/g' /etc/needrestart/needrestart.conf

# Update Package List
title "Update Package List"
sudo apt update

# Update System Packages
title "Upgrade Packages"
sudo apt upgrade -y

# Install Some Basic Packages....TODO: FILTER THROUGH THESE
title "Install Basic Packages"
sudo apt-get install -y software-properties-common curl gnupg debian-keyring debian-archive-keyring apt-transport-https \
ca-certificates build-essential dos2unix gcc git git-lfs libmcrypt4 libpcre3-dev libpng-dev chrony make pv \
python3-pip re2c supervisor unattended-upgrades whois vim cifs-utils bash-completion zsh zip unzip expect

# Create Swap Space
if [ $swap_space -eq 1 ]; then
  title "Create Swap Space"
  if [ -f /swapfile ]; then
    status "swapfile already exists"
  else
    total_ram=$(free -m | grep Mem: | awk '{print $2}')
    sudo fallocate -l ${total_ram}M /swapfile
    sudo chmod 600 /swapfile
    sudo mkswap /swapfile
    sudo swapon /swapfile
    status "swapfile created"
  fi
fi

# Install Nginx
if [ $nginx -eq 1 ]; then
  title "Install Nginx"
  source ./installers/nginx.sh
fi

if [ $php -eq 1 ]; then
  # Install PHP
  title "Install PHP Version: $php_version"
  source ./installers/php$php_version.sh
fi

if [ $composer -eq 1 ]; then
  # Install composer
  title "Install Composer"
  source ./installers/composer.sh
fi

if [ $node_and_npm -eq 1 ]; then
  # Install node
  title "Install Node and NPM"
  source ./installers/node.sh
fi

if [ $redis -eq 1 ]; then
  title "Install Redis"
  source ./installers/redis.sh
fi

if [ $sqlite -eq 1 ]; then
  title "Install SQLite"
  source ./installers/sqlite.sh
fi

if [ $mysql -eq 1 ]; then
  title "Install MySQL"
  source ./installers/mysql.sh
fi

if [ $mariadb -eq 1 ]; then
  title "Install MariaDB"
  source ./installers/mariadb.sh
fi

if [ $certbot -eq 1 ]; then
  title "Install Certbot (LetsEncrypt)"
  source ./installers/certbot.sh
fi

# Force Locale
#echo "LC_ALL=en_US.UTF-8" >> /etc/default/locale
#locale-gen en_US.UTF-8

# Set My Timezone
#sudo ln -sf /usr/share/zoneinfo/UTC /etc/localtime

if [ $apache -eq 1 ]; then
  title "Install apache"
  source ./installers/apache.sh
fi

if [ $memcache -eq 1 ]; then
  title "Install memcache"
  source ./installers/memcache.sh
fi

if [ $beanstalk -eq 1 ]; then
  title "Install beanstalk"
  source ./installers/beanstalk.sh
fi

if [ $mailhog -eq 1 ]; then
  title "Install mailhog"
  source ./installers/mailhog.sh
fi

if [ $ngrok -eq 1 ]; then
  title "Install ngrok"
  source ./installers/ngrok.sh
fi

if [ $postfix -eq 1 ]; then
  title "Install postfix"
  source ./installers/postfix.sh
fi

# One last upgrade check
title "One Last Upgrade Check"
sudo apt upgrade -y

# Clean Up
title "Clean Up"
sudo apt -y autoremove
sudo apt -y clean



title "Status Report"
status "Nginx Version: $(nginx -v)"
status "PHP VERSION: $(php -r 'echo PHP_VERSION;')"
status "Composer Version: $(composer -V)"
status "Node Version: $(node -v)"
status "NPM Version: $(npm -v)"
status "Redis Version: $(redis-cli -v)"
status "SQLite Version: $(sqlite3 --version)"
status "MySQL Version: $(mysql -V)"
status "Certbot Version: $(certbot --version)"
status "Swap Space: $(swapon --show)"

# Return back to the original directory
cd $initial_working_directory



