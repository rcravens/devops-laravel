#!/bin/bash

# Install MySQL
sudo apt-get install -y mysql-server

# Set the root password
sudo mysql -u root -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '$installs_database_root_password';"

# Automate the mysql_secure_installation process
SECURE_MYSQL=$(expect -c "

set timeout 10
spawn mysql_secure_installation

expect \"Enter password for root user:\"
send \"$installs_database_root_password\r\"

expect \"Change the password for root\"
send \"n\r\"

expect \"Remove anonymous users\"
send \"y\r\"

expect \"Disallow root login remotely\"
send \"y\r\"

expect \"Remove test database and access to it?\"
send \"y\r\"

expect \"Reload privilege tables now?\"
send \"y\r\"

expect eof
")
echo "$SECURE_MYSQL"
