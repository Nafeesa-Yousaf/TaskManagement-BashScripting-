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
        echo "Name,Description,DUE DATE, PRIORITY, Status, Unique ID"
        while IFS=, read -r task_name task_desc task_date task_priority task_status task_id
        do
            echo "$task_name,$task_desc,$task_date,$task_priority,$task_status,$task_id"
        done < $TASK_FILE
    else
        echo "No tasks Added."
    fi
    echo -n "Press any key to return to the main menu..."
    read -n 1
}
show_tasks
