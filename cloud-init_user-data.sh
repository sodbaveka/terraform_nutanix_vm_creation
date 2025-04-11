#!/bin/bash

# Tests
touch /tmp/black.txt
touch /tmp/blue.txt
touch /tmp/green.txt
echo $(hostname) > /tmp/black.txt # hostname command in vm
echo ${hostname} > /tmp/blue.txt # var in templatefile

# Set hostname
hostnamectl set-hostname ${hostname}

# Add user
useradd -m -s /bin/bash ${new_user_name}
echo "${new_user_name}:${new_user_password}" | chpasswd
usermod -aG sudo "${new_user_name}"

# Logs
touch /var/log/MDT.log
echo $(date) > /var/log/MDT.log
echo "ipv4_address " ${ipv4_address} >> /var/log/MDT.log
echo "ipv4_gateway "${ipv4_gateway} >> /var/log/MDT.log

# Git install
apt install git -y && echo "git installed !" >> /var/log/MDT.log

## Proxmox install prep

# With git already installed on your machine, clone the repository
cd /
git clone https://github.com/mathewalves/Proxmox-Debian12.git && echo "Proxmox git clone" >> /var/log/MDT.log

# Access the downloaded folder with the 'cd' command
cd ./Proxmox-Debian12 && echo "Access the downloaded folder" >> /var/log/MDT.log

# Give execution permission to the setup
chmod +x ./setup && echo "Execution permission to the Proxmox setup" >> /var/log/MDT.log

# Launch ./setup with root