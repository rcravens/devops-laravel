#!/bin/bash

# Install Some PPAs
sudo apt-add-repository ppa:ondrej/php -y
sudo apt-add-repository ppa:chris-lea/redis-server -y

## Update Package Lists
sudo apt-get update -y

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
sudo bash -c 'echo "xdebug.remote_enable = 1" >> /etc/php/5.6/mods-available/xdebug.ini'
sudo bash -c 'echo "xdebug.remote_connect_back = 1" >> /etc/php/5.6/mods-available/xdebug.ini'
sudo bash -c 'echo "xdebug.remote_port = 9000" >> /etc/php/5.6/mods-available/xdebug.ini'
sudo bash -c 'echo "xdebug.max_nesting_level = 512" >> /etc/php/5.6/mods-available/xdebug.ini'
sudo bash -c 'echo "opcache.revalidate_freq = 0" >> /etc/php/5.6/mods-available/opcache.ini'

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
sudo sed -i "s/user =.*/user = $username/" /etc/php/5.6/fpm/pool.d/www.conf
sudo sed -i "s/group =.*/group = $username/" /etc/php/5.6/fpm/pool.d/www.conf
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
sudo bash -c 'echo "xdebug.remote_enable = 1" >> /etc/php/7.0/mods-available/xdebug.ini'
sudo bash -c 'echo "xdebug.remote_connect_back = 1" >> /etc/php/7.0/mods-available/xdebug.ini'
sudo bash -c 'echo "xdebug.remote_port = 9000" >> /etc/php/7.0/mods-available/xdebug.ini'
sudo bash -c 'echo "xdebug.max_nesting_level = 512" >> /etc/php/7.0/mods-available/xdebug.ini'
sudo bash -c 'echo "opcache.revalidate_freq = 0" >> /etc/php/7.0/mods-available/opcache.ini'

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
sudo sed -i "s/user =.*/user = $username/" /etc/php/7.0/fpm/pool.d/www.conf
sudo sed -i "s/group =.*/group = $username/" /etc/php/7.0/fpm/pool.d/www.conf
sudo sed -i "s/listen\.owner.*/listen.owner = $username/" /etc/php/7.0/fpm/pool.d/www.conf
sudo sed -i "s/listen\.group.*/listen.group = $username/" /etc/php/7.0/fpm/pool.d/www.conf
sudo sed -i "s/;listen\.mode.*/listen.mode = 0666/" /etc/php/7.0/fpm/pool.d/www.conf

# PHP 7.1
sudo apt-get install -y --allow-change-held-packages \
php7.1-bcmath php7.1-bz2 php7.1-cgi php7.1-cli php7.1-common php7.1-curl php7.1-dba php7.1-dev php7.1-enchant \
php7.1-fpm php7.1-gd php7.1-gmp php7.1-imap php7.1-interbase php7.1-intl php7.1-json php7.1-ldap php7.1-mbstring \
php7.1-mcrypt php7.1-mysql php7.1-odbc php7.1-opcache php7.1-pgsql php7.1-phpdbg php7.1-pspell php7.1-readline \
php7.1-recode php7.1-snmp php7.1-soap php7.1-sqlite3 php7.1-sybase php7.1-tidy php7.1-xdebug php7.1-xml php7.1-xmlrpc \
php7.1-xsl php7.1-zip php7.1-imagick php7.1-memcached php7.1-redis

# Configure php.ini for CLI
sudo sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php/7.1/cli/php.ini
sudo sed -i "s/display_errors = .*/display_errors = On/" /etc/php/7.1/cli/php.ini
sudo sed -i "s/memory_limit = .*/memory_limit = 512M/" /etc/php/7.1/cli/php.ini
sudo sed -i "s/;date.timezone.*/date.timezone = UTC/" /etc/php/7.1/cli/php.ini

# Configure Xdebug
sudo bash -c 'echo "xdebug.remote_enable = 1" >> /etc/php/7.1/mods-available/xdebug.ini'
sudo bash -c 'echo "xdebug.remote_connect_back = 1" >> /etc/php/7.1/mods-available/xdebug.ini'
sudo bash -c 'echo "xdebug.remote_port = 9000" >> /etc/php/7.1/mods-available/xdebug.ini'
sudo bash -c 'echo "xdebug.max_nesting_level = 512" >> /etc/php/7.1/mods-available/xdebug.ini'
sudo bash -c 'echo "opcache.revalidate_freq = 0" >> /etc/php/7.1/mods-available/opcache.ini'

