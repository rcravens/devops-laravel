#!/bin/bash

# NodeJS
curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -

## Update Package Lists
sudo apt-get update -y

# Install Node
apt-get install -y nodejs
/usr/bin/npm install -g npm
/usr/bin/npm install -g gulp-cli
/usr/bin/npm install -g bower
/usr/bin/npm install -g yarn
/usr/bin/npm install -g grunt-cli