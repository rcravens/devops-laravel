#!/bin/bash

function title {
    echo "-------------------------------------"
    echo ""
    echo "$1"
    echo ""
    echo "-------------------------------------"
}

# Load the config file
#source ../config.sh

# composer install
title "Composer install"
composer install

title "NPM install"
npm install

title "Migrations"
php artisan migrate

title "Build Front End Assets"
npm run build