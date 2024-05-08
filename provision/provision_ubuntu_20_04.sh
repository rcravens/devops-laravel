#!/bin/bash

# Save current directory and cd into script path
initial_working_directory=$(pwd)
parent_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
cd "$parent_path"

# Load the helpers
source $parent_path/../common/helpers.sh

# Load the config file (yaml)
source $parent_path/../common/parse_yaml.sh
eval $(parse_yaml $parent_path/../config.yml)

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
title "Create Swap Space"
case $installs_swapspace in
  [yY][eE][sS]|[yY])
    if [ -f /swapfile ]; then
      status "swapfile already exists"
    else
      total_ram=$(free -m | grep Mem: | awk '{print $2}')
      sudo fallocate -l ${total_ram}M /swapfile
      sudo chmod 600 /swapfile
      sudo mkswap /swapfile
      sudo swapon /swapfile
      status "swapfile created"
    fi;;
  *)
    status "not creating swap space";;
esac

title "Install Nginx"
case $installs_nginx in
  [yY][eE][sS]|[yY])
    source ./installers/nginx.sh
    status "nginx installed";;
  *)
    status "not installing nginx";;
esac

title "Install PHP Version"
case $installs_php_install in
  [yY][eE][sS]|[yY])
    source "./installers/php${installs_php_version}.sh"
    status "php$installs_php_version installed";;
  *)
    status "not installing php$installs_php_version";;
esac

title "Install Composer"
case $installs_php_composer in
  [yY][eE][sS]|[yY])
  source ./installers/composer.sh
  status "composer installed";;
  *)
  status "not installing composer";;
esac

title "Install Node and NPM"
case $installs_node_and_npm in
  [yY][eE][sS]|[yY])
  source ./installers/node.sh
  status "node installed";;
  *)
  status "not installing node";;
esac

title "Install Redis"
case $installs_redis in
  [yY][eE][sS]|[yY])
  source ./installers/redis.sh
  status "redis installed";;
  *)
  status "not installing redis";;
esac

if [ $sqlite -eq 1 ]; then
  title "Install SQLite"
  source ./installers/sqlite.sh
fi

title "Install MySQL"
case $installs_database_mysql in
  [yY][eE][sS]|[yY])
  source ./installers/mysql.sh
  status "mysql installed";;
  *)
  status "not installing mysql";;
esac

title "Install MariaDB"
case $installs_database_mariadb in
  [yY][eE][sS]|[yY])
  source ./installers/mariadb.sh
  status "mariadb installed";;
  *)
  status "not installing mariadb";;
esac

title "Install Certbot (LetsEncrypt)"
case $installs_certbot in
  [yY][eE][sS]|[yY])
  source ./installers/certbot.sh
  status "certbot installed";;
  *)
  status "not installing certbot";;
esac

# Force Locale
#echo "LC_ALL=en_US.UTF-8" >> /etc/default/locale
#locale-gen en_US.UTF-8

# Set My Timezone
#sudo ln -sf /usr/share/zoneinfo/UTC /etc/localtime

title "Install apache"
case $installs_apache in
  [yY][eE][sS]|[yY])
  source ./installers/apache.sh
  status "apache installed";;
  *)
  status "not installing apache";;
esac

title "Install memcache"
case $installs_memcache in
  [yY][eE][sS]|[yY])
  source ./installers/memcache.sh
  status "memcache installed";;
  *)
  status "not installing memcache";;
esac

title "Install beanstalk"
case $installs_beanstalk in
  [yY][eE][sS]|[yY])
  source ./installers/beanstalk.sh
  status "beanstalk installed";;
  *)
  status "not installing beanstalk";;
esac

title "Install mailhog"
case $installs_mailhog in
  [yY][eE][sS]|[yY])
  source ./installers/mailhog.sh
  status "mailhog installed";;
  *)
  status "not installing mailhog";;
esac

title "Install ngrok"
case $installs_mailhog in
  [yY][eE][sS]|[yY])
  source ./installers/ngrok.sh
  status "ngrok installed";;
  *)
  status "not installing ngrok";;
esac

title "Install postfix"
case $installs_postfix in
  [yY][eE][sS]|[yY])
  source ./installers/postfix.sh
  status "postfix installed";;
  *)
  status "not installing postfix";;
esac

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



