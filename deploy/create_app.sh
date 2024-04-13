#!/bin/bash

# Save current directory and cd into script path
initial_working_directory=$(pwd)
parent_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
cd "$parent_path"

# Load the helpers
source $parent_path/../helpers.sh

# Load the config file
source $parent_path/../config.sh

# Guard against overwriting and existing user
title "Create Deployment User: $username"
if id "$username" >/dev/null 2>&1; then
  error "This user already exists. Username: $username"
else
  # Create the deployment user
  sudo adduser --gecos "" --disabled-password $username
  sudo chpasswd <<<"$username:$password"

  # Create the Github Deployment Keys
  title "Creating Github Deployment Keys"
  sudo su - $username <<EOF
# Create the Github keys
ssh-keygen -f ~/.ssh/github_rsa -t rsa -N ""
cat <<EOT >> ~/.ssh/config
Host github.com
        IdentityFile ~/.ssh/github_rsa
        IdentitiesOnly yes
EOT
chmod 700 ~/.ssh
chmod 600 ~/.ssh/*

error "----------------------COPY PUB KEY TO GITHUB DEPLOYMENT KEYS---------------------"
cat < ~/.ssh/github_rsa.pub
error "---------------------------------------------------------------------------------"

# End session
exit
EOF

  title "Adding www-data to user group: $username"
  sudo usermod -a -G $username www-data
fi


# Add the SSH public key to this users authorized_keys
title "Adding SSH public key to authorized_keys for user: $username"
if [ ! -f /home/$username/.ssh/authorized_keys ]; then
    sudo -u $username touch /home/$username/.ssh/authorized_keys
    sudo -u $username chmod 600 /home/$username/.ssh/authorized_keys
fi
if grep -q "$public_ssh_key" /home/$username/.ssh/authorized_keys; then
  status "Key Already Installed: /home/$username/.ssh/authorized_keys"
else
  echo "$public_ssh_key" >> /home/$username/.ssh/authorized_keys
  status "Key Installed: /home/$username/.ssh/authorized_keys"
fi


# Create mysql database and user
title "Updating MySQL"
status "MySQL Database: $username"
status "MySQL User: $username"
mysql -u root -p$db_root_password <<SQL
CREATE DATABASE IF NOT EXISTS $username CHARACTER SET utf8 COLLATE utf8_unicode_ci;
CREATE USER IF NOT EXISTS '$username'@'localhost' IDENTIFIED BY '$db_password';
GRANT ALL PRIVILEGES ON $username.* TO '$username'@'localhost';
FLUSH PRIVILEGES;
SQL

title "Creating Laravel .env File"
if [ ! -d $deploy_directory/symlinks ]; then
  sudo -u $username mkdir -p $deploy_directory/symlinks
fi
if [ ! -f $deploy_directory/symlinks/.env ]; then
  sudo -u $username cp $parent_path/_laravel.env $deploy_directory/symlinks/.env
  sudo -u $username sed -i "s|DB_DATABASE=.*|DB_DATABASE=$username|" $deploy_directory/symlinks/.env
  sudo -u $username sed -i "s|DB_USERNAME=.*|DB_USERNAME=$username|" $deploy_directory/symlinks/.env
  sudo -u $username sed -i "s|DB_PASSWORD=.*|DB_PASSWORD=$db_password|" $deploy_directory/symlinks/.env

  status "Created .env file: $deploy_directory/symlinks/.env"
else
  status "Found .env file: $deploy_directory/symlinks/.env"
fi

title "Creating Initial Deployment"
sudo -u $username $parent_path/deploy.sh

title "Generating Application Key"
sudo -u $username php $deploy_directory/current/artisan key:generate

title "Creating Initial Symlinked Data"
sudo -u $username $parent_path/initialize_symlink_data.sh

title "Creating Crontab for User: $username"
sudo -u $username crontab -l 2>/dev/null; echo "* * * * * cd $deploy_directory/current/ && php artisan schedule:run >> $deploy_directory/current/storage/logs/cron.log 2>&1" | sudo crontab -u $username -

# Create nginx conf
title "Creating Nginx Conf"
if [ ! -f /etc/nginx/sites-available/$username.conf ]; then
    sudo cp $parent_path/_nginx.conf /etc/nginx/sites-available/$username.conf
    sudo sed -i "s|root;|root $deploy_directory/current/public;|" /etc/nginx/sites-available/$username.conf
    sudo sed -i "s|phpXXXX|php$php_version|" /etc/nginx/sites-available/$username.conf
    sudo ln -s /etc/nginx/sites-available/$username.conf /etc/nginx/sites-enabled/$username.conf
    sudo service nginx reload
    status "Created: /etc/nginx/sites-available/$username.conf"
else
  status "Already exists: /etc/nginx/sites-available/$username.conf"
fi

title "Creating PHP-FPM Pool Conf"
if [ ! -f /etc/php/$php_version/fpm/pool.d/$username.conf ]; then
    sudo cp /etc/php/$php_version/fpm/pool.d/www.conf /etc/php/$php_version/fpm/pool.d/$username.conf
    sudo sed -i "s|\[www\]|[$username]|" /etc/php/$php_version/fpm/pool.d/$username.conf
    sudo sed -i "s/user =.*/user = $username/" /etc/php/$php_version/fpm/pool.d/$username.conf
    sudo sed -i "s/group =.*/group = $username/" /etc/php/$php_version/fpm/pool.d/$username.conf
    sudo sed -i "s/listen\.owner.*/listen.owner = $username/" /etc/php/$php_version/fpm/pool.d/$username.conf
    sudo sed -i "s/listen\.group.*/listen.group = $username/" /etc/php/$php_version/fpm/pool.d/$username.conf
    sudo sed -i "s|listen =.*|listen = /run/php/php$php_version-$username-fpm.sock|" /etc/php/$php_version/fpm/pool.d/$username.conf
    sudo service php$php_version-fpm restart
    status "Created: /etc/php/$php_version/fpm/pool.d/$username"
else
  status "Already existsL /etc/php/$php_version/fpm/pool.d/$username.conf"
fi

# Create supervisor conf
title "Creating Supervisor Conf"
if [ ! -f /etc/supervisor/conf.d/$username.conf ]; then
    sudo cp $parent_path/_supervisor.conf /etc/supervisor/conf.d/$username.conf
    sudo sed -i "s|program:|program:horizon_$username|" /etc/supervisor/conf.d/$username.conf
    sudo sed -i "s|command=|command=php $deploy_directory/current/artisan horizon|" /etc/supervisor/conf.d/$username.conf
    sudo sed -i "s|user=|user=$username|" /etc/supervisor/conf.d/$username.conf
    sudo sed -i "s|stdout_logfile=|stdout_logfile=$deploy_directory/current/storage/logs/horizon.log|" /etc/supervisor/conf.d/$username.conf
    sudo supervisorctl reread
    sudo supervisorctl update
    status "Created: /etc/supervisor/conf.d/$username.conf"
else
  status "Already exists: /etc/supervisor/conf.d/$username.conf"
fi

# Return back to the original directory
cd $initial_working_directory || exit
