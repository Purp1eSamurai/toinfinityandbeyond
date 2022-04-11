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
mysql -e "CREATE TABLE IF NOT EXISTS database_test.orders (id INT, имя text, цена INT,PRIMARY KEY(id));"
mysql -e "CREATE TABLE IF NOT EXISTS database_test.clients (id INT PRIMARY KEY, фамилия text, страна text, заказ INT, FOREIGN KEY(заказ) REFERENCES orders(id));"
mysql -e "INSERT IGNORE INTO database_test.orders VALUES (1, 'Шоколад', 10), (2, 'Принтер', 3000), (3, 'Книга', 500), (4, 'Монитор' 7000), (5, 'Гитара', 4000);"
mysql -e "INSERT IGNORE INTO databa_test.clients VALUES (1, 'Иванов', 'USA',3), (2, 'Петров' 'Canada'2), (3, 'Chan' 'Japan',5), (4, 'Дмитриев', 'Russia',1),(5, 'Blackmore', 'Russia',4)