# Configure php.ini for FPM
sudo sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php/7.1/fpm/php.ini
sudo sed -i "s/display_errors = .*/display_errors = On/" /etc/php/7.1/fpm/php.ini
sudo sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/php/7.1/fpm/php.ini
sudo sed -i "s/memory_limit = .*/memory_limit = 512M/" /etc/php/7.1/fpm/php.ini
sudo sed -i "s/upload_max_filesize = .*/upload_max_filesize = 100M/" /etc/php/7.1/fpm/php.ini
sudo sed -i "s/post_max_size = .*/post_max_size = 100M/" /etc/php/7.1/fpm/php.ini
sudo sed -i "s/;date.timezone.*/date.timezone = UTC/" /etc/php/7.1/fpm/php.ini

sudo printf "[openssl]\n" | sudo tee -a /etc/php/7.1/fpm/php.ini
sudo printf "openssl.cainfo = /etc/ssl/certs/ca-certificates.crt\n" | sudo tee -a /etc/php/7.1/fpm/php.ini
sudo printf "[curl]\n" | sudo tee -a /etc/php/7.1/fpm/php.ini
sudo printf "curl.cainfo = /etc/ssl/certs/ca-certificates.crt\n" | sudo tee -a /etc/php/7.1/fpm/php.ini

# Configure FPM
sudo sed -i "s/user =.*/user = $username/" /etc/php/7.1/fpm/pool.d/www.conf
sudo sed -i "s/group =.*/group = $username/" /etc/php/7.1/fpm/pool.d/www.conf
sudo sed -i "s/listen\.owner.*/listen.owner = $username/" /etc/php/7.1/fpm/pool.d/www.conf
sudo sed -i "s/listen\.group.*/listen.group = $username/" /etc/php/7.1/fpm/pool.d/www.conf
sudo sed -i "s/;listen\.mode.*/listen.mode = 0666/" /etc/php/7.1/fpm/pool.d/www.conf

# PHP 7.2
sudo apt-get install -y --allow-change-held-packages \
php7.2-bcmath php7.2-bz2 php7.2-dba php7.2-enchant php7.2-fpm php7.2-imap php7.2-interbase php7.2-intl \
php7.2-mbstring php7.2-phpdbg php7.2-soap php7.2-sybase php7.2-xsl php7.2-zip php7.2-cgi php7.2-cli php7.2-common \
php7.2-curl php7.2-dev php7.2-gd php7.2-gmp php7.2-json php7.2-ldap php7.2-mysql php7.2-odbc php7.2-opcache \
php7.2-pgsql php7.2-pspell php7.2-readline php7.2-recode php7.2-snmp php7.2-sqlite3 php7.2-tidy php7.2-xdebug \
php7.2-xml php7.2-xmlrpc php7.2-imagick php7.2-memcached php7.2-redis

# Configure php.ini for CLI
sudo sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php/7.2/cli/php.ini
sudo sed -i "s/display_errors = .*/display_errors = On/" /etc/php/7.2/cli/php.ini
sudo sed -i "s/memory_limit = .*/memory_limit = 512M/" /etc/php/7.2/cli/php.ini
sudo sed -i "s/;date.timezone.*/date.timezone = UTC/" /etc/php/7.2/cli/php.ini

# Configure Xdebug
sudo bash -c 'echo "xdebug.mode = debug" >> /etc/php/7.2/mods-available/xdebug.ini'
sudo bash -c 'echo "xdebug.discover_client_host = true" >> /etc/php/7.2/mods-available/xdebug.ini'
sudo bash -c 'echo "xdebug.client_port = 9003" >> /etc/php/7.2/mods-available/xdebug.ini'
sudo bash -c 'echo "xdebug.max_nesting_level = 512" >> /etc/php/7.2/mods-available/xdebug.ini'
sudo bash -c 'echo "opcache.revalidate_freq = 0" >> /etc/php/7.2/mods-available/opcache.ini'

