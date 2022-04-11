#!/bin/bash

if="ens18"
ssh="22"
http="80"
https="443"

sudo ufw allow in on "$if" to any port "$http"
sudo ufw allow in on "$if" to any port "$https"
sudo ufw allow in on "$if" to any port "$ssh" 
sudo ufw allow in on lo
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw --force enable
sudo apt update
apt install -y mc unzip curl nginx mysql-server 
sudo service nginx enable
sudo service nginx start
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


echo "'dbUser=myusername dbPass=mypassword;" > /home/mysqluserpas
pwd="$(date +%s | sha256sum | base64 | head -c 32)"
sed -i "s/mypassword/$pwd/g"  /home/mysqluserpas

sudo mysql -u root -p
CREATE DATABASE testbase;
CREATE USER myusername@localhost IDENTIFIED by ‘’;
GRANT ALL PRIVILEGES ON testbase.* TO ‘mysqluser’@’localhost’;
FLUSH PRIVILEGES;
QUIT
mysql -u mysqluser -p

USE testbase


