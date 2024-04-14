#!/bin/bash

my_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )

source $my_path/../common/helpers.sh

title "Existing Applications"
# Ensure the apps directory exists

if [[ ! -d $my_path/../apps ]]; then
  sudo mkdir $my_path/../apps
fi

existing_apps=$(ls $my_path/../apps/ | sed -e 's|\.[^.]*$||')
echo "$existing_apps"
echo ""
echo ""
