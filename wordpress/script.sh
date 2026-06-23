#!/bin/bash

#waiting for the database to be available
until mariadb -h"$DB_HOST" -u"$DB_USR" -p"$DB_PWD" "$DB_NAME" -e 'SELECT 1;' &>/dev/null; do
	sleep 3
done

if [ ! -f "/var/www/html/wp-config.php" ]; then
	#replacing sample with an already set up wp-config.php
	rm -f wp-config-sample.php
	echo "<?php

define( 'DB_NAME', '$DB_NAME' );
define( 'DB_USER', '$DB_USR' );
define( 'DB_PASSWORD', '$DB_PWD' );
define( 'DB_HOST', 'mariadb' );
define( 'DB_CHARSET', 'utf8' );
define( 'DB_COLLATE', 'utf8_generate_ci' );

\$table_prefix = 'itspride_';

define('AUTH_KEY', '$WP_KEY_ONE');
define('SECURE_AUTH_KEY', '$WP_KEY_TWO');
define('LOGGED_IN_KEY', '$WP_KEY_THREE');
define('NONCE_KEY', '$WP_KEY_FOUR');
define('AUTH_SALT', '$WP_KEY_FIVE');
define('SECURE_AUTH_SALT', '$WP_KEY_SIX');
define('LOGGED_IN_SALT', '$WP_KEY_SEVEN');
define('NONCE_SALT', '$WP_KEY_EIGHT');

define('WP_DEBUG', true);
define('WP_DEBUG_LOG', true);
define('WP_DEBUG_DISPLAY', false);

define('WPLANG', 'fr_FR');

if ( ! defined( 'ABSPATH' ) ) {
	define( 'ABSPATH', __DIR__ . '/' );
}

require_once ABSPATH . 'wp-settings.php';
?>" > wp-config.php
	domain="naorakot.42.fr"
	#core install :: all the basic info + admin account
	wp core install --url=$domain --title=$WP_TITLE --admin_user=$WP_ADMIN --admin_password=$WP_ADMIN_PASSWORD --admin_email=$WP_ADMIN_EMAIL --allow-root
	#adding non-admin user (author of this blog)
	wp user create $WP_USER $WP_EMAIL --user_pass=$WP_PWD --role=author --allow-root
fi

#run the php-fpm (listening for nginx .php requests)
php-fpm8.1 -f #--no-daemonize
