#!/bin/bash

# Save current directory and cd into script path
initial_working_directory=$(pwd)
my_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )

# Load common
source $my_path/../common/helpers.sh

title "Create New Application Form"

# Get user name
read -p "Enter the deployment username (e.g., demo_1):" username

# Check if the user exists
while [ -z "$username" ] || [ $(getent passwd "$username") ]; do
  echo "The username '$username' already exists."
  read -p "Enter another deployment username:" username
done

# Enter deployment user password
read -s -p "Deployment user password: " password
echo

# Confirm the password
read -s -p "Confirm deployment user password: " confirm_password
echo
if [[ "$password" != "$confirm_password" ]]; then
  echo "Passwords do not match."
  exit 1
fi

# Enter the deployment user MySQL password
read -s -p "Deployment user MySQL password: " mysql_password
echo

# Confirm the MySQL password
read -s -p "Confirm deployment user MySQL password: " confirm_mysql_password
echo
if [[ "$mysql_password" != "$confirm_mysql_password" ]]; then
  echo "Passwords do not match."
  exit 1
fi

# Enter the application port number
read -p "Application port number (e.g., 8000): " application_port

# Enter the git repo url
read -p "Git repo url: " git_repo_url

# Prompt the user if the app is Laravel application
app_type="laravel"

# Public SSH Key for Remote Access As Deployment User
read -p "Public SSH Key for Remote Access As Deployment User: " public_ssh_key

# Ensure the apps directory exists
if [[ ! -d $my_path/../apps ]]; then
  mkdir $my_path/../apps
fi

cd $my_path/../apps

# Create the new app config
sudo cp $my_path/_app.sh $my_path/../apps/$username.sh
sudo sed -i "s|username=UNAME|username=$username|" $my_path/../apps/$username.sh
sudo sed -i "s|password=PWORD|password=$password|" $my_path/../apps/$username.sh
sudo sed -i "s|db_password=DB_PWORD|db_password=$mysql_password|" $my_path/../apps/$username.sh
sudo sed -i "s|app_type=APP_TYPE|app_type=$app_type|" $my_path/../apps/$username.sh
sudo sed -i "s|app_port=PORT|app_port=$application_port|" $my_path/../apps/$username.sh
sudo sed -i "s|repo=REPO_URL|repo=$git_repo_url|" $my_path/../apps/$username.sh
sudo sed -i "s|public_ssh_key=PUB_SSH_KEY|public_ssh_key=\"$public_ssh_key\"|" $my_path/../apps/$username.sh

title "Status"
if [ -f $my_path/../apps/$username.sh ]; then
  echo "A new application config file has been created at:"
  status "$my_path/../apps/$username.sh"
  echo ""
  echo ""
  echo "Next Steps:"
  status "1. Review the config file"
  status "2. Create the application by executing: appCreate $username"
else
  error "Failed to create a new application config file."
fi

# Return back to the original directory
cd $initial_working_directory || exit
