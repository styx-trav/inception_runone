FROM debian:bookworm

#intalling nginx (server) and openssl (for https connection)
RUN apt update -y && apt install -y nginx openssl

#wp_site volume folder for wordpress files
RUN mkdir -p /var/www/html

#ssl key+certificate folder
RUN mkdir -p /etc/nginx/ssl

#special folder for the cmd script
RUN mkdir /mynscriptfolder

COPY script.sh /mynscriptfolder/

EXPOSE 443

CMD ["bash", "/mynscriptfolder/script.sh"]
