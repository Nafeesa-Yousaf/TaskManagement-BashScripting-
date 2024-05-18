#!/bin/bash

# Base directory for storing user data
BASE_DIR="./users"

# Define colors
LIGHT_GREEN='\033[1;32m'
NO_COLOR='\033[0m'

# Path to the data file (use $HOME instead of ~ for proper expansion)
DATA_FILES="$HOME/Documents/OsProject/dataFiles/Tasks.txt"

# Function to generate Id
function generate_id {
    cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 4 | head -n 1
}

# Function to add a new task
function add_task {
    clear
    echo "---------------------------------------"
    echo -e "${LIGHT_GREEN}           Create New Task          ${NO_COLOR}"
    echo "---------------------------------------"
    echo ""
    echo -n "Enter task name: "
    read task_name
    echo -n "Enter task description: "
    read task_desc
    echo -n "Enter Due Date: "
    read task_date
    echo -n "Enter Priority: "
    read task_priority
    if [ -z "$task_name" ]; then
     echo "Task cannot be Empty. Task not Added" 
     return
    else
    echo "$task_name,$task_desc,$task_date,$task_priority,Not Started,$(generate_id)" >> "$DATA_FILES"
    echo -e "${LIGHT_GREEN}Task added successfully!${NO_COLOR}"
    fi
    sleep 1 
    bash  "$SCRIPT_PATH"menu.sh;
}

add_task


