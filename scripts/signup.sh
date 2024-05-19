#!/bin/bash

source sendMail.sh

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
    local retry_choice=""

    while true; do
        # Validate and prompt for username
        while true; do
            echo -n "Enter username (no spaces allowed): "
            read username
            if [[ -z "$username" || "$username" == *" "* ]]; then
                echo "Invalid username. Username cannot be empty or contain spaces."
            elif is_username_exist "$username"; then
                echo "Username already exists."
                read -p "Do you want to retry with a different username? (y/n): " retry_choice
                if [[ "$retry_choice" == "n" ]]; then
                    echo "Press Any key to exit: "
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
                echo "Invalid email address. Please enter a valid email."
            elif is_email_exist "$email"; then
                echo "Email already exists."
                read -p "Do you want to retry with a different email? (y/n): " retry_choice
                if [[ "$retry_choice" == "n" ]]; then
                    echo "Press Any key to exit: "
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
                echo "Password must be at least 4 characters long."
            else
                break
            fi
        done

        # Store user details in a file
        echo "$username,$email,$password" >> "$HOME/Documents/OsProject/dataFiles/UserCredentials/userDetails.txt"

        # Create a tasks file for the user
        touch "$HOME/Documents/OsProject/dataFiles/Tasks/"$username"_Tasks.txt"
	#Multi Line Email Message
    multi_line_message="
Your Account is Created Successfully"
    # Send email notification
    #send_email "$email" "Account Created Sucessfully" "$multi_line_message"
        echo "User signed up successfully."

        echo "Press Any key to Continue: "
        read -n 1
        bash ./menu.sh
    done
}

# Call the signup function
signup

