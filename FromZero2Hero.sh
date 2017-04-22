#!/usr/bin/env bash

# Simple script for required packages such as Erlang/RabitMQ and et.

SETCOLOR_SUCCESS="echo -en \\033[1;32m"
SETCOLOR_FAILURE="echo -en \\033[1;31m"
SETCOLOR_NORMAL="echo -en \\033[0;39m"
BOLD=$(tput bold)
NORMAL_FONT=$(tput sgr0)



# Firstly, update all packages
echo "${BOLD}Update your system... to Windows 10. Thx)${NORMAL_FONT}"
#sudo apt-get update -y
#sudo apt-get upgrade -y
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.deb.sh | sudo bash
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

# Secondly, Installing RabbitMQ
echo "${BOLD}Install RabbitMQ...${NORMAL_FONT}"

sudo apt-get install -y rabbitmq-server
sudo systemctl start rabbitmq-server
sudo systemctl enable rabbitmq-server

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

echo "${BOLD}Enable RabbitMQ plugins...${NORMAL_FONT}"
sudo rabbitmqctl add_user radmin a
sudo rabbitmqctl set_user_tags radmin administrator
sudo rabbitmqctl set_permissions -p / radmin ".*" ".*" ".*"
sudo rabbitmq-plugins enable rabbitmq_management


# 5th
echo "${BOLD}Add Worker users...${NORMAL_FONT}"
# add new user
sudo rabbitmqctl add_user worker w
# add new virtual host
sudo rabbitmqctl add_vhost vhost
# set permissions for user on vhost
sudo rabbitmqctl set_permissions -p vhost worker ".*" ".*" ".*"
sudo rabbitmqctl set_permissions -p vhost radmin ".*" ".*" ".*"

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

# Installing Celery
echo "${BOLD}Fix Celery...${NORMAL_FONT}"
# apt list --installed
pip install -e git://github.com/alanhamlett/celery.git@73147a9da31f2932eb4778e9474fbe72f23d21c2#egg=Celery
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

echo "${BOLD}Add Celery user...${NORMAL_FONT}"

sudo adduser celery
chown -R celery:celery /var/log/celery/
chown -R celery:celery /var/run/celery/

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

echo "${BOLD}Build configuration files...${NORMAL_FONT}"
cd /etc/init.d/
wget https://raw.githubusercontent.com/celery/celery/3.1/extra/generic-init.d/celeryd
chmod +x celeryd
cd /home/PersonalReminderBotWorker
cp -i celeryd.sh /etc/default/
#sudo chown celery: /root/PersonalReminderBotWorker
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

# Configure Worker
echo "${BOLD}Let's configure this worker! ${NORMAL_FONT}"

read -p 'Bot token: ' token
read -p 'Gateway URL: ' gt
echo  >> default_config.py
echo 'BOT_TOKEN = "'$token'"' >> default_config.py
echo  >> default_config.py
echo 'GATEWAY_URL = "'$gt'"' >> default_config.py
echo  >> default_config.py
echo 'RETRANSMISSION_URL = "'$gt'/retransmit/'$token'"' >> default_config.py
echo  >> default_config.py

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

# Return url for management console
echo "${BOLD}RabbitMQ web management console${NORMAL_FONT}"
$SETCOLOR_SUCCESS
ip route get 8.8.8.8 | awk '{a = $NF; print "URL: " a ":15672"; exit}'
$SETCOLOR_NORMAL
echo

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

#echo "${BOLD}Start Celery Worker...${NORMAL_FONT}"
#
#celery worker -l info -A flaskapp.celery -Q nlp,reminders --statedb=/var/run/celery/%n.state --autoscale=10,3
#
#if [ $? -eq 0 ]; then
#    $SETCOLOR_SUCCESS
#    echo -n "$(tput hpa $(tput cols))$(tput cub 6)[OK]"
#    $SETCOLOR_NORMAL
#    echo
#else
#    $SETCOLOR_FAILURE
#    echo -n "$(tput hpa $(tput cols))$(tput cub 6)[fail]"
#    $SETCOLOR_NORMAL
#    echo
#fi

#echo "${BOLD}Configure RabbitMQ...${NORMAL_FONT}"
#read -p 'RabbitMQ Server IP: ' ip
#sed -i "s/\(\@.*\/\)/@$ip\//g" default_config.py
#
#if [ $? -eq 0 ]; then
#    $SETCOLOR_SUCCESS
#    echo -n "$(tput hpa $(tput cols))$(tput cub 6)[OK]"
#    $SETCOLOR_NORMAL
#    echo
#else
#    $SETCOLOR_FAILURE
#    echo -n "$(tput hpa $(tput cols))$(tput cub 6)[fail]"
#    $SETCOLOR_NORMAL
#    echo
#fi

