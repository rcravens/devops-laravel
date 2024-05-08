#!/bin/bash

# Disable Apparmor
# See https://github.com/laravel/homestead/issues/629#issue-247524528
sudo service apparmor stop
sudo update-rc.d -f apparmor remove

# Remove MySQL
sudo apt-get remove -y --purge mysql-server mysql-client mysql-common
sudo apt-get autoremove -y
sudo apt-get autoclean

sudo rm -rf /var/lib/mysql/*
sudo rm -rf /var/log/mysql
sudo rm -rf /etc/mysql

# Add Maria PPA
sudo curl -LsS https://downloads.mariadb.com/MariaDB/mariadb_repo_setup | sudo bash

sudo echo "mariadb-server mysql-server/data-dir select ''" | sudo debconf-set-selections
sudo echo "mariadb-server mysql-server/root_password password $installs_database_root_password" | sudo debconf-set-selections
sudo echo "mariadb-server mysql-server/root_password_again password $installs_database_root_password" | sudo debconf-set-selections

sudo mkdir  /etc/mysql
sudo touch /etc/mysql/debian.cnf

# Install MariaDB
sudo apt-get install -y mariadb-server mariadb-client

# Configure Maria Remote Access and ignore db dirs
sudo sed -i "s/bind-address            = 127.0.0.1/bind-address            = 0.0.0.0/" /etc/mysql/mariadb.conf.d/50-server.cnf
sudo bash -c 'cat > /etc/mysql/mariadb.conf.d/50-server.cnf << EOF
[mysqld]
bind-address = 0.0.0.0
ignore-db-dir = lost+found
#general_log
#general_log_file=/var/log/mysql/mariadb.log
EOF'

export MYSQL_PWD=$installs_database_root_password

sudo mysql --user="root" -e "GRANT ALL ON *.* TO root@'0.0.0.0' IDENTIFIED BY '$installs_database_root_password' WITH GRANT OPTION;"
sudo service mysql restart

sudo mysql_upgrade --user="root" --verbose --force
sudo service mysql restart

unset MYSQL_PWD