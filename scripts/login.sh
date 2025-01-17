#!/bin/bash

clear

# Define Colors
LIGHT_GREEN='\033[1;32m'
BLUE='\033[0;34m'
RED='\033[31m'
YELLOW='\033[33m'
MAGENTA='\033[35m'
CYAN='\033[36m'
GREY='\033[90m'
NO_COLOR='\033[0m'


# Function to validate login credentials
function login {
    local username="$1"
    local password="$2"
    local user_details_file="$HOME/Documents/OsProject/dataFiles/UserCredentials/userDetails.txt"

    # Check if username exists in user details file
    if grep -q "^$username,.*$" "$user_details_file"; then
        # Check if password matches for the given username
        if grep -q "^$username,.*,$password$" "$user_details_file"; then
            echo -e "${LIGHT_GREEN}Login successful. Welcome, $username!${NO_COLOR}"
            TASK_FILE="$HOME/Documents/OsProject/dataFiles/Tasks/"$username"_Tasks.txt"
            email=$(grep "^$username,.*$" "$user_details_file" | cut -d',' -f2)
            send_email "$email" "Login to Task Management " "Dear $username, You are login to Task Management"
            sleep 3
            bash ./menu.sh "$TASK_FILE" "$email"

        else
            echo "Incorrect password for username $username."
            read -p "Do you want to retry (r) or forget password (f) or exit (e)? " choice
            case $choice in
                r|R) return 1 ;; # Retry login
                f|F) retrieve_password $username && return 2 ;; # Password retrieval
                *) echo "Exiting." && exit ;; # Exit program
            esac
        fi
    else
        echo -e "${RED}Username $username does not exist.${NO_COLOR}"
        echo ""
        echo -e "${BLUE}Retry (r) or Signup (s)?${NO_COLOR} "
        read choice
        case $choice in
            r|R) return 1 ;; # Retry login
            s|S) echo "Exiting..." && bash ./signup.sh ;; # Exit program
        esac
    fi
}

source sendMail.sh
function retrieve_password {
    local username="$1"
    local user_details_file="$HOME/Documents/OsProject/dataFiles/UserCredentials/userDetails.txt"

    # Check if username exists in user details file
    if grep -q "^$username,.*$" "$user_details_file"; then
        # Extract email address associated with the username
        local email=$(grep "^$username,.*$" "$user_details_file" | cut -d',' -f2)
        # Extract password associated with the username
        local password=$(grep "^$username,.*$" "$user_details_file" | cut -d',' -f3)
        # Send email with password to the associated email address
        send_email "$email" "Password Recovery" "Your password for username $username is: $password"
        return 1
    else
        echo "Username $username does not exist."
    fi
}

clear
# Prompt user for username and password
clear
# Prompt user for username and password
echo "    ---------------------------------------"
echo -e "${LIGHT_GREEN}           Task Management System          ${NO_COLOR}"
echo "    ---------------------------------------"
echo ""
echo -e "${GREY}     ---------------------------------------${NO_COLOR}"
echo -e "${LIGHT_GREEN}        Welcome to the login system!             ${NO_COLOR}"
echo -e "${GREY}     ---------------------------------------${NO_COLOR}"
echo ""

read -p "Enter username: " username
while true; do
    
    read -s -p "Enter password: " password
    echo
    # Call the login function with the provided credentials
    login "$username" "$password"
    login_status=$?  # Capture the return status of the login function

    # Check if the password retrieval process is successful
    if [[ $login_status == 2 ]]; then
        break  # Exit the loop if password retrieval is successful
    fi
    echo ""
done

