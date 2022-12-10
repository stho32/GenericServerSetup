#!/bin/bash

# Set the name of the user to add
user_name=stho32

# Call the 'add_user.sh' script to add the user to the system
bash ./scripts/add_user.sh $user_name

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
