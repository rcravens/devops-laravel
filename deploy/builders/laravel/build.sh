#!/bin/bash

builder_directory=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )

# Build the application
title "Laravel Builder"

# Add symlinks before building
status "Create Symlinks"
source $builder_directory/symlinks.sh

if [ ! -f archived_deployed.lock ]; then
  status "Composer Install"
  composer install

  status "NPM Install"
  npm install

  status "Build Front End Assets"
  npm run build
else
  status "Build completed when creating archive"
fi

status "Migrations"
php artisan migrate --force

