FROM debian:bookworm

RUN apt update -y && apt install -y nginx

RUN mkdir -p /var/www/html

RUN mkdir -p /etc/nginx/ssl

RUN apt install -y openssl

COPY my.conf /etc/nginx/conf.d/

COPY script.sh ./

EXPOSE 443

CMD ["bash", "./script.sh"]