# Configure php.ini for FPM
sudo sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php/7.2/fpm/php.ini
sudo sed -i "s/display_errors = .*/display_errors = On/" /etc/php/7.2/fpm/php.ini
sudo sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/php/7.2/fpm/php.ini
sudo sed -i "s/memory_limit = .*/memory_limit = 512M/" /etc/php/7.2/fpm/php.ini
sudo sed -i "s/upload_max_filesize = .*/upload_max_filesize = 100M/" /etc/php/7.2/fpm/php.ini
sudo sed -i "s/post_max_size = .*/post_max_size = 100M/" /etc/php/7.2/fpm/php.ini
sudo sed -i "s/;date.timezone.*/date.timezone = UTC/" /etc/php/7.2/fpm/php.ini

sudo printf "[openssl]\n" | sudo tee -a /etc/php/7.2/fpm/php.ini
sudo printf "openssl.cainfo = /etc/ssl/certs/ca-certificates.crt\n" | sudo tee -a /etc/php/7.2/fpm/php.ini
sudo printf "[curl]\n" | sudo tee -a /etc/php/7.2/fpm/php.ini
sudo printf "curl.cainfo = /etc/ssl/certs/ca-certificates.crt\n" | sudo tee -a /etc/php/7.2/fpm/php.ini

# Configure FPM
sudo sed -i "s/user =.*/user = $username/" /etc/php/7.2/fpm/pool.d/www.conf
sudo sed -i "s/group =.*/group = $username/" /etc/php/7.2/fpm/pool.d/www.conf

sudo sed -i "s/listen\.owner.*/listen.owner = $username/" /etc/php/7.2/fpm/pool.d/www.conf
sudo sed -i "s/listen\.group.*/listen.group = $username/" /etc/php/7.2/fpm/pool.d/www.conf
sudo sed -i "s/;listen\.mode.*/listen.mode = 0666/" /etc/php/7.2/fpm/pool.d/www.conf

# PHP 7.3
sudo apt-get install -y --allow-change-held-packages \
php7.3 php7.3-bcmath php7.3-bz2 php7.3-cgi php7.3-cli php7.3-common php7.3-curl php7.3-dba php7.3-dev php7.3-enchant \
php7.3-fpm php7.3-gd php7.3-gmp php7.3-imap php7.3-interbase php7.3-intl php7.3-json php7.3-ldap php7.3-mbstring \
php7.3-mysql php7.3-odbc php7.3-opcache php7.3-pgsql php7.3-phpdbg php7.3-pspell php7.3-readline php7.3-recode \
php7.3-snmp php7.3-soap php7.3-sqlite3 php7.3-sybase php7.3-tidy php7.3-xdebug php7.3-xml php7.3-xmlrpc php7.3-xsl \
php7.3-zip php7.3-imagick php7.3-memcached php7.3-redis

# Configure php.ini for CLI
sudo sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php/7.3/cli/php.ini
sudo sed -i "s/display_errors = .*/display_errors = On/" /etc/php/7.3/cli/php.ini
sudo sed -i "s/memory_limit = .*/memory_limit = 512M/" /etc/php/7.3/cli/php.ini
sudo sed -i "s/;date.timezone.*/date.timezone = UTC/" /etc/php/7.3/cli/php.ini

# Configure Xdebug
sudo bash -c 'echo "xdebug.mode = debug" >> /etc/php/7.3/mods-available/xdebug.ini'
sudo bash -c 'echo "xdebug.discover_client_host = true" >> /etc/php/7.3/mods-available/xdebug.ini'
sudo bash -c 'echo "xdebug.client_port = 9003" >> /etc/php/7.3/mods-available/xdebug.ini'
sudo bash -c 'echo "xdebug.max_nesting_level = 512" >> /etc/php/7.3/mods-available/xdebug.ini'
sudo bash -c 'echo "opcache.revalidate_freq = 0" >> /etc/php/7.3/mods-available/opcache.ini'

# Configure php.ini for FPM
sudo sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php/7.3/fpm/php.ini
sudo sed -i "s/display_errors = .*/display_errors = On/" /etc/php/7.3/fpm/php.ini
sudo sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/php/7.3/fpm/php.ini
sudo sed -i "s/memory_limit = .*/memory_limit = 512M/" /etc/php/7.3/fpm/php.ini
sudo sed -i "s/upload_max_filesize = .*/upload_max_filesize = 100M/" /etc/php/7.3/fpm/php.ini
sudo sed -i "s/post_max_size = .*/post_max_size = 100M/" /etc/php/7.3/fpm/php.ini
sudo sed -i "s/;date.timezone.*/date.timezone = UTC/" /etc/php/7.3/fpm/php.ini

