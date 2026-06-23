#!/bin/bash

if [ ! -f "etc/nginx/ssl/naorakot.42.fr.crt" ]; then
	#make an ssl key + (temporary) rsa certificate + signed and authenticated cert
	openssl req -nodes -new -x509 -keyout "/etc/nginx/ssl/$DOMAIN.key" -out "/etc/nginx/ssl/naorakot.42.fr.crt" -subj "/C=US/ST=State/L=City/O=Company/OU=Com/CN=naorakot.42.fr"
	#allow read permissions on key + certificate
	chmod 444 "etc/nginx/ssl/$naorakot.42.fr.key" && chmod 444 "etc/nginx/ssl/naorakot.42.fr.crt"
fi

#start the server no daemon
nginx -g "daemon off;"
