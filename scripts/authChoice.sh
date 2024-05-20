#!/bin/bash

# Define colors
LIGHT_GREEN='\033[1;32m'
NO_COLOR='\033[0m'
BLUE='\033[0;34m'

SCRIPT_PATH='./';

# Function to display the main menu
function auth_choice {
    clear
    echo "    ---------------------------------------"
    echo -e "${LIGHT_GREEN}           Task Management System          ${NO_COLOR}"
    echo "    ---------------------------------------"
    echo ""
    echo -e "${LIGHT_GREEN} 1. Login${NO_COLOR}"
    echo -e "${LIGHT_GREEN} 2. Sign Up${NO_COLOR}"
    echo -n "Choose an option: "
    read choice
    case $choice in
        1) bash  "$SCRIPT_PATH"login.sh ;;
        2) bash  "$SCRIPT_PATH"signup.sh ;;
        *) echo "Invalid option. Try again."; auth_choice ;;
    esac
    echo ""
}
clear
auth_choice