sudo printf "[openssl]\n" | sudo tee -a /etc/php/7.3/fpm/php.ini
sudo printf "openssl.cainfo = /etc/ssl/certs/ca-certificates.crt\n" | sudo tee -a /etc/php/7.3/fpm/php.ini
sudo printf "[curl]\n" | sudo tee -a /etc/php/7.3/fpm/php.ini
sudo printf "curl.cainfo = /etc/ssl/certs/ca-certificates.crt\n" | sudo tee -a /etc/php/7.3/fpm/php.ini

# Configure FPM
sudo sed -i "s/user =.*/user = $username/" /etc/php/7.3/fpm/pool.d/www.conf
sudo sed -i "s/group =.*/group = $username/" /etc/php/7.3/fpm/pool.d/www.conf
sudo sed -i "s/listen\.owner.*/listen.owner = $username/" /etc/php/7.3/fpm/pool.d/www.conf
sudo sed -i "s/listen\.group.*/listen.group = $username/" /etc/php/7.3/fpm/pool.d/www.conf
sudo sed -i "s/;listen\.mode.*/listen.mode = 0666/" /etc/php/7.3/fpm/pool.d/www.conf

# PHP 7.4
sudo apt-get install -y --allow-change-held-packages \
php7.4 php7.4-bcmath php7.4-bz2 php7.4-cgi php7.4-cli php7.4-common php7.4-curl php7.4-dba php7.4-dev \
php7.4-enchant php7.4-fpm php7.4-gd php7.4-gmp php7.4-imap php7.4-interbase php7.4-intl php7.4-json php7.4-ldap \
php7.4-mbstring php7.4-mysql php7.4-odbc php7.4-opcache php7.4-pgsql php7.4-phpdbg php7.4-pspell php7.4-readline \
php7.4-snmp php7.4-soap php7.4-sqlite3 php7.4-sybase php7.4-tidy php7.4-xdebug php7.4-xml php7.4-xmlrpc php7.4-xsl \
php7.4-zip php7.4-imagick php7.4-memcached php7.4-redis

# Configure php.ini for CLI
sudo sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php/7.4/cli/php.ini
sudo sed -i "s/display_errors = .*/display_errors = On/" /etc/php/7.4/cli/php.ini
sudo sed -i "s/memory_limit = .*/memory_limit = 512M/" /etc/php/7.4/cli/php.ini
sudo sed -i "s/;date.timezone.*/date.timezone = UTC/" /etc/php/7.4/cli/php.ini

# Configure Xdebug
sudo bash -c 'echo "xdebug.mode = debug" >> /etc/php/7.4/mods-available/xdebug.ini'
sudo bash -c 'echo "xdebug.discover_client_host = true" >> /etc/php/7.4/mods-available/xdebug.ini'
sudo bash -c 'echo "xdebug.client_port = 9003" >> /etc/php/7.4/mods-available/xdebug.ini'
sudo bash -c 'echo "xdebug.max_nesting_level = 512" >> /etc/php/7.4/mods-available/xdebug.ini'
sudo bash -c 'echo "opcache.revalidate_freq = 0" >> /etc/php/7.4/mods-available/opcache.ini'

# Configure php.ini for FPM
sudo sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php/7.4/fpm/php.ini
sudo sed -i "s/display_errors = .*/display_errors = On/" /etc/php/7.4/fpm/php.ini
sudo sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/php/7.4/fpm/php.ini
sudo sed -i "s/memory_limit = .*/memory_limit = 512M/" /etc/php/7.4/fpm/php.ini
sudo sed -i "s/upload_max_filesize = .*/upload_max_filesize = 100M/" /etc/php/7.4/fpm/php.ini
sudo sed -i "s/post_max_size = .*/post_max_size = 100M/" /etc/php/7.4/fpm/php.ini
sudo sed -i "s/;date.timezone.*/date.timezone = UTC/" /etc/php/7.4/fpm/php.ini

sudo printf "[openssl]\n" | sudo tee -a /etc/php/7.4/fpm/php.ini
sudo printf "openssl.cainfo = /etc/ssl/certs/ca-certificates.crt\n" | sudo tee -a /etc/php/7.4/fpm/php.ini
sudo printf "[curl]\n" | sudo tee -a /etc/php/7.4/fpm/php.ini
sudo printf "curl.cainfo = /etc/ssl/certs/ca-certificates.crt\n" | sudo tee -a /etc/php/7.4/fpm/php.ini

