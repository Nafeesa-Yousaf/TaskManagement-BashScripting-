#!/bin/bash


# Function to send task notifications to users
function send_task_notifications {
    local user_task_file="$1"

    # Read user email addresses and corresponding file addresses
    while IFS=',' read -r email file_address; do
        # Read tasks for the user from the specified file
        tasks=$(cat "$file_address")

        # Check if any tasks are due today or within the next hour
        today=$(date +%Y-%m-%d)
        current_time=$(date +%H:%M)
        while IFS=',' read -r task_name task_desc task_date task_priority task_status task_id; do
            if [[ $task_date == $today ]]; then
                # Task is due today, send notification
                send_email "$email" "Task Due Today" "Task Name: $task_name\nDescription: $task_desc\nDue Date: $task_date\nPriority: $task_priority\nStatus: $task_status"
            elif [[ $task_date == $(date -d "+1 hour" +%Y-%m-%d) && $(date +%H:%M -d "$task_date") == $current_time ]]; then
                # Task is due within the next hour, send notification
                send_email "$email" "Task Due Soon" "Task Name: $task_name\nDescription: $task_desc\nDue Date: $task_date\nPriority: $task_priority\nStatus: $task_status"
            fi
        done <<<"$tasks"
    done < "$user_task_file"
}
source sendMail.sh
# Example usage: provide the file containing user email addresses and file addresses
user_task_file="$HOME/Documents/OsProject/dataFiles/UserCredentials/userTaskDetails.txt"
send_task_notifications "$user_task_file"


