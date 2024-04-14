#!/bin/bash

builder_directory=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )

# Add symlinks before building
title "Create Symlinks"
source $builder_directory/symlinks.sh

# Build the application
title "Laravel Builder"

status "Composer Install"
composer install

status "NPM Install"
npm install

status "Migrations"
php artisan migrate --force

status "Build Front End Assets"
npm run build

