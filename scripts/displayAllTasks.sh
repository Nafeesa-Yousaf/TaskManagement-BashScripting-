#!/bin/bash

# Base directory for storing user data
BASE_DIR="./users"

# Define colors
LIGHT_GREEN='\033[1;32m'
NO_COLOR='\033[0m'

TASK_FILE="$HOME/Documents/OsProject/dataFiles/Tasks.txt";

# Function to show all tasks
function show_tasks {
    if [ -s $TASK_FILE ]; then
        echo "Id, Name,Description,DUE DATE, PRIORITY, Status"
        awk -F, '{print $6","$1","$2","$3","$4","$5}' $TASK_FILE
    else
        echo "No tasks Added."
    fi
    echo -n "Press any key to return to the main menu..."
    read -n 1
    bash  ./menu.sh
}
clear
show_tasks
