#!/bin/bash

# composer install
status "Composer Install"
composer install

status "NPM Install"
npm install

status "Migrations"
php artisan migrate --force

status "Build Front End Assets"
npm run build