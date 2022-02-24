#!/bin/bash

# Install Beanstalk
sudo apt-get install -y beanstalkd

# Configure Beanstalkd
sudo sed -i "s/#START=yes/START=yes/" /etc/default/beanstalkd
