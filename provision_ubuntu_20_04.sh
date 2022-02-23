#!/bin/bash

# Create deployment user
username=deploy
sudo userdel -r $username
sudo newusers users.txt
sudo usermod -aG sudo $username
sudo usermod -aG adm $username

# Update Package List
sudo apt-get update

# Update System Packages
sudo apt-get upgrade -y

# Force Locale
echo "LC_ALL=en_US.UTF-8" >> /etc/default/locale
locale-gen en_US.UTF-8

sudo apt-get install -y software-properties-common curl gnupg debian-keyring debian-archive-keyring apt-transport-https \
ca-certificates

# Install Some PPAs
sudo apt-add-repository ppa:ondrej/php -y
sudo apt-add-repository ppa:chris-lea/redis-server -y

# NodeJS
curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -

## Update Package Lists
sudo apt-get update -y

# Install Some Basic Packages
sudo apt-get install -y build-essential dos2unix gcc git git-lfs libmcrypt4 libpcre3-dev libpng-dev chrony unzip make pv \
python3-pip re2c supervisor unattended-upgrades whois vim cifs-utils bash-completion zsh graphviz avahi-daemon tshark

# Set My Timezone
sudo ln -sf /usr/share/zoneinfo/UTC /etc/localtime

# Install Generic PHP packages
sudo apt-get install -y --allow-change-held-packages \
php-imagick php-memcached php-redis php-xdebug php-dev imagemagick mcrypt

# PHP 5.6
sudo apt-get install -y --allow-change-held-packages \
php5.6-bcmath php5.6-bz2 php5.6-cgi php5.6-cli php5.6-common php5.6-curl php5.6-dba php5.6-dev php5.6-enchant \
php5.6-fpm php5.6-gd php5.6-gmp php5.6-imap php5.6-interbase php5.6-intl php5.6-json php5.6-ldap php5.6-mbstring \
php5.6-mcrypt php5.6-mysql php5.6-odbc php5.6-opcache php5.6-pgsql php5.6-phpdbg php5.6-pspell php5.6-readline \
php5.6-recode php5.6-snmp php5.6-soap php5.6-sqlite3 php5.6-sybase php5.6-tidy php5.6-xml php5.6-xmlrpc php5.6-xsl \
php5.6-zip php5.6-imagick php5.6-memcached php5.6-redis

# Configure php.ini for CLI
sudo sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php/5.6/cli/php.ini
sudo sed -i "s/display_errors = .*/display_errors = On/" /etc/php/5.6/cli/php.ini
sudo sed -i "s/memory_limit = .*/memory_limit = 512M/" /etc/php/5.6/cli/php.ini
sudo sed -i "s/;date.timezone.*/date.timezone = UTC/" /etc/php/5.6/cli/php.ini

# Configure Xdebug
sudo echo "xdebug.remote_enable = 1" >> /etc/php/5.6/mods-available/xdebug.ini
sudo echo "xdebug.remote_connect_back = 1" >> /etc/php/5.6/mods-available/xdebug.ini
sudo echo "xdebug.remote_port = 9000" >> /etc/php/5.6/mods-available/xdebug.ini
sudo echo "xdebug.max_nesting_level = 512" >> /etc/php/5.6/mods-available/xdebug.ini
sudo echo "opcache.revalidate_freq = 0" >> /etc/php/5.6/mods-available/opcache.ini

# Configure php.ini for FPM
sudo sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php/5.6/fpm/php.ini
sudo sed -i "s/display_errors = .*/display_errors = On/" /etc/php/5.6/fpm/php.ini
sudo sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/php/5.6/fpm/php.ini
sudo sed -i "s/memory_limit = .*/memory_limit = 512M/" /etc/php/5.6/fpm/php.ini
sudo sed -i "s/upload_max_filesize = .*/upload_max_filesize = 100M/" /etc/php/5.6/fpm/php.ini
sudo sed -i "s/post_max_size = .*/post_max_size = 100M/" /etc/php/5.6/fpm/php.ini
sudo sed -i "s/;date.timezone.*/date.timezone = UTC/" /etc/php/5.6/fpm/php.ini

sudo printf "[openssl]\n" | sudo tee -a /etc/php/5.6/fpm/php.ini
sudo printf "openssl.cainfo = /etc/ssl/certs/ca-certificates.crt\n" | sudo tee -a /etc/php/5.6/fpm/php.ini

sudo printf "[curl]\n" | sudo tee -a /etc/php/5.6/fpm/php.ini
sudo printf "curl.cainfo = /etc/ssl/certs/ca-certificates.crt\n" | sudo tee -a /etc/php/5.6/fpm/php.ini

