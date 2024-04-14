#!/bin/bash

# Install Some PPAs
sudo apt-add-repository ppa:ondrej/php -y

# Update Package Lists
sudo apt-get update -y

# Install Generic PHP packages...TODO: Filter these out
sudo apt-get install -y --allow-change-held-packages \
php-imagick php-memcached php-redis php-xdebug php-dev imagemagick mcrypt

# PHP 8.3
sudo apt-get install -y --allow-change-held-packages \
php8.3 php8.3-bcmath php8.3-bz2 php8.3-cgi php8.3-cli php8.3-common php8.3-curl php8.3-dba php8.3-dev \
php8.3-enchant php8.3-fpm php8.3-gd php8.3-gmp php8.3-imap php8.3-interbase php8.3-intl php8.3-ldap \
php8.3-mbstring php8.3-mysql php8.3-odbc php8.3-opcache php8.3-pgsql php8.3-phpdbg php8.3-pspell php8.3-readline \
php8.3-snmp php8.3-soap php8.3-sqlite3 php8.3-sybase php8.3-tidy php8.3-xdebug php8.3-xml php8.3-xmlrpc php8.3-xsl \
php8.3-zip php8.3-memcached php8.3-redis

# Backup files we are about to modify
if [ ! -f /etc/php/8.3/cli/php.ini.bak ]; then
  sudo cp /etc/php/8.3/cli/php.ini /etc/php/8.3/cli/php.ini.bak
fi
if [ ! -f /etc/php/8.3/fpm/php.ini.bak ]; then
  sudo cp /etc/php/8.3/fpm/php.ini /etc/php/8.3/fpm/php.ini.bak
fi
if [ ! -f /etc/php/8.3/mods-available/xdebug.ini.bak ]; then
  sudo cp /etc/php/8.3/mods-available/xdebug.ini /etc/php/8.3/mods-available/xdebug.ini.bak
fi
if [ ! -f /etc/php/8.3/mods-available/opcache.ini.bak ]; then
  sudo cp /etc/php/8.3/mods-available/opcache.ini /etc/php/8.3/mods-available/opcache.ini.bak
fi
if [ ! -f /etc/php/8.3/fpm/pool.d/www.conf.bak ]; then
  sudo cp /etc/php/8.3/fpm/pool.d/www.conf /etc/php/8.3/fpm/pool.d/www.conf.bak
fi

# Configure php.ini for CLI
#sudo sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php/8.3/cli/php.ini
#sudo sed -i "s/display_errors = .*/display_errors = On/" /etc/php/8.3/cli/php.ini
#sudo sed -i "s/memory_limit = .*/memory_limit = 512M/" /etc/php/8.3/cli/php.ini
#sudo sed -i "s/;date.timezone.*/date.timezone = UTC/" /etc/php/8.3/cli/php.ini

# Configure Xdebug
#sudo bash -c 'echo "xdebug.mode = debug" >> /etc/php/8.3/mods-available/xdebug.ini'
#sudo bash -c 'sudo echo "xdebug.discover_client_host = true" >> /etc/php/8.3/mods-available/xdebug.ini'
#sudo bash -c 'sudo echo "xdebug.client_port = 9003" >> /etc/php/8.3/mods-available/xdebug.ini'
#sudo bash -c 'sudo echo "xdebug.max_nesting_level = 512" >> /etc/php/8.3/mods-available/xdebug.ini'
#sudo bash -c 'sudo echo "opcache.revalidate_freq = 0" >> /etc/php/8.3/mods-available/opcache.ini'

# Configure php.ini for FPM
#sudo sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php/8.3/fpm/php.ini
#sudo sed -i "s/display_errors = .*/display_errors = On/" /etc/php/8.3/fpm/php.ini
#sudo sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/php/8.3/fpm/php.ini
#sudo sed -i "s/memory_limit = .*/memory_limit = 512M/" /etc/php/8.3/fpm/php.ini
#sudo sed -i "s/upload_max_filesize = .*/upload_max_filesize = 100M/" /etc/php/8.3/fpm/php.ini
#sudo sed -i "s/post_max_size = .*/post_max_size = 100M/" /etc/php/8.3/fpm/php.ini
#sudo sed -i "s/;date.timezone.*/date.timezone = UTC/" /etc/php/8.3/fpm/php.ini

sudo printf "[openssl]\n" | sudo tee -a /etc/php/8.3/fpm/php.ini
sudo printf "openssl.cainfo = /etc/ssl/certs/ca-certificates.crt\n" | sudo tee -a /etc/php/8.3/fpm/php.ini
sudo printf "[curl]\n" | sudo tee -a /etc/php/8.3/fpm/php.ini
sudo printf "curl.cainfo = /etc/ssl/certs/ca-certificates.crt\n" | sudo tee -a /etc/php/8.3/fpm/php.ini
