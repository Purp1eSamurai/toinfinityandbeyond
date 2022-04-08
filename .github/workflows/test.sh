#!/bin/bash

if="eth0"
ssh="22"
http="80"
https="443"
soft="mc unzip curl wget git nginx"

sudo ufw allow in on "$if" to any port "http"
sudo ufw allow in on "$if" to any port "$https"
sudo ufw allow in on "$if" to any port "$ssh" 
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw --force enable
sudo apt-get update && upgrade
apt-get install "$soft"
service ngninx start
