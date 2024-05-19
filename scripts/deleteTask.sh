#!/bin/bash

# Base directory for storing user data
BASE_DIR="./users"

# Define colors
LIGHT_GREEN='\033[1;32m'
NO_COLOR='\033[0m'

TASK_FILE="$HOME/Documents/OsProject/dataFiles/Tasks.txt"

# Function to delete a task
function Delete_Task {
    if [ -s $TASK_FILE ]; then
        echo "Name,Description,DUE DATE, PRIORITY, Status, Unique ID"
        awk -F, '{print $1","$2","$3","$4","$5","$6}' $TASK_FILE

        echo -n "Enter Task ID you want to delete: "
        read id

        # Check if the ID exists
        if grep -q ",$id\$" $TASK_FILE; then
            # Read the current details of the task
            current_task=$(grep ",$id\$" $TASK_FILE)
            IFS=, read -r task_name task_desc task_date task_priority task_status task_id <<< "$current_task"

            echo "Current task details:"
            echo "Name: $task_name"
            echo "Description: $task_desc"
            echo "Due Date: $task_date"
            echo "Priority: $task_priority"
            echo "Status: $task_status"
            echo "Unique ID: $task_id"

            echo -n "Are you sure you want to delete this task? (y/n): "
            read confirmation
            if [[ $confirmation == [yY] ]]; then
                # Delete the task
                grep -v ",$id\$" $TASK_FILE > "$TASK_FILE.tmp" && mv "$TASK_FILE.tmp" $TASK_FILE
                echo -e "${LIGHT_GREEN}Task deleted successfully!${NO_COLOR}"
            else
                echo "Task deletion cancelled."
            fi
        else
            echo "Task ID not found."
        fi
    else
        echo "No tasks added."
    fi
    echo -n "Press any key to return to the main menu..."
    read -n 1
    bash ./menu.sh
}

clear
# Call the Delete_Task function
Delete_Task

