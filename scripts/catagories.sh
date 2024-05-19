#!/bin/bash

TASK_FILE="$HOME/Documents/OsProject/dataFiles/Tasks.txt"
today=$(date +%Y-%m-%d)

# Function to display tasks in a column format
function display_tasks {
    local tasks="$1"
    if [[ -z "$tasks" ]]; then
        echo "There is No Task in $2"
    else
        echo -e "Task ID\t| Task Name\t| Description\t| Date\t| Status\t| Priority"
        echo "---------------------------------------------------------------------------------"
        echo -e "$tasks" | awk -F',' '{ printf "%-8s | %-10s | %-12s | %-10s | %-10s | %-8s\n", $6, $1, $2, $3, $5, $4 }'
    fi
    echo ""
}

function due_today_tasks {
    echo "Due Today Tasks:"
    tasks=$(awk -F',' -v today="$today" 'tolower($3) == today' "$TASK_FILE")
    display_tasks "$tasks" "Due Today"
}

function upcoming_tasks {
    echo "Upcoming Tasks:"
    tasks=$(awk -F',' -v today="$today" 'tolower($3) > today' "$TASK_FILE")
    display_tasks "$tasks" "Upcomming"
}

function not_started_tasks {
    echo "Not Started Tasks:"
    tasks=$(awk -F',' 'tolower($5) == "not started"' "$TASK_FILE")
    display_tasks "$tasks" "Not Started"
}

function in_progress_tasks {
    echo "In Progress Tasks:"
    tasks=$(awk -F',' 'tolower($5) == "in progress"' "$TASK_FILE")
    display_tasks "$tasks" "In Progress"
}

function done_tasks {
    echo "Done Tasks:"
    tasks=$(awk -F',' 'tolower($5) == "done"' "$TASK_FILE")
    display_tasks "$tasks" "Done"
}

function high_priority_tasks {
    echo "High Priority Tasks:"
    tasks=$(awk -F',' 'tolower($4) == "high"' "$TASK_FILE")
    display_tasks "$tasks" "High Priority"
}

function medium_priority_tasks {
    echo "Medium Priority Tasks:"
    tasks=$(awk -F',' 'tolower($4) == "medium"' "$TASK_FILE")
    display_tasks "$tasks" "Medium Priority"
}

function low_priority_tasks {
    echo "Low Priority Tasks:"
    tasks=$(awk -F',' 'tolower($4) == "low"' "$TASK_FILE")
    display_tasks "$tasks" "Low Priority"
}

# Function to categorize tasks based on user input
function categorize_tasks {
    echo "Select the category of tasks you want to see:"
    echo "1. Due Today Tasks"
    echo "2. Upcoming Tasks"
    echo "3. High Priority Tasks"
    echo "4. Medium Priority Tasks"
    echo "5. Low Priority Tasks"
    echo "6. Not Started Tasks"
    echo "7. In Progress Tasks"
    echo "8. Done Tasks"
    echo -n "Enter your choice (1-8): "
    read choice

    case $choice in
        1) due_today_tasks ;;
        2) upcoming_tasks ;;
        3) high_priority_tasks ;;
        4) medium_priority_tasks ;;
        5) low_priority_tasks ;;
        6) not_started_tasks ;;
        7) in_progress_tasks ;;
        8) done_tasks ;;
        *) echo "Invalid choice. Please enter a number between 1 and 8." ;;
    esac
}

# Call the categorize_tasks function
categorize_tasks

