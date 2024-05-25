#!/bin/bash

# Function to send an email using sendmail
function send_email {
    local email_address="$1"
    local subject="$2"
    local message="$3"

    sendmail -t <<EOF
From: Taskbee@gmail.com
To: $email_address
Subject: $subject

$message
EOF
#    if ! ping -c 1 google.com&>/dev/null;
#    then 
#    	echo "Network error: unable to reach google.com.check your internet connection">&2
#    	return 1
#    fi
#    if ! ssh -q example.com exit&>/dev/null;
#    then 
#    	echo "SSH error: unable to build ssh connection to example.com">&2
#    	return 1
#    fi
    if [ $? -eq 0 ]; then
        echo "Notified to user sucessfully"
        
    else
        echo "Failed to send email to $email_address"
    fi
}

