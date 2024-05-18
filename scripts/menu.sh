#!/bin/bash

# Define colors
LIGHT_GREEN='\033[1;32m'
NO_COLOR='\033[0m'

SCRIPT_PATH='/home/nafeesa-yousaf/Documents/OsProject/scripts/';
# Function to display the main menu
function main_menu {
    clear
    echo "---------------------------------------"
    echo -e "${LIGHT_GREEN}         Task Management System        ${NO_COLOR}"
    echo "---------------------------------------"
    echo ""
    echo -e "${LIGHT_GREEN} 1. Add New Task${NO_COLOR}"
    echo -e "${LIGHT_GREEN} 2. Show All Tasks${NO_COLOR}"
    echo -e "${LIGHT_GREEN} 3. Edit Task${NO_COLOR}"
    echo -e "${LIGHT_GREEN} 4. Delete Task${NO_COLOR}"
    echo -e "${LIGHT_GREEN} 5. Search Task${NO_COLOR}"
    echo -e "${LIGHT_GREEN} 6. Logout${NO_COLOR}"
    echo -n "Choose an option: "
    read choice
    case $choice in
        1) bash  "$SCRIPT_PATH"createTask.sh;;
        2) bash  "$SCRIPT_PATH"displayAllTasks.sh ;;
        3) edit_task ;;
        4) delete_task ;;
        5) search_task ;;
        6) logout ;;
        *) echo "Invalid option. Try again."; main_menu ;;
    esac
    echo ""
}

main_menu