# Configure FPM
sudo sed -i "s/user =.*/user = $username/" /etc/php/7.4/fpm/pool.d/www.conf
sudo sed -i "s/group =.*/group = $username/" /etc/php/7.4/fpm/pool.d/www.conf
sudo sed -i "s/listen\.owner.*/listen.owner = $username/" /etc/php/7.4/fpm/pool.d/www.conf
sudo sed -i "s/listen\.group.*/listen.group = $username/" /etc/php/7.4/fpm/pool.d/www.conf
sudo sed -i "s/;listen\.mode.*/listen.mode = 0666/" /etc/php/7.4/fpm/pool.d/www.conf

# PHP 8.0
sudo apt-get install -y --allow-change-held-packages \
php8.0 php8.0-bcmath php8.0-bz2 php8.0-cgi php8.0-cli php8.0-common php8.0-curl php8.0-dba php8.0-dev \
php8.0-enchant php8.0-fpm php8.0-gd php8.0-gmp php8.0-imap php8.0-interbase php8.0-intl php8.0-ldap \
php8.0-mbstring php8.0-mysql php8.0-odbc php8.0-opcache php8.0-pgsql php8.0-phpdbg php8.0-pspell php8.0-readline \
php8.0-snmp php8.0-soap php8.0-sqlite3 php8.0-sybase php8.0-tidy php8.0-xdebug php8.0-xml php8.0-xmlrpc php8.0-xsl \
php8.0-zip php8.0-memcached php8.0-redis

# Configure php.ini for CLI
sudo sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php/8.0/cli/php.ini
sudo sed -i "s/display_errors = .*/display_errors = On/" /etc/php/8.0/cli/php.ini
sudo sed -i "s/memory_limit = .*/memory_limit = 512M/" /etc/php/8.0/cli/php.ini
sudo sed -i "s/;date.timezone.*/date.timezone = UTC/" /etc/php/8.0/cli/php.ini

# Configure Xdebug
sudo bash -c 'echo "xdebug.mode = debug" >> /etc/php/8.0/mods-available/xdebug.ini'
sudo bash -c 'echo "xdebug.discover_client_host = true" >> /etc/php/8.0/mods-available/xdebug.ini'
sudo bash -c 'echo "xdebug.client_port = 9003" >> /etc/php/8.0/mods-available/xdebug.ini'
sudo bash -c 'echo "xdebug.max_nesting_level = 512" >> /etc/php/8.0/mods-available/xdebug.ini'
sudo bash -c 'echo "opcache.revalidate_freq = 0" >> /etc/php/8.0/mods-available/opcache.ini'

# Configure php.ini for FPM
sudo sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php/8.0/fpm/php.ini
sudo sed -i "s/display_errors = .*/display_errors = On/" /etc/php/8.0/fpm/php.ini
sudo sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/php/8.0/fpm/php.ini
sudo sed -i "s/memory_limit = .*/memory_limit = 512M/" /etc/php/8.0/fpm/php.ini
sudo sed -i "s/upload_max_filesize = .*/upload_max_filesize = 100M/" /etc/php/8.0/fpm/php.ini
sudo sed -i "s/post_max_size = .*/post_max_size = 100M/" /etc/php/8.0/fpm/php.ini
sudo sed -i "s/;date.timezone.*/date.timezone = UTC/" /etc/php/8.0/fpm/php.ini

sudo printf "[openssl]\n" | sudo tee -a /etc/php/8.0/fpm/php.ini
sudo printf "openssl.cainfo = /etc/ssl/certs/ca-certificates.crt\n" | sudo tee -a /etc/php/8.0/fpm/php.ini
sudo printf "[curl]\n" | sudo tee -a /etc/php/8.0/fpm/php.ini
sudo printf "curl.cainfo = /etc/ssl/certs/ca-certificates.crt\n" | sudo tee -a /etc/php/8.0/fpm/php.ini

