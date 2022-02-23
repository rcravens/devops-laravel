#!/bin/bash

# Global variables that are used by the scripts

initial_working_directory=$(pwd)

parent_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )

username=deploy
