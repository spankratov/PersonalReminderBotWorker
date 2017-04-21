#!/usr/bin/env bash

# Simple script for required packages such as Erlang/RabitMQ and et.

SETCOLOR_SUCCESS="echo -en \\033[1;32m"
SETCOLOR_FAILURE="echo -en \\033[1;31m"
SETCOLOR_NORMAL="echo -en \\033[0;39m"
BOLD=$(tput bold)
NORMAL_FONT=$(tput sgr0)



# Firstly, update all packages
echo "${BOLD}Update your system... to Windows 10. Thx)${NORMAL_FONT}"
sudo apt-get update -y
sudo apt-get upgrade -y
if [ $? -eq 0 ]; then
    $SETCOLOR_SUCCESS
    echo -n "$(tput hpa $(tput cols))$(tput cub 6)[OK]"
    $SETCOLOR_NORMAL
    echo
else
    $SETCOLOR_FAILURE
    echo -n "$(tput hpa $(tput cols))$(tput cub 6)[fail]"
    $SETCOLOR_NORMAL
    echo
fi


# 3d, Installing DateTime parser
echo "${BOLD}Install DateUtil...${NORMAL_FONT}"
apt-get -y install python-dateutil
if [ $? -eq 0 ]; then
    $SETCOLOR_SUCCESS
    echo -n "$(tput hpa $(tput cols))$(tput cub 6)[OK]"
    $SETCOLOR_NORMAL
    echo
else
    $SETCOLOR_FAILURE
    echo -n "$(tput hpa $(tput cols))$(tput cub 6)[fail]"
    $SETCOLOR_NORMAL
    echo
fi

# 4th Flask
echo "${BOLD}Install Flask...${NORMAL_FONT}"
sudo apt install -y python-pip
sudo pip install Flask
if [ $? -eq 0 ]; then
    $SETCOLOR_SUCCESS
    echo -n "$(tput hpa $(tput cols))$(tput cub 6)[OK]"
    $SETCOLOR_NORMAL
    echo
else
    $SETCOLOR_FAILURE
    echo -n "$(tput hpa $(tput cols))$(tput cub 6)[fail]"
    $SETCOLOR_NORMAL
    echo
fi
# Installing Celery
echo "${BOLD}Install Celery...${NORMAL_FONT}"
# apt list --installed
pip install celery
if [ $? -eq 0 ]; then
    $SETCOLOR_SUCCESS
    echo -n "$(tput hpa $(tput cols))$(tput cub 6)[OK]"
    $SETCOLOR_NORMAL
    echo
else
    $SETCOLOR_FAILURE
    echo -n "$(tput hpa $(tput cols))$(tput cub 6)[fail]"
    $SETCOLOR_NORMAL
    echo
fi

echo "${BOLD}Install requests...${NORMAL_FONT}"
# apt list --installed
pip install requests
if [ $? -eq 0 ]; then
    $SETCOLOR_SUCCESS
    echo -n "$(tput hpa $(tput cols))$(tput cub 6)[OK]"
    $SETCOLOR_NORMAL
    echo
else
    $SETCOLOR_FAILURE
    echo -n "$(tput hpa $(tput cols))$(tput cub 6)[fail]"
    $SETCOLOR_NORMAL
    echo
fi
sudo adduser celery

echo "${BOLD}Build configuration files...${NORMAL_FONT}"
cd /etc/init.d/
wget https://raw.githubusercontent.com/celery/celery/3.1/extra/generic-init.d/celeryd
chmod +x celeryd
cd $HOME/PersonalReminderBot
cp -i celeryd.sh /etc/default/
sudo chown celery: /root
if [ $? -eq 0 ]; then
    $SETCOLOR_SUCCESS
    echo -n "$(tput hpa $(tput cols))$(tput cub 6)[OK]"
    $SETCOLOR_NORMAL
    echo
else
    $SETCOLOR_FAILURE
    echo -n "$(tput hpa $(tput cols))$(tput cub 6)[fail]"
    $SETCOLOR_NORMAL
    echo
fi

echo "${BOLD}Configure RabbitMQ...${NORMAL_FONT}"
read -p 'RabbitMQ Server IP: ' ip
sed -i "s/\(\@.*\/\)/@$ip\//g" default_config.py

if [ $? -eq 0 ]; then
    $SETCOLOR_SUCCESS
    echo -n "$(tput hpa $(tput cols))$(tput cub 6)[OK]"
    $SETCOLOR_NORMAL
    echo
else
    $SETCOLOR_FAILURE
    echo -n "$(tput hpa $(tput cols))$(tput cub 6)[fail]"
    $SETCOLOR_NORMAL
    echo
fi

echo "${BOLD}Start Celery Worker...${NORMAL_FONT}"

celery worker -l info -A flaskapp.celery -Q nlp,reminders

if [ $? -eq 0 ]; then
    $SETCOLOR_SUCCESS
    echo -n "$(tput hpa $(tput cols))$(tput cub 6)[OK]"
    $SETCOLOR_NORMAL
    echo
else
    $SETCOLOR_FAILURE
    echo -n "$(tput hpa $(tput cols))$(tput cub 6)[fail]"
    $SETCOLOR_NORMAL
    echo
fi


