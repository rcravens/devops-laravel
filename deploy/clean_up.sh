#!/bin/bash

sudo ls -dt $deploy_directory/releases/* | tail -n +6 | xargs sudo rm -rf
