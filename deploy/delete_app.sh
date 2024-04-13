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

  title "Nginx Configuration: /etc/nginx/sites-available/$app_name.conf"
  restart_nginx=0
  if [ -f /etc/nginx/sites-enabled/$username.conf ]; then
    sudo rm /etc/nginx/sites-enabled/$username.conf
    status "Deleted: /etc/nginx/sites-enabled/$username.conf"
    restart_nginx=1
  else
    status "Does not exists: /etc/nginx/sites-enabled/$username.conf"
  fi
  if [ -f /etc/nginx/sites-available/$app_name.conf ]; then
    sudo rm /etc/nginx/sites-available/$app_name.conf
    status "Deleted: /etc/nginx/sites-available/$app_name.conf"
    restart_nginx=1
  else
    status "Does not exists: /etc/nginx/sites-available/$app_name.conf"
  fi
  if [ $restart_nginx -eq 1 ]; then
    sudo service nginx reload
    status "Nginx reloaded"
  fi


  title "PHP FPM Pool: /etc/php/$php_version/fpm/pool.d/$app_name.conf"
  if [ -f /etc/php/$php_version/fpm/pool.d/$app_name.conf ]; then
    sudo rm /etc/php/$php_version/fpm/pool.d/$app_name.conf
    status "Deleted: /etc/php/$php_version/fpm/pool.d/$app"
    sudo service php$php_version-fpm restart
    status "PHP FPM reloaded"
  else
    status "Does not exists: /etc/php/$php_version/fpm/pool.d/$app_name.conf"
  fi


  title "Supervisor Conf: /etc/supervisor/conf.d/$username.conf"
  if [ -f /etc/supervisor/conf.d/$username.conf ]; then
    sudo rm /etc/supervisor/conf.d/$username.conf
    status "Deleted: /etc/supervisor/conf.d/$username.conf"
    sudo supervisorctl reread
    sudo supervisorctl update
    status "Supervisor reloaded"
  else
    status "Does not exists: /etc/supervisor/conf.d/$username.conf"
  fi


  title "Deleting Application Cron"
  cron_expression="* * * * * cd $deploy_directory/current/ && php artisan schedule:run >> $deploy_directory/current/storage/logs/cron.log 2>&1"
  if [ $(sudo -u $username crontab -l | wc -c) -eq 0 ]; then
    status "Crontab does not exist"
  else
    sudo -u $app_name crontab -r
    status "Crontab deleted"
  fi


  title "Removing www-data from $app_name group"
  sudo deluser www-data $app_name
exit
  title "Deleting User and All Files user=$app_name"
  sudo deluser $app_name --remove-all-files

  exit
  status "User: $app_name"
  status "MySQL User: $app_name"
  status "MySQL Database: $app_name"

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
