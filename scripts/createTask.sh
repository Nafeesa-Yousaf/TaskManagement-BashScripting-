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

# Function to validate date format (YYYY-MM-DD)
function validate_date {
    date_regex="^[0-9]{4}-[0-9]{2}-[0-9]{2}$"
    if [[ $1 =~ $date_regex ]]; then
        return 0
    else
        return 1
    fi
}

# Function to validate priority
function validate_priority {
    case $(echo $1 | tr '[:upper:]' '[:lower:]') in
        high|medium|low) return 0 ;;
        *) return 1 ;;
    esac
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

    # Check if the task name is empty
    if [ -z "$task_name" ]; then
        echo "Task name cannot be empty. Task not added."
        return
    fi

    echo -n "Enter task description: "
    read task_desc

    # Validate due date
    while true; do
        echo -n "Enter Due Date (YYYY-MM-DD): "
        read task_date
        if validate_date "$task_date"; then
            break
        else
            echo "Invalid date format. Please enter a valid date (YYYY-MM-DD)."
        fi
    done

    # Validate priority
    while true; do
        echo -n "Enter Priority (High, Medium, Low): "
        read task_priority
        if validate_priority "$task_priority"; then
            break
        else
            echo "Invalid priority. Please enter High, Medium, or Low."
        fi
    done

    # Convert priority to proper case (e.g., "High" instead of "high")
    task_priority=$(echo $task_priority | tr '[:lower:]' '[:upper:]')
    case $task_priority in
        HIGH) task_priority="High" ;;
        MEDIUM) task_priority="Medium" ;;
        LOW) task_priority="Low" ;;
    esac

    # Append the task to the file
    echo "$task_name,$task_desc,$task_date,$task_priority,Not Started,$(generate_id)" >> "$DATA_FILES"
    echo -e "${LIGHT_GREEN}Task added successfully!${NO_COLOR}"
    sleep 1 
    bash  "$SCRIPT_PATH"menu.sh;
}

# Call the add_task function
add_task

