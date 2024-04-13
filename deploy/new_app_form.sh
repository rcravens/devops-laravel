#!/bin/bash

# Save current directory and cd into script path
initial_working_directory=$(pwd)
my_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )

# Load common
source $my_path/../common/helpers.sh

# Get user name
echo "Enter the deployment username:"
read username

# Check if the user exists
while [ -z "$username" ] || [ $(getent passwd "$username") ]; do
  echo "The username '$username' already exists."
  echo "Enter another deployment username:"
  read username
done

exit


username=UNAME
password=PWORD
db_password=DB_PWORD

# Deployment
app_port=PORT
repo=REPO_URL
php_version=PHP_VERSION
is_laravel=IS_LARAVEL

# Public SSH Key for Remote Access As Deployment User
public_ssh_key=PUB_SSH_KEY


# Return back to the original directory
cd $initial_working_directory || exit
