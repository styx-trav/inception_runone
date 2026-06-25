#!/bin/bash


if [ ! -f "/var/lib/mysql/$DB_NAME/db.opt" ]; then
	#first a start
	service mariadb start

	#then an install from my config file, plus root config
	mariadb-secure-installation << EOF

n
Y
$DB_ROOT_PWD
$DB_ROOT_PWD
Y
Y
Y
Y
EOF

	#record the current process pid (from the mariadb start)
	MYOWNPID=$!

	#waiting until the database is responsive
	until mariadb -u root -p$DB_ROOT_PWD -e 'SELECT 1;' &>/dev/null; do sleep 1; done

	#create database
	echo "CREATE DATABASE IF NOT EXISTS $DB_NAME CHARACTER SET utf8 COLLATE utf8_general_ci;" | mariadb -u root -p$DB_ROOT_PWD

	#create user for wordpress use
	echo "CREATE USER IF NOT EXISTS '$DB_USR'@'%' IDENTIFIED BY '$DB_PWD';" | mariadb -u root -p$DB_ROOT_PWD

	#allowing new user to edit the database
	echo "GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USR'@'%' IDENTIFIED BY '$DB_PWD';" | mariadb -u root -p$DB_ROOT_PWD

	#flush so the changes take effect
	echo "FLUSH PRIVILEGES;" | mariadb -u root -p$DB_ROOT_PWD

	#shutdown the current mariadb process for reset, then waiting until its finished
	mysqladmin -u root -p$DB_ROOT_PWD shutdown
	wait $MYOWNPID
fi

#run the server
exec mysqld --user=mysql
