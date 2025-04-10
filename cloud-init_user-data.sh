#!/bin/bash

touch /tmp/black.txt
touch /tmp/blue.txt
touch /tmp/green.txt
echo $(hostname) > /tmp/black.txt # hostname command in vm
echo ${hostname} > /tmp/blue.txt # var in templatefile
echo ${ipv4_address} >> /tmp/blue.txt
echo ${ipv4_gateway} >> /tmp/blue.txt
echo ${name_server} >> /tmp/blue.txt
hostnamectl set-hostname ${hostname}
