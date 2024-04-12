#!/bin/bash

ls -dt $deploy_directory/releases/* | tail -n +6 | xargs rm -rf
