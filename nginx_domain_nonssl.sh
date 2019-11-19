#!/usr/bin/env bash

#####################################################
# Created by cryptopool.builders for crypto use...
#####################################################
source /etc/functions.sh
source /etc/multipool.conf

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

		location ~ /.well-known {
				allow all;
		}

}
' | sudo -E tee /etc/nginx/sites-available/${DomainName}.conf >/dev/null 2>&1

sudo ln -s /etc/nginx/sites-available/${DomainName}.conf /etc/nginx/sites-enabled/${DomainName}.conf
sudo ln -s $STORAGE_ROOT/yiimp/site/web /var/www/${DomainName}/html

restart_service nginx
restart_service php7.3-fpm
