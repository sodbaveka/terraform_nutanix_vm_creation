#!/bin/bash

touch ~/purple.txt
hostnamectl set-hostname "${var.vm_name}${local.current_day}"