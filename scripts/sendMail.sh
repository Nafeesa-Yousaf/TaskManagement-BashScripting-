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

    if [ $? -eq 0 ]; then
        echo "Email sent successfully to $email_address"
    else
        echo "Failed to send email to $email_address"
    fi
}

# Example usage of the function
#send_email "nafeesayousaf2129@gmail.com" "Test Subject" "This is a test message."

