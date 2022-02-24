#!/bin/bash

# Install Redis
sudo apt-get install -y redis-server
sudo systemctl enable redis-server
sudo service redis-server start