# Configure FPM
sudo sed -i "s/user = www-data/user = $username/" /etc/php/5.6/fpm/pool.d/www.conf
sudo sed -i "s/group = www-data/group = $username/" /etc/php/5.6/fpm/pool.d/www.conf
sudo sed -i "s/listen\.owner.*/listen.owner = $username/" /etc/php/5.6/fpm/pool.d/www.conf
sudo sed -i "s/listen\.group.*/listen.group = $username/" /etc/php/5.6/fpm/pool.d/www.conf
sudo sed -i "s/;listen\.mode.*/listen.mode = 0666/" /etc/php/5.6/fpm/pool.d/www.conf

# PHP 7.0
sudo apt-get install -y --allow-change-held-packages \
php7.0-bcmath php7.0-bz2 php7.0-cgi php7.0-cli php7.0-common php7.0-curl php7.0-dba php7.0-dev php7.0-enchant \
php7.0-fpm php7.0-gd php7.0-gmp php7.0-imap php7.0-interbase php7.0-intl php7.0-json php7.0-ldap php7.0-mbstring \
php7.0-mcrypt php7.0-mysql php7.0-odbc php7.0-opcache php7.0-pgsql php7.0-phpdbg php7.0-pspell php7.0-readline \
php7.0-recode php7.0-snmp php7.0-soap php7.0-sqlite3 php7.0-sybase php7.0-tidy php7.0-xml php7.0-xmlrpc php7.0-xsl \
php7.0-zip php7.0-imagick php7.0-memcached php7.0-redis

# Configure php.ini for CLI
sudo sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php/7.0/cli/php.ini
sudo sed -i "s/display_errors = .*/display_errors = On/" /etc/php/7.0/cli/php.ini
sudo sed -i "s/memory_limit = .*/memory_limit = 512M/" /etc/php/7.0/cli/php.ini
sudo sed -i "s/;date.timezone.*/date.timezone = UTC/" /etc/php/7.0/cli/php.ini

# Configure Xdebug
sudo echo "xdebug.remote_enable = 1" >> /etc/php/7.0/mods-available/xdebug.ini
sudo echo "xdebug.remote_connect_back = 1" >> /etc/php/7.0/mods-available/xdebug.ini
sudo echo "xdebug.remote_port = 9000" >> /etc/php/7.0/mods-available/xdebug.ini
sudo echo "xdebug.max_nesting_level = 512" >> /etc/php/7.0/mods-available/xdebug.ini
sudo echo "opcache.revalidate_freq = 0" >> /etc/php/7.0/mods-available/opcache.ini

# Configure php.ini for FPM
sudo sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php/7.0/fpm/php.ini
sudo sed -i "s/display_errors = .*/display_errors = On/" /etc/php/7.0/fpm/php.ini
sudo sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/php/7.0/fpm/php.ini
sudo sed -i "s/memory_limit = .*/memory_limit = 512M/" /etc/php/7.0/fpm/php.ini
sudo sed -i "s/upload_max_filesize = .*/upload_max_filesize = 100M/" /etc/php/7.0/fpm/php.ini
sudo sed -i "s/post_max_size = .*/post_max_size = 100M/" /etc/php/7.0/fpm/php.ini
sudo sed -i "s/;date.timezone.*/date.timezone = UTC/" /etc/php/7.0/fpm/php.ini

sudo printf "[openssl]\n" | sudo tee -a /etc/php/7.0/fpm/php.ini
sudo printf "openssl.cainfo = /etc/ssl/certs/ca-certificates.crt\n" | sudo tee -a /etc/php/7.0/fpm/php.ini
sudo printf "[curl]\n" | sudo tee -a /etc/php/7.0/fpm/php.ini
sudo printf "curl.cainfo = /etc/ssl/certs/ca-certificates.crt\n" | sudo tee -a /etc/php/7.0/fpm/php.ini

# Configure FPM
sudo sed -i "s/user = www-data/user = vagrant/" /etc/php/7.0/fpm/pool.d/www.conf
sudo sed -i "s/group = www-data/group = vagrant/" /etc/php/7.0/fpm/pool.d/www.conf
sudo sed -i "s/listen\.owner.*/listen.owner = vagrant/" /etc/php/7.0/fpm/pool.d/www.conf
sudo sed -i "s/listen\.group.*/listen.group = vagrant/" /etc/php/7.0/fpm/pool.d/www.conf
sudo sed -i "s/;listen\.mode.*/listen.mode = 0666/" /etc/php/7.0/fpm/pool.d/www.conf