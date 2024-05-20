#!/bin/bash

# Define colors
LIGHT_GREEN='\033[1;32m'
NO_COLOR='\033[0m'
BLUE='\033[0;34m'

SCRIPT_PATH='./';
TASK_FILE="$1"
email="$2"
function logout {
    echo ""
    echo -n -e "${BLUE}Are you sure you want to logout? (y/n): ${NO_COLOR}"
    read confirm
    if [[ $confirm == [yY] ]]; then
        echo "Logging out..."
        clear
        bash  "$SCRIPT_PATH"login.sh     
    else
        main_menu
    fi
}

# Function to display the main menu
function main_menu {
    clear
    echo "    ---------------------------------------"
    echo -e "${LIGHT_GREEN}           Task Management System          ${NO_COLOR}"
    echo "    ---------------------------------------"
    echo ""
    echo -e "${LIGHT_GREEN} 1. Add New Task${NO_COLOR}"
    echo -e "${LIGHT_GREEN} 2. Show All Tasks${NO_COLOR}"
    echo -e "${LIGHT_GREEN} 3. Edit Task${NO_COLOR}"
    echo -e "${LIGHT_GREEN} 4. Delete Task${NO_COLOR}"
    echo -e "${LIGHT_GREEN} 5. Search Task${NO_COLOR}"
    echo -e "${LIGHT_GREEN} 6. Categories${NO_COLOR}"
    echo -e "${LIGHT_GREEN} 7. Logout${NO_COLOR}"
    echo -n "Choose an option: "
    read choice
    case $choice in
        1) bash  "$SCRIPT_PATH"createTask.sh "$TASK_FILE" "$email" ;;
        2) bash  "$SCRIPT_PATH"displayAllTasks.sh "$TASK_FILE" "$email" ;;
        3) bash  "$SCRIPT_PATH"updateTask.sh "$TASK_FILE" "$email" ;;
        4) bash  "$SCRIPT_PATH"deleteTask.sh "$TASK_FILE" "$email" ;;
        5) bash  "$SCRIPT_PATH"searchTask.sh "$TASK_FILE" "$email" ;;
        6) bash  "$SCRIPT_PATH"catagories.sh "$TASK_FILE" "$email" ;;
        7) logout ;;
        *) echo "Invalid option. Try again."; main_menu ;;
    esac
    echo ""
}

main_menu
