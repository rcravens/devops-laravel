#!/bin/bash

sudo ls -dt /srv/code/web/releases/* | tail -n +6 | xargs sudo rm -rf
