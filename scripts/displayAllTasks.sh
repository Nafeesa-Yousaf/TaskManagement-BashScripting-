#!/bin/bash

# Base directory for storing user data
BASE_DIR="./users"

# Define colors
LIGHT_GREEN='\033[1;32m'
BLUE='\033[0;34m'
RED='\033[31m'
YELLOW='\033[33m'
MAGENTA='\033[35m'
CYAN='\033[36m'
GREY='\033[90m'
NO_COLOR='\033[0m'

TASK_FILE="$1"
EMAIL="$2"

# Function to show all tasks
function show_tasks {
    clear
    echo -e "${GREY}     ---------------------------------------${NO_COLOR}"
    echo -e "     ${LIGHT_GREEN}                All Tasks                ${NO_COLOR}"
    echo -e "${GREY}     ---------------------------------------${NO_COLOR}"
    echo ""
    if [ -s $TASK_FILE ]; then
        # Print the header with colors
        echo -e "${LIGHT_GREEN}ID${NO_COLOR}          |${LIGHT_GREEN}Name${NO_COLOR}                 |${LIGHT_GREEN}Description${NO_COLOR}                     |${LIGHT_GREEN}DUE DATE${NO_COLOR}    |${LIGHT_GREEN}PRIORITY${NO_COLOR}    |${LIGHT_GREEN}Status${NO_COLOR}"
        echo -e "${GREY}------------+--------------------+--------------------------------+------------+------------+----------${NO_COLOR}"
        
        # Use awk to print the task data
        awk -F, '{printf "%-10s | %-20s | %-30s | %-10s | %-10s | %-10s\n", $6, $1, $2, $3, $4, $5}' $TASK_FILE
    else
        echo "No tasks added."
    fi
    echo ""
    echo -n -e "${BLUE}Press any key to return to the main menu...${NO_COLOR}"
    read -n 1
    bash  ./menu.sh "$TASK_FILE" "$EMAIL"
}

# Call the function to show tasks
clear
show_tasks
