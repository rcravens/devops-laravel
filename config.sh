#!/bin/bash

# Global variables that are used by the scripts

# Deployment user
username=laravel_demo
password=secret

# Database
db_root_password=secret

# Deployment
repo=https://github.com/rcravens/laravel_demo.git
php_version=8.3
app_domain=laravel-cravens.centralus.cloudapp.azure.com
is_laravel=true



deploy_directory=/home/$username/deployments