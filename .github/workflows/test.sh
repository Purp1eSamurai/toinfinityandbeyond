#!/bin/bash
PATH=/etc:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin

password_file='/etc/testuser.scrt'
user='user1'
ip='192.168.31.0'

apt update && apt upgrade -y
apt install mc -y
apt update && apt upgrade -y
apt install unzip -y
apt update && apt upgrade -y
apt install curl -y
apt update && apt upgrade -y
apt install curl -y
apt update && apt upgrade -y
apt install wget -y
apt update && apt upgrade -y
apt install git -y
