#!/bin/bash

function title {
    echo "-------------------------------------"
    echo ""
    echo "$1"
    echo ""
    echo "-------------------------------------"
}
function status {
  BLUE='\033[0;34m'
  NC='\033[0m'
  echo ""
  echo -e "${BLUE}--------->$ $1${NC}"
}
function error {
  RED='\033[0;31m'
  NC='\033[0m'
  echo ""
  echo -e "${RED}$1${NC}"
  echo ""
}