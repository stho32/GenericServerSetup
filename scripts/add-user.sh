#!/bin/bash

# Get the name of the user to add from the command line arguments
user_name=$1

# Use the 'id' command to check if the user exists
user_exists=$(id $user_name)

# Check if the user exists
if [ -z "$user_exists" ]; then
    # If the user does not exist, use the 'adduser' command to add the user to the system
    adduser $user_name
else
    # If the user exists, print a message to the console
    echo "The user '$user_name' already exists on the system"
fi