# Configure FPM
sudo sed -i "s/user =.*/user = $username/" /etc/php/8.0/fpm/pool.d/www.conf
sudo sed -i "s/group =.*/group = $username/" /etc/php/8.0/fpm/pool.d/www.conf
sudo sed -i "s/listen\.owner.*/listen.owner = $username/" /etc/php/8.0/fpm/pool.d/www.conf
sudo sed -i "s/listen\.group.*/listen.group = $username/" /etc/php/8.0/fpm/pool.d/www.conf
sudo sed -i "s/;listen\.mode.*/listen.mode = 0666/" /etc/php/8.0/fpm/pool.d/www.conf

# PHP 8.1
sudo apt-get install -y --allow-change-held-packages \
php8.1 php8.1-bcmath php8.1-bz2 php8.1-cgi php8.1-cli php8.1-common php8.1-curl php8.1-dba php8.1-dev \
php8.1-enchant php8.1-fpm php8.1-gd php8.1-gmp php8.1-imap php8.1-interbase php8.1-intl php8.1-ldap \
php8.1-mbstring php8.1-mysql php8.1-odbc php8.1-opcache php8.1-pgsql php8.1-phpdbg php8.1-pspell php8.1-readline \
php8.1-snmp php8.1-soap php8.1-sqlite3 php8.1-sybase php8.1-tidy php8.1-xdebug php8.1-xml php8.1-xmlrpc php8.1-xsl \
php8.1-zip php8.1-memcached php8.1-redis

# Configure php.ini for CLI
sudo sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php/8.1/cli/php.ini
sudo sed -i "s/display_errors = .*/display_errors = On/" /etc/php/8.1/cli/php.ini
sudo sed -i "s/memory_limit = .*/memory_limit = 512M/" /etc/php/8.1/cli/php.ini
sudo sed -i "s/;date.timezone.*/date.timezone = UTC/" /etc/php/8.1/cli/php.ini

# Configure Xdebug
sudo bash -c 'echo "xdebug.mode = debug" >> /etc/php/8.1/mods-available/xdebug.ini'
sudo bash -c 'sudo echo "xdebug.discover_client_host = true" >> /etc/php/8.1/mods-available/xdebug.ini'
sudo bash -c 'sudo echo "xdebug.client_port = 9003" >> /etc/php/8.1/mods-available/xdebug.ini'
sudo bash -c 'sudo echo "xdebug.max_nesting_level = 512" >> /etc/php/8.1/mods-available/xdebug.ini'
sudo bash -c 'sudo echo "opcache.revalidate_freq = 0" >> /etc/php/8.1/mods-available/opcache.ini'

# Configure php.ini for FPM
sudo sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php/8.1/fpm/php.ini
sudo sed -i "s/display_errors = .*/display_errors = On/" /etc/php/8.1/fpm/php.ini
sudo sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/php/8.1/fpm/php.ini
sudo sed -i "s/memory_limit = .*/memory_limit = 512M/" /etc/php/8.1/fpm/php.ini
sudo sed -i "s/upload_max_filesize = .*/upload_max_filesize = 100M/" /etc/php/8.1/fpm/php.ini
sudo sed -i "s/post_max_size = .*/post_max_size = 100M/" /etc/php/8.1/fpm/php.ini
sudo sed -i "s/;date.timezone.*/date.timezone = UTC/" /etc/php/8.1/fpm/php.ini

sudo printf "[openssl]\n" | sudo tee -a /etc/php/8.1/fpm/php.ini
sudo printf "openssl.cainfo = /etc/ssl/certs/ca-certificates.crt\n" | sudo tee -a /etc/php/8.1/fpm/php.ini
sudo printf "[curl]\n" | sudo tee -a /etc/php/8.1/fpm/php.ini
sudo printf "curl.cainfo = /etc/ssl/certs/ca-certificates.crt\n" | sudo tee -a /etc/php/8.1/fpm/php.ini

# Configure FPM
sudo sed -i "s/user =.*/user = $username/" /etc/php/8.1/fpm/pool.d/www.conf
sudo sed -i "s/group =.*/group = $username/" /etc/php/8.1/fpm/pool.d/www.conf
sudo sed -i "s/listen\.owner.*/listen.owner = $username/" /etc/php/8.1/fpm/pool.d/www.conf
sudo sed -i "s/listen\.group.*/listen.group = $username/" /etc/php/8.1/fpm/pool.d/www.conf
sudo sed -i "s/;listen\.mode.*/listen.mode = 0666/" /etc/php/8.1/fpm/pool.d/www.conf