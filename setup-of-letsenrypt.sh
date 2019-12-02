#!/bin/sh

/etc/init.d/apache2 stop
/etc/init.d/nginx stop

certbot certonly -d `hostname -f` --standalone --agree-tos --email postmaster@`hostname -f`
##certbot --apache -d `hostname -f` --agree-tos --register-unsafely-without-emai
/etc/init.d/apache2 start
