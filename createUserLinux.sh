#!/bin/bash

echo "create user on linux"

echo "enter your user name"

# create user

read userName

sudo useradd $userName

grep $userName /etc/passwd

# change pass

echo "enter password \n"

sudo passwd $userName

echo "this system is ubuntu [y/n]"

read isUbuntu

# add user to sudo

if [ "$isSwitch" = "y" ]; then
    usermod -aG sudo $userName
else
    usermod -aG wheel $userName
fi

# change user home bash

usermod --shell /bin/bash $userName

grep $userName /etc/passwd

# add user derectory

sudo mkhomedir_helper $userName

sudo useradd -m -d /home/$userName $userName

echo "do you want switch to new user $userName [y/n]"

read isSwitch

if [ "$isSwitch" = "y" ]; then
    echo "switch to $userName"
    echo "press any key to continue"
    read
    su - $userName
else
    echo "finish...."
fi
