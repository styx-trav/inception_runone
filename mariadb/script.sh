#!/bin/bash

if [ ! -f "/var/lib/mysql/$DB_NAME/db.opt" ]; then
	#first, a start
	service mariadb start

	#then install + root config
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

	#record the current process pid
	MYOWNPID=$!

	#waiting until the database is responsive
	until mariadb -u root -p$DB_ROOT_PWD -e 'SELECT 1;' &>/dev/null; do sleep 3; done

	#create database
	echo "CREATE DATABASE IF NOT EXISTS $DB_NAME CHARACTER SET uft8 COLLATE uft8_generate_ci;" | mariadb -u root -p$DB_ROOT_PWD

	#create user for wordpress use
	echo "CREATE USER IF NOT EXISTS '$DB_USR'@'%' IDENTIFIED BY '$DB_PWD';" | mariadb -u root -p$DB_ROOT_PWD
	
	#allowing editing permission to the worpdress user
	echo "GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USR'@'%' IDENTIFIED BY '$DB_PWD';" | mariadb -u root -p$DB_ROOT_PWD
	
	#flush so the changes take effect
	echo "FLUSH PRIVILEGES;" | mariadb -u root -p$DB_ROOT_PWD
	
	#shutdown the current mariadb process for reset, then wait until its finished
	
	mysqladmin -u root -p$DB_ROOT_PWD shutdown
	wait $MYOWNPID
fi

#run the mariadb server
exec mysqld --user=msql
