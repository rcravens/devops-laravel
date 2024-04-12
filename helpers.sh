#!/bin/bash
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
LIGHTBLUE='\033[1;34m'
CYAN='\033[0;36m'
RED='\033[0;31m'
NC='\033[0m'
function title {
    echo -e "${YELLOW}-------------------------------------${NC}"
    echo -e "${YELLOW}$1${NC}"
    echo -e "${YELLOW}-------------------------------------${NC}"
}
function status {
  echo ""
  echo -e "${CYAN}---------> $1${NC}"
}
function error {
  echo ""
  echo -e "${RED}$1${NC}"
  echo ""
}