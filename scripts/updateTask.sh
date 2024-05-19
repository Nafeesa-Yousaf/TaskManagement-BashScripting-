#!/bin/bash

# Base directory for storing user data
BASE_DIR="./users"

# Define colors
LIGHT_GREEN='\033[1;32m'
NO_COLOR='\033[0m'

TASK_FILE="$HOME/Documents/OsProject/dataFiles/Tasks.txt"

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
    case $1 in
        High|Medium|Low) return 0 ;;
        *) return 1 ;;
    esac
}

# Function to validate status
function validate_status {
    case $1 in
        "Not Started"|"In Progress"|"Done") return 0 ;;
        *) return 1 ;;
    esac
}

# Function to show all tasks
function update_task {
    if [ -s $TASK_FILE ]; then
        echo "Name,Description,DUE DATE, PRIORITY, Status, Unique ID"
        awk -F, '{print $1","$2","$3","$4","$5","$6}' $TASK_FILE

        echo -n "Enter Task ID you want to update: "
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

            # Get new task details from the user
            echo -n "Enter new task name (leave blank to keep current): "
            read new_task_name
            echo -n "Enter new task description (leave blank to keep current): "
            read new_task_desc

            # Validate date
            while true; do
                echo -n "Enter new due date (YYYY-MM-DD) (leave blank to keep current): "
                read new_task_date
                if [[ -z "$new_task_date" ]] || validate_date "$new_task_date"; then
                    break
                else
                    echo "Invalid date format. Please enter a valid date (YYYY-MM-DD)."
                fi
            done

            # Validate priority
            while true; do
                echo -n "Enter new priority (High, Medium, Low) (leave blank to keep current): "
                read new_task_priority
                if [[ -z "$new_task_priority" ]] || validate_priority "$new_task_priority"; then
                    break
                else
                    echo "Invalid priority. Please enter High, Medium, or Low."
                fi
            done

            # Validate status
            while true; do
                echo -n "Enter new status (Not Started, In Progress, Done) (leave blank to keep current): "
                read new_task_status
                if [[ -z "$new_task_status" ]] || validate_status "$new_task_status"; then
                    break
                else
                    echo "Invalid status. Please enter Not Started, In Progress, or Done."
                fi
            done

            # Use current value if new value is empty
            new_task_name=${new_task_name:-$task_name}
            new_task_desc=${new_task_desc:-$task_desc}
            new_task_date=${new_task_date:-$task_date}
            new_task_priority=${new_task_priority:-$task_priority}
            new_task_status=${new_task_status:-$task_status}

            # Replace the old task details with the new details in the file
            sed -i "s/^$task_name,$task_desc,$task_date,$task_priority,$task_status,$task_id\$/$new_task_name,$new_task_desc,$new_task_date,$new_task_priority,$new_task_status,$task_id/" $TASK_FILE

            echo -e "${LIGHT_GREEN}Task updated successfully!${NO_COLOR}"
        else
            echo "Task ID not found."
        fi
    else
        echo "No tasks added."
    fi
    echo -n "Press any key to return to the main menu..."
    read -n 1
    bash  ./menu.sh
}

clear
# Call the update_task function
update_task

