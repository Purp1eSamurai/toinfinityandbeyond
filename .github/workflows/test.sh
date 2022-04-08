#!/bin/bash

if="ens18"
ssh="22"
http="80"
https="443"

sudo ufw allow in on "$if" to any port "http"
sudo ufw allow in on "$if" to any port "$https"
sudo ufw allow in on "$if" to any port "$ssh" 
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw --force enable
sudo apt update
apt-get install -y mc
apt-get install -y unzip
apt-get install -y git
apt-get install -y wget
apt-get install -y curl
apt-get install -y nginx
apt-get install -y mysql-server
apt-get install -y mysql-client
service nginx enable
service nginx start
cat << EOF > /var/www/html/index.nginx-debian.html
<!doctype html>
<html>
<head>
    <meta charset="utf-8">
    <title>Hello, Nginx!</title>
</head>
<body>
    <h1>Hello, Nginx!</h1>
    <p>We have just configured our Nginx web server on Ubuntu Server!</p>
</body>
</html>
EOF
