#!/bin/bash

# Base directory for storing user data
BASE_DIR="./users"

# Define colors
LIGHT_GREEN='\033[1;32m'
BLUE='\033[0;34m'
RED='\033[31m'
YELLOW='\033[33m'
MAGENTA='\033[35m'
CYAN='\033[36m'
GREY='\033[90m'
NO_COLOR='\033[0m'

TASK_FILE="$HOME/Documents/OsProject/dataFiles/Tasks.txt"
source ./sendMail.sh
# Function to delete a task
function Delete_Task {
    echo -e "${GREY}     ---------------------------------------${NO_COLOR}"
    echo -e "     ${LIGHT_GREEN}             Delete Tasks              ${NO_COLOR}"
    echo -e "${GREY}     ---------------------------------------${NO_COLOR}"
    echo ""
    if [ -s $TASK_FILE ]; then
        # Print the header with colors
        echo -e "${LIGHT_GREEN}ID${NO_COLOR}          |${LIGHT_GREEN}Name${NO_COLOR}                 |${LIGHT_GREEN}Description${NO_COLOR}                     |${LIGHT_GREEN}DUE DATE${NO_COLOR}    |${LIGHT_GREEN}PRIORITY${NO_COLOR}    |${LIGHT_GREEN}Status${NO_COLOR}"
        echo -e "${GREY}------------+--------------------+--------------------------------+------------+------------+----------${NO_COLOR}"
        
        # Use awk to print the task data
        awk -F, '{printf "%-10s | %-20s | %-30s | %-10s | %-10s | %-10s\n", $6, $1, $2, $3, $4, $5}' $TASK_FILE
        echo "" 

        echo -n -e "${YELLOW}Enter Task ID you want to delete:${NO_COLOR} "
        read id

        # Check if the ID exists
        if grep -q ",$id\$" $TASK_FILE; then
            # Read the current details of the task
            current_task=$(grep ",$id\$" $TASK_FILE)
            IFS=, read -r task_name task_desc task_date task_priority task_status task_id <<< "$current_task"

            echo ""
            echo -e "--- ${YELLOW}Current task details${NO_COLOR} ---"
            echo "----------------------------"
            echo "Name: $task_name"
            echo "Description: $task_desc"
            echo "Due Date: $task_date"
            echo "Priority: $task_priority"
            echo "Status: $task_status"
            echo "Unique ID: $task_id"
            echo "----------------------------"
            echo ""

            echo -n -e "${BLUE}Are you sure you want to delete this task? (y/n):${NO_COLOR} "
            read confirmation
            if [[ $confirmation == [yY] ]]; then
                # Delete the task
                grep -v ",$id\$" $TASK_FILE > "$TASK_FILE.tmp" && mv "$TASK_FILE.tmp" $TASK_FILE
                  #Multi Line Email Message
    multi_line_message="
Task Id $task_id Deleted Sucessfully. Task Details are:    
Task Name: $task_name
Description: $task_desc
Due Date: $task_date
Priority: $task_priority
Status: $task_status"
    # Send email notification
    #send_email "nafeesayousaf2129@gmail.com" "Task Id $task_id Deleted Sucessfully" "$multi_line_message"
                echo -e "${LIGHT_GREEN}Task deleted successfully!${NO_COLOR}"
            else
                echo -e "${RED}Task deletion cancelled.${NO_COLOR}"
            fi
        else
            echo -e "${RED}Task ID not found.${NO_COLOR}"
        fi
    else
        echo -e "${RED}No tasks here!${NO_COLOR}"
    fi
    echo ""
    echo -n -e "${BLUE}Press any key to return to the main menu...${NO_COLOR}"
    read -n 1
    bash ./menu.sh
}

clear
# Call the Delete_Task function
Delete_Task

