#!/bin/bash

function title {
    echo "-------------------------------------"
    echo ""
    echo "$1"
    echo ""
    echo "-------------------------------------"
}

# Save current directory and cd into script path
initial_working_directory=$(pwd)
parent_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
cd "$parent_path"

# Load the config file
source ../config.sh

# Guard against overwriting and existing user
if id "$username" >/dev/null 2>&1; then
  echo "This user already exists"
else
  # Create the deployment user
  sudo adduser --gecos "" --disabled-password $username
  sudo chpasswd <<<"$username:$password"

  # Start a new session with this new user
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

echo "----------------------COPY PUB KEY TO GITHUB DEPLOYMENT KEYS---------------------"
cat < ~/.ssh/github_rsa.pub
echo "---------------------------------------------------------------------------------"

# End session
exit
EOF
fi

# Create the initial deployment
deploy_directory=/home/$username/deployments
folder_name="initial"
sudo su - $username <<INIT
if [ ! -d $deploy_directory ]; then
  mkdir -p $deploy_directory
fi
if [ ! -d $deploy_directory/releases ]; then
    mkdir -p $deploy_directory/releases
fi
cd $deploy_directory/releases
if [ -d $folder_name ]; then
  rm -rf $folder_name
fi
git clone --depth 1 $repo $folder_name

# Build the application
cd $deploy_directory/releases/$folder_name
echo "Building the application"
source $parent_path/build.sh

# Create the initial symlinked repository
if [ ! -d $deploy_directory/symlinks ]; then
  mkdir -p $deploy_directory/symlinks
fi
if [ "$is_laravel" = true ]; then

  if [ ! -f $deploy_directory/symlinks/.env ]; then
    cp .env $deploy_directory/symlinks/.env
  fi
  if [ ! -d $deploy_directory/symlinks/public ]; then
   mkdir -p $deploy_directory/symlinks/public
  fi
  if [ ! -d $deploy_directory/symlinks/public/cache ]; then
   cp -r public/cache $deploy_directory/symlinks/public/cache
  fi
  if [ ! -d $deploy_directory/symlinks/public/data ]; then
   cp -r public/data $deploy_directory/symlinks/public/data
  fi
  if [ ! -d $deploy_directory/symlinks/storage ]; then
    cp -r storage $deploy_directory/symlinks/storage
  fi
fi

# Activate this releases
echo "-----just before the source----"
echo "pwd=$PWD"
echo "username=$username"
echo "deploy_director=$deploy_directory"
echo "parent_path=$parent_path"
echo "is_laravel="$is_laravel
echo "-------------------------------------"
source $parent_path/activate.sh

INIT

# Return back to the original directory
cd $initial_working_directory || exit
