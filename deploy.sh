#!/bin/bash

function title {
    echo "-------------------------------------"
    echo ""
    echo ""
    echo ""
    echo "$1"
    echo "-------------------------------------"
}

# create a directory for git clone
foldername=$(date +%Y%m%d%H%M%S)

{
    # create the releases directory
    title "Deploying: $foldername"
    if [ ! -d /srv/code/web/releases ]; then
        sudo mkdir /srv/code/web/releases
        sudo chown -R rcravens:rcravens /srv/code/web/releases
    fi
    cd /srv/code/web/releases
    echo  "folder=/srv/code/web/releases/$foldername"

    # git clone into this new directory
    repo=https://github.com/rcravens/laravel.git
    git clone --depth 1 $repo $foldername

    # composer install
    title Dependencies
    cd $foldername
    /usr/bin/composer install
    /usr/bin/npm install

    # create symlinks
    title Activation
    /bin/bash /srv/code/web/scripts/activate.sh $foldername

    # migrations
    title Migrations
    /usr/bin/php artisan migrate --force

    # restart services
    /bin/bash /srv/code/web/scripts/restart.sh

    # cleanup
    /bin/bash /srv/code/web/scripts/clean_up.sh

} 2>&1

