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
echo "---------> Composer Install"
composer install

echo "---------> NPM Install"
npm install

echo "---------> Migrations"
php artisan migrate --force

echo "---------> Build Front End Assets"
npm run build