#!/bin/bash

# Base directory for storing user data
BASE_DIR="./users"

# Define colors
LIGHT_GREEN='\033[1;32m'
BLUE='\033[0;34m'
NO_COLOR='\033[0m'

TASK_FILE="$1"

# Function to show all tasks
function show_tasks {
    clear
    echo "     ---------------------------------------"
    echo -e "     ${LIGHT_GREEN}                All Tasks                ${NO_COLOR}"
    echo "     ---------------------------------------"
    echo ""
    if [ -s $TASK_FILE ]; then
        # Print the header with colors
        echo -e "${LIGHT_GREEN}ID${NO_COLOR}          |${LIGHT_GREEN}Name${NO_COLOR}                 |${LIGHT_GREEN}Description${NO_COLOR}                     |${LIGHT_GREEN}DUE DATE${NO_COLOR}    |${LIGHT_GREEN}PRIORITY${NO_COLOR}    |${LIGHT_GREEN}Status${NO_COLOR}"
        echo "------------+--------------------+--------------------------------+------------+------------+----------"
        
        # Use awk to print the task data
        awk -F, '{printf "%-10s | %-20s | %-30s | %-10s | %-10s | %-10s\n", $6, $1, $2, $3, $4, $5}' $TASK_FILE
    else
        echo "No tasks added."
    fi
    echo ""
    echo -n -e "Press any key to return to the main menu..."
    read -n 1
    bash  ./menu.sh "$TASK_FILE"
}

# Call the function to show tasks
clear
show_tasks
