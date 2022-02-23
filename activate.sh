#!/bin/bash

cd /srv/code/web/releases/$1

# create symlinks

if [ ! -f .env ]; then
    /bin/ln -sf /srv/code/web/.env .env
fi

if [ ! -d /srv/code/web/cache ]; then
    mkdir /srv/code/web/cache
    #chown -R rcravens:rcravens /srv/code/web/cache
fi
if [ ! -d public/cache ]; then
    /bin/ln -sf /srv/code/web/cache public/cache
fi

if [ ! -d /srv/code/web/data ]; then
    mkdir /srv/code/web/data
    #/bin/chown -R rcravens:rcravens /srv/code/web/data
fi
if [ ! -d public/data ]; then
    /bin/ln -sf /srv/code/web/data public/data
fi

if [ ! -d /srv/code/web/storage ]; then
    mkdir /srv/code/web/storage
    mkdir /srv/code/web/storage/backups
    mkdir /srv/code/web/storage/app
    mkdir /srv/code/web/storage/framework
    mkdir /srv/code/web/storage/framework/cache
    mkdir /srv/code/web/storage/framework/sessions
    mkdir /srv/code/web/storage/framework/views
    mkdir /srv/code/web/storage/logs
    /bin/chown -R rcravens:rcravens /srv/code/web/storage
fi

/bin/rm -rf storage
/bin/ln -sf /srv/code/web/storage storage

cd /srv/code/web
/usr/bin/unlink current
/bin/ln -sf /srv/code/web/releases/$1 current
#/bin/chown rcravens:rcravens /srv/code/web/current

