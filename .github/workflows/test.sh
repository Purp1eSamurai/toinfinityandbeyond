#!/bin/bash

if="ens18"
ssh="22"
http="80"
https="443"
User="dbUser=usertest"
Pass="dbPass=mypassword"

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


echo "$User" "$Pass" > /home/mysqluserpas
pwd="$(date +%s | sha256sum | base64 | head -c 32)"
sed -i "s/mypassword/$pwd/g"  /home/mysqluserpas


sudo mysql -u root 
mysql -e "CREATE DATABASE IF NOT EXISTS database_test;"
mysql -e "CREATE USER IF NOT EXISTS 'usertest'@'localhost' IDENTIFIED by '$pwd';"
mysql -e "GRANT SELECT, INSERT, DELETE, UPDATE  ON database_test.* TO 'usertest'@'localhost';"
mysql -e "FLUSH PRIVILEGES;"
mysql -e "CREATE TABLE IF NOT EXISTS database_test.orders (id INT PRIMARY KEY,  наименование character varying(100) ,  цена INT);"
mysql -e "CREATE TABLE IF NOT EXISTS database_test.clients (id serial primary key, фамилия character varying(100), страна проживания character varying(100), заказ foreign key orders);"

 


