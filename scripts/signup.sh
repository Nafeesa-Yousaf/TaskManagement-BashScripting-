#!/bin/bash

source sendMail.sh

# Define colors
LIGHT_GREEN='\033[1;32m'
BLUE='\033[0;34m'
RED='\033[31m'
YELLOW='\033[33m'
MAGENTA='\033[35m'
CYAN='\033[36m'
GREY='\033[90m'
NO_COLOR='\033[0m'

# Function to check if a username already exists
function is_username_exist {
    local username="$1"
    grep -q "^$username," "$HOME/Documents/OsProject/dataFiles/UserCredentials/userDetails.txt"
}

# Function to check if an email already exists
function is_email_exist {
    local email="$1"
    grep -q ",$email," "$HOME/Documents/OsProject/dataFiles/UserCredentials/userDetails.txt"
}

# Function to sign up a new user
function signup {
    clear
    local retry_choice=""

    while true; do
        # Validate and prompt for username
        while true; do
        echo "    ---------------------------------------"
        echo -e "${LIGHT_GREEN}           Task Management System          ${NO_COLOR}"
        echo "    ---------------------------------------"
        echo ""
        echo -e "${GREY}     ---------------------------------------${NO_COLOR}"
    echo -e "${LIGHT_GREEN}        Welcome to the Signup system!             ${NO_COLOR}"
    echo -e "${GREY}     ---------------------------------------${NO_COLOR}"
    echo ""
            echo -n "Enter username (no spaces allowed): "
            read username
            if [[ -z "$username" || "$username" == *" "* ]]; then
                echo -e "${RED}Invalid username. Username cannot be empty or contain spaces.${NO_COLOR}"
            elif is_username_exist "$username"; then
                echo -e "${RED}Username already exists.${NO_COLOR}"
                echo ""
                read -p "Do you want to retry with a different username? (y/n): " retry_choice
                if [[ "$retry_choice" == "n" ]]; then
                    echo -e "${BLUE}Press Any key to exit:${NO_COLOR} "
                    read -n 1
                    bash ./menu.sh
                fi
            else
                break
            fi
        done

        # Validate and prompt for email
        while true; do
            echo -n "Enter email address: "
            read email
            if [[ ! "$email" =~ ^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}$ ]]; then
                echo -e "${RED}Invalid email address. Please enter a valid email.${NO_COLOR}"
                echo ""
            elif is_email_exist "$email"; then
                echo -e "${RED}Email already exists.${NO_COLOR}"
                echo ""
                read -p "Do you want to retry with a different email? (y/n): " retry_choice
                if [[ "$retry_choice" == "n" ]]; then
                    echo -e "${BLUE}Press Any key to exit:${NO_COLOR} "
                    read -n 1
                    bash ./menu.sh
                fi
            else
                break
            fi
        done

        # Validate and prompt for password
        while true; do
            echo -n "Enter password (min. 4 characters): "
            read -s password
            echo
            if (( ${#password} < 4 )); then
                echo -e "${RED}Password must be at least 4 characters long.${NO_COLOR}"
                echo ""
            else
                break
            fi
        done

        # Store user details in a file
        echo "$username,$email,$password" >> "$HOME/Documents/OsProject/dataFiles/UserCredentials/userDetails.txt"

        # Create a tasks file for the user
        touch "$HOME/Documents/OsProject/dataFiles/Tasks/"$username"_Tasks.txt"
        USER_TASKS="$HOME/Documents/OsProject/dataFiles/Tasks/"$username"_Tasks.txt"
	#Multi Line Email Message
    multi_line_message="
Your Account is Created Successfully"
    # Send email notification
    #send_email "$email" "Account Created Sucessfully" "$multi_line_message"
  
    	echo "$email,$USER_TASKS" >> "$HOME/Documents/OsProject/dataFiles/UserCredentials/userTaskDetails.txt"
        echo -e "${LIGHT_GREEN}User signed up successfully.${NO_COLOR}"
        echo ""
        echo -e "${BLUE}Press Any key to Continue:${NO_COLOR} "
        read -n 
        bash ./login.sh
    done
}

# Call the signup function
signup

