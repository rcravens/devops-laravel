
# Create a configuration file for Nginx overrides.
sudo mkdir -p /home/$username/.config/nginx
sudo chown -R $username:$username /home/$username
sudo touch /home/$username/.config/nginx/nginx.conf
sudo ln -sf /home/$username/.config/nginx/nginx.conf /etc/nginx/conf.d/nginx.conf

# Disable XDebug On The CLI
sudo phpdismod -s cli xdebug

# Set The Nginx & PHP-FPM User
sudo sed -i "s/user .*;/user $username;/" /etc/nginx/nginx.conf
sudo sed -i "s/# server_names_hash_bucket_size.*/server_names_hash_bucket_size 64;/" /etc/nginx/nginx.conf


sudo service php8.0-fpm restart



mysql --user="root" -e "CREATE USER 'homestead'@'0.0.0.0' IDENTIFIED BY 'secret';"
mysql --user="root" -e "CREATE USER 'homestead'@'%' IDENTIFIED BY 'secret';"
mysql --user="root" -e "GRANT ALL PRIVILEGES ON *.* TO 'homestead'@'0.0.0.0' WITH GRANT OPTION;"
mysql --user="root" -e "GRANT ALL PRIVILEGES ON *.* TO 'homestead'@'%' WITH GRANT OPTION;"

# mysql --user="root" -e "CREATE DATABASE homestead character set UTF8mb4 collate utf8mb4_bin;"

sudo tee /home/$username/.my.cnf <<EOL
[mysqld]
character-set-server=utf8mb4
collation-server=utf8mb4_bin
EOL



# migrations
if [ "$is_laravel" = true ]; then
  if [ ! -f $deploy_directory/.env ]; then
      echo "NO .env FILE FOUND AT $deploy_directory/.env"
  else
    title "Migrations"
    cd $deploy_directory/releases/$foldername
    if [ "$is_new_dot_env" = true ]; then
      sudo -u $username php artisan key:generate
    fi
    sudo -u $username php artisan migrate --force

    # publish git hash into .env
    sudo -u $username sed -i "s|GIT_HASH=.*|GIT_HASH=$foldername|" $deploy_directory/.env
  fi
fi
