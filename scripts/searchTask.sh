#!/bin/bash

# Base directory for storing user data
BASE_DIR="./users"

# Define colors
LIGHT_GREEN='\033[1;32m'
NO_COLOR='\033[0m'

TASK_FILE="$1"

# Function to search for a task by name
function search_task {
    if [ -s $TASK_FILE ]; then
        echo -n "Enter the task name you want to search for: "
        read search_name

        # Search for the task name (case-insensitive)
        matching_tasks=$(grep -i "^$search_name," $TASK_FILE)
	
        if [ -n "$matching_tasks" ]; then
            IFS=, read -r task_name task_desc task_date task_priority task_status task_id <<< "$matching_tasks"
            echo "Current task details:"
            echo "Name: $task_name"
            echo "Description: $task_desc"
            echo "Due Date: $task_date"
            echo "Priority: $task_priority"
            echo "Status: $task_status"
            echo "Unique ID: $task_id"
        else
            echo "No tasks found with the name \"$search_name\"."
        fi
    else
        echo "No tasks added."
    fi
    echo -n "Press any key to return to the main menu..."
    read -n 1
    bash  ./menu.sh "$TASK_FILE"
}

clear
search_task

