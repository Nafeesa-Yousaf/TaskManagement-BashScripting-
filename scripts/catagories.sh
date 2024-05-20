#!/bin/bash

# Define colors for better readability
LIGHT_GREEN='\033[1;32m'
LIGHT_BLUE='\033[1;34m'
LIGHT_RED='\033[1;31m'
LIGHT_YELLOW='\033[1;33m'
NO_COLOR='\033[0m'


TASK_FILE="$1"
EMAIL="$2"
today=$(date +%Y-%m-%d)

# Function to display tasks in a column format
function display_tasks {
    local tasks="$1"
    local category="$2"
    if [[ -z "$tasks" ]]; then
        echo -e "${LIGHT_RED}There is No Task in ${category}${NO_COLOR}"
    else
        echo -e "${LIGHT_GREEN}Task ID\t| Task Name\t| Description\t| Date\t| Status\t| Priority${NO_COLOR}"
        echo "---------------------------------------------------------------------------------"
        echo -e "$tasks" | awk -F',' '{ printf "%-8s | %-10s | %-12s | %-10s | %-10s | %-8s\n", $6, $1, $2, $3, $5, $4 }'
    fi
    echo ""
}

# Function to display tasks due today
function due_today_tasks {
    echo -e "${LIGHT_BLUE}Due Today Tasks:${NO_COLOR}"
    tasks=$(awk -F',' -v today="$today" 'tolower($3) == today' "$TASK_FILE")
    display_tasks "$tasks" "Due Today"
}

# Function to display upcoming tasks
function upcoming_tasks {
    echo -e "${LIGHT_BLUE}Upcoming Tasks:${NO_COLOR}"
    tasks=$(awk -F',' -v today="$today" 'tolower($3) > today' "$TASK_FILE")
    display_tasks "$tasks" "Upcoming"
}

# Function to display not started tasks
function not_started_tasks {
    echo -e "${LIGHT_BLUE}Not Started Tasks:${NO_COLOR}"
    tasks=$(awk -F',' 'tolower($5) == "not started"' "$TASK_FILE")
    display_tasks "$tasks" "Not Started"
}

# Function to display in progress tasks
function in_progress_tasks {
    echo -e "${LIGHT_BLUE}In Progress Tasks:${NO_COLOR}"
    tasks=$(awk -F',' 'tolower($5) == "in progress"' "$TASK_FILE")
    display_tasks "$tasks" "In Progress"
}

# Function to display done tasks
function done_tasks {
    echo -e "${LIGHT_BLUE}Done Tasks:${NO_COLOR}"
    tasks=$(awk -F',' 'tolower($5) == "done"' "$TASK_FILE")
    display_tasks "$tasks" "Done"
}

# Function to display high priority tasks
function high_priority_tasks {
    echo -e "${LIGHT_BLUE}High Priority Tasks:${NO_COLOR}"
    tasks=$(awk -F',' 'tolower($4) == "high"' "$TASK_FILE")
    display_tasks "$tasks" "High Priority"
}

# Function to display medium priority tasks
function medium_priority_tasks {
    echo -e "${LIGHT_BLUE}Medium Priority Tasks:${NO_COLOR}"
    tasks=$(awk -F',' 'tolower($4) == "medium"' "$TASK_FILE")
    display_tasks "$tasks" "Medium Priority"
}

# Function to display low priority tasks
function low_priority_tasks {
    echo -e "${LIGHT_BLUE}Low Priority Tasks:${NO_COLOR}"
    tasks=$(awk -F',' 'tolower($4) == "low"' "$TASK_FILE")
    display_tasks "$tasks" "Low Priority"
}

# Function to categorize tasks based on user input
function categorize_tasks {
    clear
    echo -e "${GREY}     ---------------------------------------${NO_COLOR}"
    echo -e "     ${LIGHT_GREEN}               Categories               ${NO_COLOR}"
    echo -e "${GREY}     ---------------------------------------${NO_COLOR}"
    echo ""
    echo -e "${LIGHT_GREEN}Select the category of tasks you want to see:${NO_COLOR}"
    echo "1. Due Today Tasks"
    echo "2. Upcoming Tasks"
    echo "3. High Priority Tasks"
    echo "4. Medium Priority Tasks"
    echo "5. Low Priority Tasks"
    echo "6. Not Started Tasks"
    echo "7. In Progress Tasks"
    echo "8. Done Tasks"
    echo -n -e "${LIGHT_YELLOW}Enter your choice (1-8):${NO_COLOR} "
    read choice
echo ""
    case $choice in
        1) due_today_tasks ;;
        2) upcoming_tasks ;;
        3) high_priority_tasks ;;
        4) medium_priority_tasks ;;
        5) low_priority_tasks ;;
        6) not_started_tasks ;;
        7) in_progress_tasks ;;
        8) done_tasks ;;
        *) echo -e "${LIGHT_RED}Invalid choice. Please enter a number between 1 and 8.${NO_COLOR}" ;;
    esac
    echo -n -e "${LIGHT_BLUE}Press any key to return to the main menu...${NO_COLOR}"
    read -n 1
    bash  ./menu.sh "$TASK_FILE" "$EMAIL"
}

# Call the categorize_tasks function
categorize_tasks
