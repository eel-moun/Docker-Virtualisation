#!bin/bash

service mysql start

sed -i "s/#port/port/" /etc/mysql/mariadb.conf.d/50-server.cnf
sed -i "s/127.0.0.1/0.0.0.0/" /etc/mysql/mariadb.conf.d/50-server.cnf

echo "CREATE DATABASE IF NOT EXISTS $db_name ;" > db.sql
echo "CREATE USER IF NOT EXISTS '$admin_name'@'%' IDENTIFIED BY '$admin_pwd' ;" >> db.sql
echo "GRANT ALL PRIVILEGES ON $db_name.* TO '$admin_name'@'%' ;" >> db.sql
echo "ALTER USER 'root'@'localhost' IDENTIFIED BY '$root_pwd' ;" >> db.sql
echo "FLUSH PRIVILEGES;" >> db.sql

mysql< ./db.sql

kill $(cat /var/run/mysqld/mysqld.pid)

mysqld