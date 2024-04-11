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
  exit 0
fi

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

# Return back to the original directory
cd $initial_working_directory || exit
