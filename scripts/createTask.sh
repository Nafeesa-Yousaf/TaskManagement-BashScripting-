#!/bin/bash

# Base directory for storing user data
BASE_DIR="./users"

# Define colors
LIGHT_GREEN='\033[1;32m'
NO_COLOR='\033[0m'

# Path to the data file (use $HOME instead of ~ for proper expansion)
# DATA_FILES="$HOME/Documents/OsProject/dataFiles/Tasks.txt"
DATA_FILES="$1"

# Function to generate Id
function generate_next_id {
    local last_id=$(awk -F, '{print $6}' "$DATA_FILES" | sort -n | tail -n 1)
    if [ -z "$last_id" ]; then
        echo "1"  # If no tasks exist yet, start with ID 1
    else
        echo "$((last_id + 1))"
    fi
}

# Function to validate date format (YYYY-MM-DD)
function validate_date {
    # Define the regex pattern for date format (YYYY-MM-DD)
    date_regex="^[0-9]{4}-[0-9]{2}-[0-9]{2}$"

    # Check if the date matches the regex pattern
    if [[ ! $1 =~ $date_regex ]]; then
        echo "Invalid date format. Please enter a date in YYYY-MM-DD format."
        return 1
    fi

    # Extract year, month, and day from the input date
    year=$(echo $1 | cut -d'-' -f1)
    month=$(echo $1 | cut -d'-' -f2)
    day=$(echo $1 | cut -d'-' -f3)

    # Validate month (should be between 01 and 12)
    if (( $month < 1 || $month > 12 )); then
        echo "Invalid month. Month must be between 01 and 12."
        return 1
    fi

    # Validate day based on the month
    case $month in
        01|03|05|07|08|10|12) max_days=31 ;;
        04|06|09|11) max_days=30 ;;
        02) 
            # Check for leap year
            if (( ($year % 4 == 0 && $year % 100 != 0) || ($year % 400 == 0) )); then
                max_days=29
            else
                max_days=28
            fi
            ;;
    esac

    # Check if the day is within the valid range
    if (( $day < 1 || $day > $max_days )); then
        echo "Invalid day for the given month. Day must be between 01 and $max_days."
        return 1
    fi

    # Check if the date is not less than today
    if [[ $1 < "$(date +%Y-%m-%d)" ]]; then
        echo "Invalid date. Date must be today or in the future."
        return 1
    fi

    # Date is valid
    return 0
}


# Function to validate priority
function validate_priority {
    case $(echo $1 | tr '[:upper:]' '[:lower:]') in
        high|medium|low) return 0 ;;
        *) return 1 ;;
    esac
}

# Source the email sender script
source ./sendMail.sh

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
            echo ""
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
    echo "$task_name,$task_desc,$task_date,$task_priority,Not Started,$(generate_next_id)" >> "$DATA_FILES"
	
    #Multi Line Email Message
    multi_line_message="
New Task Added with ID $(generate_next_id). Task Details are:
Task Name: $task_name
Description: $task_desc
Due Date: $task_date
Priority: $task_priority
Status: Not Started"
    # Send email notification
    #send_email "nafeesayousaf2129@gmail.com" "New Task Added" "$multi_line_message"

    # Show success message
    echo -e "${LIGHT_GREEN}Task added successfully!${NO_COLOR}"
	echo ""
	echo "Enter any Key to Continue..."
	read -n 1
    # Return to the main menu (assuming menu.sh exists)
    bash ./menu.sh "$DATA_FILES"
}

# Clear the screen
clear

# Call the add_task function
add_task

