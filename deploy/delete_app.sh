#!/bin/bash

# Expecting one argument that is the app name to delete
my_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
if [ $# -eq 0 ]; then
  echo "No app specified!"
  existing_apps=$(ls $my_path/../apps/ | sed -e 's|\.[^.]*$||')
  echo "Try one of these applications:"
  echo "$existing_apps"
  exit 1
fi

# Application to create is argument #1
app_name="$1"

# Save current directory and cd into script path
initial_working_directory=$(pwd)
my_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
cd "$my_path"

# Load common
source $my_path/../common/load_common.sh

error "You are about to delete the following:"
status "Application Cron: $app_name"
status "Directory and All Files: /home/$app_name/*"
status "User: $app_name"
status "MySQL User: $app_name"
status "MySQL Database: $app_name"
status "Nginx Configuration: /etc/nginx/sites-available/$app_name.conf"
status "PHP FPM Pool: /etc/php/$php_version/fpm/pool.d/$app_name.conf"
status "Supervisor Conf: /etc/supervisor/conf.d/$username.conf"
read -p "Are you sure you continue? " -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
then
  title "Deleting..."

  title "Deleting Application Cron"
  sudo -u $app_name crontab -r
  status "deleted"

  title "Removing www-data from $app_name group"
  sudo deluser www-data $app_name

  title "Deleting User and All Files user=$app_name"
  sudo deluser $app_name --remove-all-files

  exit
  status "User: $app_name"
  status "MySQL User: $app_name"
  status "MySQL Database: $app_name"
  status "Nginx Configuration: /etc/nginx/sites-available/$app_name.conf"
  status "PHP FPM Pool: /etc/php/$php_version/fpm/pool.d/$app_name.conf"
  status "Supervisor Conf: /etc/supervisor/conf.d/$username.conf"

  # Reverse this: sudo usermod -a -G $username www-data

  # Delete user directory

  # Delete user

  # Drop database and db user
  title "Updating MySQL"
  #status "MySQL Database: $username"
  #status "MySQL User: $username"
  #mysql -u root -p$db_root_password <<SQL
  #CREATE DATABASE IF NOT EXISTS $username CHARACTER SET utf8 COLLATE utf8_unicode_ci;
  #CREATE USER IF NOT EXISTS '$username'@'localhost' IDENTIFIED BY '$db_password';
  #GRANT ALL PRIVILEGES ON $username.* TO '$username'@'localhost';
  #FLUSH PRIVILEGES;
  #SQL

  # Delete nginx conf

  # Delete PHP-FPM Pool Conf

  # Delete supervisor conf
fi

# Return back to the original directory
cd $initial_working_directory || exit
