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

TASK_FILE="$HOME/Documents/OsProject/dataFiles/Tasks.txt"

# Function to search for a task by name
function search_task {
    clear
    echo -e "${GREY}     ---------------------------------------${NO_COLOR}"
    echo -e "     ${LIGHT_GREEN}              Search Tasks               ${NO_COLOR}"
    echo -e "${GREY}     ---------------------------------------${NO_COLOR}"
    echo ""
    if [ -s $TASK_FILE ]; then
        echo -n -e "${YELLOW}Enter the task name you want to search for:${NO_COLOR} "
        read search_name
        echo ""
        # Search for the task name (case-insensitive)
        matching_tasks=$(grep -i "^$search_name," $TASK_FILE)
	
        if [ -n "$matching_tasks" ]; then
            IFS=, read -r task_name task_desc task_date task_priority task_status task_id <<< "$matching_tasks"
            echo -e "--- ${YELLOW}Current Task Details${NO_COLOR} ---"
            echo "----------------------------"
            echo "Name: $task_name"
            echo "Description: $task_desc"
            echo "Due Date: $task_date"
            echo "Priority: $task_priority"
            echo "Status: $task_status"
            echo "Unique ID: $task_id"
            echo "----------------------------"

        else
            echo -e "${RED}No tasks found with the name \"$search_name\".${NO_COLOR}"
        fi
    else
        echo -e "${RED}No tasks added.${NO_COLOR}"
    fi
    echo ""
    echo -n -e "${BLUE}Press any key to return to the main menu...${NO_COLOR}"
    read -n 1
    bash  ./menu.sh
}

clear
search_task

