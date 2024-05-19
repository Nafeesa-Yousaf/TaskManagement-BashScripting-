#!/bin/bash

# Function to validate login credentials
function login {
    local username="$1"
    local password="$2"
    local user_details_file="$HOME/Documents/OsProject/dataFiles/UserCredentials/userDetails.txt"

    # Check if username exists in user details file
    if grep -q "^$username,.*$" "$user_details_file"; then
        # Check if password matches for the given username
        if grep -q "^$username,.*,$password$" "$user_details_file"; then
            echo "Login successful. Welcome, $username!"
        else
            echo "Incorrect password for username $username."
            read -p "Do you want to retry (r) or forget password (f) or exit (e)? " choice
            case $choice in
                r|R) return 1 ;; # Retry login
                f|F) retrieve_password $username ;;
                *) echo "Exiting." && exit ;; # Exit program
            esac
        fi
    else
        echo "Username $username does not exist."
        read -p "Do you want to retry (r) or exit (e)? " choice
        case $choice in
            r|R) return 1 ;; # Retry login
            *) echo "Exiting." && exit ;; # Exit program
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
    else
        echo "Username $username does not exist."
    fi
}

# Prompt user for username and password
echo "Welcome to the login system."
while true; do
    read -p "Enter username: " username
    read -s -p "Enter password: " password
    echo
    # Call the login function with the provided credentials
    login "$username" "$password" && break
done

