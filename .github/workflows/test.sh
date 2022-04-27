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

#mkdir /home/myvalue
#echo "1,Шоколад,10|2,Принтер,3000|3,Книга,500|4,Монитор,7000|5,Гитара,4000 > /home/myvalue/values1.txt"
#echo "1,Иванов,USA,3|2,Петров,Canada,2|3,Chan,Japan,5|4,Дмитриев,Russia,1|5,Blackmore,Russia,4 > /home/myvalue/values.txt"


mysql -e "CREATE DATABASE IF NOT EXISTS database_test;"
mysql -e "CREATE USER IF NOT EXISTS 'usertest'@'localhost' IDENTIFIED by '$pwd';"
mysql -e "GRANT SELECT, INSERT, DELETE, UPDATE  ON database_test.* TO 'usertest'@'localhost';"
mysql -e "FLUSH PRIVILEGES;"
mysql -e "DROP TABLE IF EXISTS database_test.clients"
mysql -e "DROP TABLE IF EXISTS database_test.orders"
mysql -e "CREATE TABLE IF NOT EXISTS database_test.orders (id INT, имя text, цена INT,PRIMARY KEY(id));"
mysql -e "CREATE TABLE IF NOT EXISTS database_test.clients (id INT PRIMARY KEY, фамилия text, страна text, заказ INT, FOREIGN KEY(заказ) REFERENCES orders(id));"
#mysql -e "INSERT IGNORE INTO  database_test.orders VALUES (1, 'Шоколад', 10), (2, 'Принтер', 3000), (3, 'Книга', 500), (4, 'Монитор' 7000), (5, 'Гитара', 4000);"
#mysql -e "INSERT IGNORE INTO database_test.clients VALUES (1, 'Иванов', 'USA',3), (2, 'Петров' 'Canada'2), (3, 'Chan' 'Japan',5), (4, 'Дмитриев', 'Russia',1),(5, 'Blackmore', 'Russia',4);"
mysql -e "LOAD DATA LOCAL INFILE '/home/myvalue/values1.txt' INTO TABLE database_test.orders FIELDS TERMINATED BY ',' LINES TERMINATED BY '|';"
mysql -e "LOAD DATA LOCAL INFILE '/home/myvalue/values.txt' INTO TABLE database_test.clients FIELDS TERMINATED BY ',' LINES TERMINATED BY '|';"


mysql -e "DROP TABLE IF EXISTS database_test.temptable;"
mysql -e "DROP TABLE IF EXISTS database_test.temptable1;"
mysql -e "CREATE TABLE database_test.temptable  (id INT, имя text, цена INT,PRIMARY KEY(id));"
mysql -e "CREATE TABLE database_test.temptable1 (id INT PRIMARY KEY, фамилия text, страна text, заказ INT, FOREIGN KEY(заказ) REFERENCES orders(id));"
mysql -e "LOAD DATA LOCAL INFILE '/home/myvalue/values1.txt' INTO TABLE database_test.temptable FIELDS TERMINATED BY ',' LINES TERMINATED BY '|';"
mysql -e "LOAD DATA LOCAL INFILE '/home/myvalue/values.txt' INTO TABLE database_test.temptable1 FIELDS TERMINATED BY ',' LINES TERMINATED BY '|';"
mysql -e "UPDATE database_test.orders t1 JOIN database_test.temptable t2 ON t1.id = t2.id SET t1.имя = t2.имя;"
mysql -e "UPDATE database_test.orders t1 JOIN database_test.temptable t2 on t1.id = t2.id SET t1.цена = t2.цена;"
mysql -e "UPDATE database_test.clients t1 JOIN database_test.temptable1 t2 ON t1.id = t2.id SET t2.фамилия = t2.фамилия;"
mysql -e "UPDATE database_test.clients t1 JOIN database_test.temptable1 t2 ON t1.id = t2.id SET t2.страна = t2.страна;"
mysql -e "UPDATE database_test.clients t1 JOIN database_test.temptable1 t2 ON t1.id = t2.id SET t2.заказ = t2.заказ;"
mysql -e "DROP TABLE IF EXISTS database_test.temptable;"
mysql -e "DROP TABLE IF EXISTS database_test.temptable1;"  





