FROM debian:bookworm

#wget and curl for the wordpress downloads
#mariadb for the database connection
#php the cgi handler
RUN apt update -y && apt install wget curl php php-fpm php-mysql mariadb-client -y

RUN mkdir -p /run/php

#wp_site volume folder for wordpress files
RUN mkdir -p /var/www/html


#wp executable install, as recommended on the git
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phara/wp-cli.phar

RUN chmod +x wp-cli.phar

RUN mv wp-cli.phar /usr/local/bin/wp


#installing the core wordpress files as recommended by the wordpress website
RUN wget https://wordpress.org/latest.tar.gz

RUN tar -xf latest.tar.gz

RUN mv wordpress/* /var/www/html

RUN rm -f latest.tar.gz && rm -rf wordpress


#changing permissions for www-data access
RUN chown www-data:www-data /var/www/html -R

#php-fpm pool conf add
COPY www.conf /etc/php/8.2/fpm/pool.d/


#readying for the script run
RUN mkdir -p /mywpscriptfolder

COPY script.sh /mywpscriptfolder/

WORKDIR /var/www/html/

EXPOSE 9000

CMD ["bash", "/mywpscriptfolder/script.sh"]
