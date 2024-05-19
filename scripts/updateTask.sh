#!/bin/bash

# Base directory for storing user data
BASE_DIR="./users"

# Define colors
LIGHT_GREEN='\033[1;32m'
NO_COLOR='\033[0m'

TASK_FILE="$HOME/Documents/OsProject/dataFiles/Tasks.txt"

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

# Function to validate status
function validate_status {
    case $(echo $1 | tr '[:upper:]' '[:lower:]') in
        "not started"|"in progress"|"done") return 0 ;;
        *) return 1 ;;
    esac
}

source ./sendMail.sh

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
                    echo ""
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

	    #Multi Line Email Message
    multi_line_message="
Task Id $task_id Updated Sucessfully. Updated Details are:    
Task Name: $new_task_name
Description: $new_task_desc
Due Date: $new_task_date
Priority: $new_task_priority
Status: $new_task_status"
    # Send email notification
    #send_email "nafeesayousaf2129@gmail.com" "Task Id $task_id Updated Sucessfully" "$multi_line_message"


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

