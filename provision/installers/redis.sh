#!/bin/bash

# Install Redis
sudo apt install -y redis-server
sudo systemctl enable redis-server
sudo service redis-server start
