#!/usr/bin/env bash

#####################################################
# Created by cryptopool.builders for crypto use...
#####################################################
source /etc/functions.sh
source /etc/multipool.conf

echo -e " Installing LetsEncrypt and setting up SSL...$COL_RESET"
apt_install letsencrypt
hide_output sudo letsencrypt certonly -a webroot --webroot-path=${STORAGE_ROOT}/yiimp/site/web --register-unsafely-without-email --agree-tos -d "${DomainName}"
sudo rm /etc/nginx/sites-available/${DomainName}.conf
# I am SSL Man!
echo 'include /etc/nginx/blockuseragents.rules;

# NGINX Simple DDoS Defense
# limit the number of connections per single IP
	limit_conn_zone $binary_remote_addr zone=conn_limit_per_ip:10m;

# zone which we want to limit by upper values, we want limit whole server
	limit_conn conn_limit_per_ip 80;
	limit_req zone=req_limit_per_ip burst=80 nodelay;

# limit the number of requests for a given session
	limit_req_zone $binary_remote_addr zone=req_limit_per_ip:40m rate=5r/s;

server {
	if ($blockedagent) {
		return 403;
	}
	if ($request_method !~ ^(GET|HEAD|POST)$) {
		return 444;
	}

	listen 80;
	listen [::]:80;
	server_name '"${DomainName}"' www.'"${DomainName}"';
	root "/var/www/'"${DomainName}"'/html/web";
	server_tokens off;
	index index.php;
	charset utf-8;

	location / {
		return 301 https://$server_name$request_uri;
	}

	location /.well-known/acme-challenge/ {
		allow all;
	}

}

server {
	if ($blockedagent) {
		return 403;
	}
	if ($request_method !~ ^(GET|HEAD|POST)$) {
		return 444;
	}
	listen 443 ssl http2;
	listen [::]:443 ssl http2;
	server_name '"${DomainName}"' www.'"${DomainName}"';
	root /var/www/'"${DomainName}"'/html/web;
	server_tokens off;
	index index.php;
	charset utf-8;

	location / {
		try_files $uri $uri/ /index.php?$args;
	}
	location @rewrite {
		rewrite ^/(.*)$ /index.php?r=$1;
	}

	location = /favicon.ico { access_log off; log_not_found off; }
	location = /robots.txt { access_log off; log_not_found off; }

# strengthen ssl security
	ssl_certificate /etc/letsencrypt/live/'"${DomainName}"'/fullchain.pem;
	ssl_certificate_key /etc/letsencrypt/live/'"${DomainName}"'/privkey.pem;
	ssl_protocols TLSv1 TLSv1.1 TLSv1.2 TLSv1.3;
	ssl_ciphers "TLS-CHACHA20-POLY1305-SHA256:TLS-AES-256-GCM-SHA384:TLS-AES-128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-SHA384:ECDHE-RSA-AES256-SHA384:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA256";
	ssl_dhparam '"${STORAGE_ROOT}"'/ssl/dh2048.pem;
	ssl_session_cache shared:SSL:50m;
	ssl_session_timeout 1d;
	ssl_buffer_size 1400;
	ssl_stapling on;
	ssl_stapling_verify on;
	resolver 127.0.0.1 valid=86400;
	resolver_timeout 10;

# Add headers to serve security related headers
	add_header Strict-Transport-Security "max-age=15768000; preload;";
	add_header X-Content-Type-Options nosniff;
	add_header X-XSS-Protection "1; mode=block";
	add_header X-Robots-Tag none;
	add_header Content-Security-Policy "frame-ancestors 'self'";

# to boost I/O on HDD we can disable access logs
	access_log off;
	error_log '"${STORAGE_ROOT}"'/yiimp/site/log/'"${DomainName}"'.app-error.log error;

# if the request body size is more than the buffer size, then the entire (or partial)
# request body is written into a temporary file
	client_body_buffer_size 128k;

# headerbuffer size for the request header from client -- for testing environment
	client_header_buffer_size 3m;

# maximum number and size of buffers for large headers to read from client request
	large_client_header_buffers 4 256k;

# how long to wait for the client to send a request header -- for testing environment
	client_header_timeout 3m;

# copies data between one FD and other from within the kernel
# faster then read() + write()
	sendfile on;

# send headers in one peace, its better then sending them one by one
	tcp_nopush on;

# good for small data bursts in real time
	tcp_nodelay on;

# allow the server to close connection on non responding client, this will free up memory
	reset_timedout_connection on;

# request timed out -- default 60
	client_body_timeout 10;

# if client stop responding, free up memory -- default 60
	send_timeout 2;

# server will close connection after this time -- default 75
	keepalive_timeout 30;

location ~ ^/index\.php$ {
	fastcgi_split_path_info ^(.+\.php)(/.+)$;
	fastcgi_pass unix:/var/run/php/php7.3-fpm.sock;
	fastcgi_index index.php;
	include fastcgi_params;
	fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
	fastcgi_intercept_errors off;
	fastcgi_buffer_size 16k;
	fastcgi_buffers 4 16k;
	fastcgi_connect_timeout 300;
	fastcgi_send_timeout 300;
	fastcgi_read_timeout 300;
	try_files $uri $uri/ =404;
}

location ~ \.php$ {
	return 404;
}

location ~ \.sh {
	return 404;
}

location ~ /\.ht {
	deny all;
}

}
' | sudo -E tee /etc/nginx/sites-available/${DomainName}.conf >/dev/null 2>&1

restart_service nginx
restart_service php7.3-fpm
