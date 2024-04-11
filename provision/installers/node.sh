#!/bin/bash

# NodeJS
curl -fsSL https://deb.nodesource.com/setup_21.x | sudo -E bash -

## Update Package Lists
sudo apt-get update -y

# Install Node
sudo apt install -y nodejs
sudo /usr/bin/npm install -g npm
sudo /usr/bin/npm install -g gulp-cli
sudo /usr/bin/npm install -g bower
sudo /usr/bin/npm install -g yarn
sudo /usr/bin/npm install -g grunt-cli