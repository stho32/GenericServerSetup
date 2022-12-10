#!/bin/bash

# Set the name of the user to add
user_name=stho32

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


# Check if the user is part of the 'sudo' group
if ! groups $user_name | grep -qw "sudo"; then
    # Add the user to the 'sudo' group
    sudo usermod -aG sudo $user_name
fi


# Check if the 'PermitRootLogin' option is set to 'yes' in the '/etc/ssh/sshd_config' file
if grep -q "^PermitRootLogin yes" /etc/ssh/sshd_config; then
  # Edit the '/etc/ssh/sshd_config' file and set the 'PermitRootLogin' option to 'no'
  sudo sed -i "s/^PermitRootLogin yes/PermitRootLogin no/" /etc/ssh/sshd_config

  # Restart the ssh service to apply the changes
  sudo service ssh restart
fi

# Copy the script over to the user and execute it in his name
cp ./setup-as-user.sh /home/$user_name
chown username /home/$user_name/setup-as-user.sh
su -c /home/$user_name/setup-as-user.sh $user_name

echo "setup complete"