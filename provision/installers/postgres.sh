#!/bin/bash

# Install Postgres 13
sudo apt-get install -y postgresql-13 postgresql-server-dev-12 postgresql-13-postgis-3 postgresql-13-postgis-3-scripts

# Configure Postgres Users
sudo -u postgres psql -c "CREATE ROLE homestead LOGIN PASSWORD '$db_root_password' SUPERUSER INHERIT NOCREATEDB NOCREATEROLE NOREPLICATION;"

# Configure Postgres Remote Access
sudo sed -i "s/#listen_addresses = 'localhost'/listen_addresses = '*'/g" /etc/postgresql/13/main/postgresql.conf
sudo echo "host    all             all             10.0.2.2/32               md5" | tee -a /etc/postgresql/13/main/pg_hba.conf

sudo -u postgres /usr/bin/createdb --echo --owner=homestead homestead
sudo service postgresql restart
# Disable to lower initial overhead
sudo systemctl disable postgresql