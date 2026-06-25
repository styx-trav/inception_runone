FROM debian:bookworm

RUN apt update -y && apt install php php-fpm php-mysql wget curl mariadb-client -y

RUN mkdir -p /var/www/html

RUN mkdir -p /run/php

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar

RUN chmod +x wp-cli.phar

RUN mv wp-cli.phar /usr/local/bin/wp

RUN wget https://wordpress.org/latest.tar.gz

RUN tar -xf latest.tar.gz

RUN mv wordpress/* /var/www/html

RUN rm -rf latest.tar.gz

RUN rm -rf wordpress

RUN chown www-data:www-data /var/www/html -R

COPY www.conf /etc/php/8.2/fpm/pool.d/

WORKDIR /var/www/html/

EXPOSE 9000

COPY script.sh ./

CMD ["bash", "script.sh"]
