#!/bin/bash
# Update the system and remove unnecessary packages

sudo apt update -y
sudo apt upgrade -y
sudo apt autoremove -y
sudo apt clean

