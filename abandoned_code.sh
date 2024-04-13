


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
