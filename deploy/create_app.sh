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

  # Start a new session with this new user
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

title "Creating Initial Deployment"
echo "parent_path (before deploy.sh): $parent_path"
sudo -u $username $parent_path/deploy.sh

title "Creating Initial Symlinked Data"
echo "username: $username"
echo "parent_path (after deploy.sh): $parent_path"
sudo -u $username $parent_path/initialize_symlinks.sh

#sudo su - $username <<INIT
## Cron configuration
##(crontab -l 2>/dev/null; echo "* * * * * cd $deploy_directory/current/ && php artisan schedule:run >> $deploy_directory/current/storage/logs/cron.log 2>&1") | crontab -
#INIT

# Activate the newly created symlink sources
title "Recreating Symlinks"
sudo -u $username $parent_path/deploy_symlinks.sh

# Create nginx conf
if [ ! -f /etc/nginx/sites-available/$username.conf ]; then
    sudo cp $parent_path/laravel.conf /etc/nginx/sites-available/$username.conf
    sudo sed -i "s|root;|root $deploy_directory/current/public;|" /etc/nginx/sites-available/$username.conf
    sudo sed -i "s|phpXXXX|php$php_version|" /etc/nginx/sites-available/$username.conf
    sudo ln -s /etc/nginx/sites-available/$username.conf /etc/nginx/sites-enabled/$username.conf
    sudo service nginx reload
fi
if [ ! -f /etc/php/$php_version/fpm/pool.d/$username.conf ]; then
    sudo cp /etc/php/$php_version/fpm/pool.d/www.conf /etc/php/$php_version/fpm/pool.d/$username.conf
    sudo sed -i "s|\[www\]|[$username]|" /etc/php/$php_version/fpm/pool.d/$username.conf
    sudo sed -i "s/user =.*/user = $username/" /etc/php/$php_version/fpm/pool.d/$username.conf
    sudo sed -i "s/group =.*/group = $username/" /etc/php/$php_version/fpm/pool.d/$username.conf
    sudo sed -i "s/listen\.owner.*/listen.owner = $username/" /etc/php/$php_version/fpm/pool.d/$username.conf
    sudo sed -i "s/listen\.group.*/listen.group = $username/" /etc/php/$php_version/fpm/pool.d/$username.conf
    sudo sed -i "s|listen =.*|listen = /run/php/php$php_version-$username-fpm.sock|" /etc/php/$php_version/fpm/pool.d/$username.conf
    sudo service php$php_version-fpm restart
fi

# Create supervisor conf
if [ ! -f /etc/supervisor/conf.d/$username.conf ]; then
    sudo cp $parent_path/horizon.conf /etc/supervisor/conf.d/$username.conf
    sudo sed -i "s|program:|program:horizon_$username|" /etc/supervisor/conf.d/$username.conf
    sudo sed -i "s|command=|command=php $deploy_directory/current/artisan horizon|" /etc/supervisor/conf.d/$username.conf
    sudo sed -i "s|user=|user=$username|" /etc/supervisor/conf.d/$username.conf
    sudo sed -i "s|stdout_logfile=|stdout_logfile=$deploy_directory/current/storage/logs/horizon.log|" /etc/supervisor/conf.d/$username.conf
    sudo supervisorctl reread
    sudo supervisorctl update
fi

# Return back to the original directory
cd $initial_working_directory || exit
