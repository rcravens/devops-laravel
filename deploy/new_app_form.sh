#!/bin/bash

# Save current directory and cd into script path
initial_working_directory=$(pwd)
my_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )

# Load common
source $my_path/../common/helpers.sh

# Get user name
echo "Enter the deployment username (e.g., demo_1):"
read username

# Check if the user exists
while [ -z "$username" ] || [ $(getent passwd "$username") ]; do
  echo "The username '$username' already exists."
  echo "Enter another deployment username:"
  read username
done

# Enter deployment user password
read -s -p "Deployment user password: " password

# Confirm the password
read -s -p "Confirm deployment user password: " confirm_password
if [ "$password"!= "$confirm_password" ]; then
  echo "Passwords do not match."
  exit 1
fi

# Enter the deployment user MySQL password
read -s -p "Deployment user MySQL password: " mysql_password

# Confirm the MySQL password
read -s -p "Confirm deployment user MySQL password: " confirm_mysql_password
if [ "$mysql_password"!= "$confirm_mysql_password" ]; then
  echo "Passwords do not match."
  exit 1
fi

# Enter the application port number
read -s -p "Application port number (e.g., 8000): " application_port

# Enter the git repo url
read -s -p "Git repo url: " git_repo_url

php_version="8.3"

# Prompt the user if the app is Laravel application
read -p "Is this a Laravel app?  (y or Y for Yes): " yes_or_no

# Check if the input is valid
is_laravel=0
if [[ $yes_or_no == "y" ]] || [[ $yes_or_no == "Y" ]]; then
  is_laravel=1
fi

# Public SSH Key for Remote Access As Deployment User
read -s -p "Public SSH Key for Remote Access As Deployment User: " public_ssh_key


# Return back to the original directory
cd $initial_working_directory || exit
