#!/bin/bash

# NodeJS
curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -

## Update Package Lists
sudo apt-get update -y

# Install Node
sudo apt-get install -y nodejs
sudo /usr/bin/npm install -g npm
sudo /usr/bin/npm install -g gulp-cli
sudo /usr/bin/npm install -g bower
sudo /usr/bin/npm install -g yarn
sudo /usr/bin/npm install -g grunt-cli