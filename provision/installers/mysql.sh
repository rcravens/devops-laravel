#!/bin/bash

# Run the following as root
#[[ $(id -u) -eq 0 ]] || exec sudo /bin/bash -c "$(printf '%q ' "$BASH_SOURCE" "$@")"

# Install MySQL
sudo echo "mysql-server mysql-server/root_password password $db_root_password" | sudo debconf-set-selections
sudo echo "mysql-server mysql-server/root_password_again password $db_root_password" | sudo debconf-set-selections
sudo apt-get install -y mysql-server

# Configure MySQL 8 Remote Access and Native Pluggable Authentication
sudo bash -c 'cat > /etc/mysql/conf.d/mysqld.cnf << EOF
[mysqld]
bind-address = 0.0.0.0
default_authentication_plugin = mysql_native_password
EOF'

# Configure MySQL Password Lifetime
sudo bash -c 'echo "default_password_lifetime = 0" >> /etc/mysql/mysql.conf.d/mysqld.cnf'

# Configure MySQL Remote Access
sudo sed -i '/^bind-address/s/bind-address.*=.*/bind-address = 0.0.0.0/' /etc/mysql/mysql.conf.d/mysqld.cnf

sudo service mysql restart

export MYSQL_PWD=$db_root_password

echo "db_root_password=$db_root_password"
echo "MYSQL_PWD=$MYSQL_PWD"

sudo mysql --user="root" -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '$db_root_password';"
sudo mysql --user="root" -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' WITH GRANT OPTION;"
sudo mysql --user="root" -e "CREATE USER 'homestead'@'0.0.0.0' IDENTIFIED BY 'secret';"
sudo mysql --user="root" -e "CREATE USER 'homestead'@'%' IDENTIFIED BY 'secret';"
sudo mysql --user="root" -e "GRANT ALL PRIVILEGES ON *.* TO 'homestead'@'0.0.0.0' WITH GRANT OPTION;"
sudo mysql --user="root" -e "GRANT ALL PRIVILEGES ON *.* TO 'homestead'@'%' WITH GRANT OPTION;"
sudo mysql --user="root" -e "FLUSH PRIVILEGES;"
# sudo mysql --user="root" -e "CREATE DATABASE homestead character set UTF8mb4 collate utf8mb4_bin;"

sudo tee /home/vagrant/.my.cnf <<EOL
[mysqld]
character-set-server=utf8mb4
collation-server=utf8mb4_bin
EOL

sudo service mysql restart

unset MYSQL_PWD