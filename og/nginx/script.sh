#!/bin/bash

if [ ! -f "/etc/nginx/ssl/naorakot.42.fr.crt" ]; then
	#make an ssl key + (temporary) rsa certifcate + signed and authenticated cert
	openssl req -nodes -new -x509 -keyout /etc/nginx/ssl/naorakot.42.fr.key -out /etc/nginx/ssl/naorakot.42.fr.crt -subj "/C=US/ST=State/L=City/O=Company/OU=Com/CN=naorakot.42.fr"
	#allow read permissions on the key and certificate
	chmod 444 /etc/nginx/ssl/naorakot.42.fr.key && chmod 444 /etc/nginx/ssl/naorakot.42.fr.crt
fi

#running nginx server
nginx -g "daemon off;"
