#!/bin/bash

# Save current directory and cd into script path
initial_working_directory=$(pwd)
parent_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
cd "$parent_path"

# Load the helpers
source $parent_path/../helpers.sh

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

# Install Nginx
title "Install Nginx"
source ./installers/nginx.sh
status "$(nginx -v)"

# Install PHP
title "Install PHP Version: $php_version"
source ./installers/php$php_version.sh
status "PHP VERSION: $(php -r 'echo PHP_VERSION;')"

# Install composer
title "Install Composer"
source ./installers/composer.sh
status "$(composer -V)"

# Install node
title "Install Node and NPM"
source ./installers/node.sh
status "Node Version: $(node -v)"
status "NPM Version: $(npm -v)"

# Install redis
title "Install Redis"
source ./installers/redis.sh
status "Redis Version: $(redis-cli -v)"

# Install sqlite
title "Install SQLite"
source ./installers/sqlite.sh
status "SQLite Version: $(sqlite3 --version)"

# Install either mysql or mariadb (cannot install both)
title "Install MySQL"
source ./installers/mysql.sh
status "MySQL Version: $(mysql -V)"
#source ./installers/mariadb.sh

# Install certbot
title "Install Certbot (LetsEncrypt)"
source ./installers/certbot.sh
status "Certbot Version: $(certbot --version)"

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
title "One Last Upgrade Check"
sudo apt upgrade -y

# Clean Up
title "Clean Up"
sudo apt -y autoremove
sudo apt -y clean

# Return back to the original directory
cd $initial_working_directory


