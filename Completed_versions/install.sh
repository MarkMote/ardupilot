#!/bin/bash

# This script assumes you are using Bash.

# Copy libmaple to root
cp -R libmaple ~
sudo chmod +x ~/libmaple/arm/bin/*
# Install packages required by SITL (Software in the loop simulation)
sudo apt-get install python-matplotlib python-serial python-wxgtk2.8 python-lxml
sudo apt-get install python-scipy python-opencv ccache gawk git python-pip python-pexpect
sudo pip install pymavlink MAVProxy

# Update path if it needs to include these two new locations
contains_ccache=$(echo $PATH | grep ccache)
if [[ ! $contains_ccache ]]
    then
    echo 'export PATH=/usr/lib/ccache:$PATH' >> ~/.bashrc
fi 
contains_maplearm=$(echo $PATH | grep libmaple/arm/bin)
if [[ ! $contains_maplearm ]]
    then
    echo 'export PATH=$PATH:/libmaple/arm/bin' >> ~/.bashrc
fi
# Check for 64-Bit ubuntu. It will not work otherwise.
line=$(uname -a | grep 64)
if [[ "$?" ]]
    then
    echo "64-Bit Ubuntu Detected. Installing 32-Bit dependencies."
    sleep 2
    sudo dpkg --add-architecture i386
    sudo apt-get update
    sudo apt-get install libc6:i386 libncurses5:i386 libstdc++6:i386
fi
# Perform autotest
echo "Performing build and fly test."
sleep 4
cd ardupilot_multi_controller/Tools/autotest/
./autotest.py build.ArduCopter fly.ArduCopter 

