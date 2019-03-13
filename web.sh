#!/usr/bin/env bash

#####################################################
# Source https://mailinabox.email/ https://github.com/mail-in-a-box/mailinabox
# Updated by cryptopool.builders for crypto use...
#####################################################

source /etc/functions.sh
source /etc/multipool.conf
source $HOME/multipool/yiimp_single/.wireguard.install.cnf
source $STORAGE_ROOT/yiimp/.wireguard.conf
source $STORAGE_ROOT/yiimp/.yiimp.conf

echo Building web file structure and copying files...
cd $STORAGE_ROOT/yiimp/yiimp_setup/yiimp
sudo sed -i 's/AdminRights/'${AdminPanel}'/' $STORAGE_ROOT/yiimp/yiimp_setup/yiimp/web/yaamp/modules/site/SiteController.php
sudo cp -r $STORAGE_ROOT/yiimp/yiimp_setup/yiimp/web $STORAGE_ROOT/yiimp/site/
cd $STORAGE_ROOT/yiimp/yiimp_setup/
sudo cp -r $STORAGE_ROOT/yiimp/yiimp_setup/yiimp/bin/. /bin/
sudo mkdir -p /var/www/${DomainName}/html
sudo mkdir -p /etc/yiimp
sudo mkdir -p $STORAGE_ROOT/yiimp/site/backup/
sudo sed -i "s|ROOTDIR=/data/yiimp|ROOTDIR=${STORAGE_ROOT}/yiimp/site|g" /bin/yiimp

echo Creating NGINX config file...
echo 'map $http_user_agent $blockedagent {
		default 0;
		~*malicious 1;
		~*bot 1;
		~*backdoor  1;
		~*crawler  1;
		~*bandit 1;
}
' | sudo -E tee /etc/nginx/blockuseragents.rules >/dev/null 2>&1

if [[ ("$UsingSubDomain" == "y" || "$UsingSubDomain" == "Y" || "$UsingSubDomain" == "yes" || "$UsingSubDomain" == "Yes" || "$UsingSubDomain" == "YES") ]]; then
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
		server_name '"${DomainName}"';
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
				fastcgi_pass unix:/var/run/php/php7.2-fpm.sock;
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
restart_service php7.2-fpm

if [[ ("$InstallSSL" == "y" || "$InstallSSL" == "Y" || "$InstallSSL" == "yes" || "$InstallSSL" == "Yes" || "$InstallSSL" == "YES") ]]; then
echo Installing LetsEncrypt and setting up SSL...
apt_install letsencrypt
hide_output sudo letsencrypt certonly -a webroot --webroot-path=${STORAGE_ROOT}/yiimp/site/web --email "${SupportEmail}" --agree-tos -d "${DomainName}"
sudo rm /etc/nginx/sites-available/${DomainName}.conf
echo Generating DHPARAM, this may take awhile...
hide_output sudo openssl dhparam -out /etc/ssl/certs/dhparam.pem 2048
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
		server_name '"${DomainName}"';
		# enforce https
		return 301 https://$server_name$request_uri;
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
		server_name '"${DomainName}"';

		root /var/www/'"${DomainName}"'/html/web;
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

		# strengthen ssl security
		ssl_certificate /etc/letsencrypt/live/'"${DomainName}"'/fullchain.pem;
		ssl_certificate_key /etc/letsencrypt/live/'"${DomainName}"'/privkey.pem;
		ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
		ssl_prefer_server_ciphers on;
		ssl_session_cache shared:SSL:10m;
		ssl_ciphers "EECDH+AESGCM:EDH+AESGCM:ECDHE-RSA-AES128-GCM-SHA256:AES256+EECDH:DHE-RSA-AES128-GCM-SHA256:AES256+EDH:ECDHE-RSA-AES256-GCM-SHA384:DHE-RSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-SHA384:ECDHE-RSA-AES128-SHA256:ECDHE-RSA-AES256-SHA:ECDHE-RSA-AES128-SHA:DHE-RSA-AES256-SHA256:DHE-RSA-AES128-SHA256:DHE-RSA-AES256-SHA:DHE-RSA-AES128-SHA:ECDHE-RSA-DES-CBC3-SHA:EDH-RSA-DES-CBC3-SHA:AES256-GCM-SHA384:AES128-GCM-SHA256:AES256-SHA256:AES128-SHA256:AES256-SHA:AES128-SHA:DES-CBC3-SHA:HIGH:!aNULL:!eNULL:!EXPORT:!DES:!MD5:!PSK:!RC4";
		ssl_dhparam /etc/ssl/certs/dhparam.pem;

		# Add headers to serve security related headers
		add_header Strict-Transport-Security "max-age=15768000; preload;";
		add_header X-Content-Type-Options nosniff;
		add_header X-XSS-Protection "1; mode=block";
		add_header X-Robots-Tag none;
		add_header Content-Security-Policy "frame-ancestors 'self'";

		location ~ ^/index\.php$ {
				fastcgi_split_path_info ^(.+\.php)(/.+)$;
				fastcgi_pass unix:/var/run/php/php7.2-fpm.sock;
				fastcgi_index index.php;
				include fastcgi_params;
				fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
				fastcgi_intercept_errors off;
				fastcgi_buffer_size 16k;
				fastcgi_buffers 4 16k;
				fastcgi_connect_timeout 300;
				fastcgi_send_timeout 300;
				fastcgi_read_timeout 300;
				include /etc/nginx/fastcgi_params;
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
fi

restart_service nginx
restart_service php7.2-fpm

else
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
				fastcgi_pass unix:/var/run/php/php7.2-fpm.sock;
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
restart_service php7.2-fpm

if [[ ("$InstallSSL" == "y" || "$InstallSSL" == "Y" || "$InstallSSL" == "yes" || "$InstallSSL" == "Yes" || "$InstallSSL" == "YES") ]]; then
echo Installing LetsEncrypt and setting up SSL...
apt_install letsencrypt
hide_output sudo letsencrypt certonly -a webroot --webroot-path=${STORAGE_ROOT}/yiimp/site/web --email "${SupportEmail}" --agree-tos -d "${DomainName}" -d www."${DomainName}"
sudo rm /etc/nginx/sites-available/${DomainName}.conf
echo Generating DHPARAM, this may take awhile...
hide_output sudo openssl dhparam -out /etc/ssl/certs/dhparam.pem 2048
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
		# enforce https
		return 301 https://$server_name$request_uri;
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

		# strengthen ssl security
		ssl_certificate /etc/letsencrypt/live/'"${DomainName}"'/fullchain.pem;
		ssl_certificate_key /etc/letsencrypt/live/'"${DomainName}"'/privkey.pem;
		ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
		ssl_prefer_server_ciphers on;
		ssl_session_cache shared:SSL:10m;
		ssl_ciphers "EECDH+AESGCM:EDH+AESGCM:ECDHE-RSA-AES128-GCM-SHA256:AES256+EECDH:DHE-RSA-AES128-GCM-SHA256:AES256+EDH:ECDHE-RSA-AES256-GCM-SHA384:DHE-RSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-SHA384:ECDHE-RSA-AES128-SHA256:ECDHE-RSA-AES256-SHA:ECDHE-RSA-AES128-SHA:DHE-RSA-AES256-SHA256:DHE-RSA-AES128-SHA256:DHE-RSA-AES256-SHA:DHE-RSA-AES128-SHA:ECDHE-RSA-DES-CBC3-SHA:EDH-RSA-DES-CBC3-SHA:AES256-GCM-SHA384:AES128-GCM-SHA256:AES256-SHA256:AES128-SHA256:AES256-SHA:AES128-SHA:DES-CBC3-SHA:HIGH:!aNULL:!eNULL:!EXPORT:!DES:!MD5:!PSK:!RC4";
		ssl_dhparam /etc/ssl/certs/dhparam.pem;

		# Add headers to serve security related headers
		add_header Strict-Transport-Security "max-age=15768000; preload;";
		add_header X-Content-Type-Options nosniff;
		add_header X-XSS-Protection "1; mode=block";
		add_header X-Robots-Tag none;
		add_header Content-Security-Policy "frame-ancestors 'self'";

		location ~ ^/index\.php$ {
				fastcgi_split_path_info ^(.+\.php)(/.+)$;
				fastcgi_pass unix:/var/run/php/php7.2-fpm.sock;
				fastcgi_index index.php;
				include fastcgi_params;
				fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
				fastcgi_intercept_errors off;
				fastcgi_buffer_size 16k;
				fastcgi_buffers 4 16k;
				fastcgi_connect_timeout 300;
				fastcgi_send_timeout 300;
				fastcgi_read_timeout 300;
				include /etc/nginx/fastcgi_params;
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
fi

restart_service nginx
restart_service php7.2-fpm

fi
echo Creating YiiMP configuration files..

#Create keys file
echo '<?php
// Sample config file to put in /etc/yiimp/keys.php
define('"'"'YIIMP_MYSQLDUMP_USER'"'"', '"'"'panel'"'"');
define('"'"'YIIMP_MYSQLDUMP_PASS'"'"', '"'"''"${PanelUserDBPassword}"''"'"');
// Keys required to create/cancel orders and access your balances/deposit addresses
define('"'"'EXCH_BITTREX_SECRET'"'"', '"'"''"'"');
define('"'"'EXCH_BITSTAMP_SECRET'"'"', '"'"''"'"');
define('"'"'EXCH_BINANCE_SECRET'"'"', '"'"''"'"');
define('"'"'EXCH_BLEUTRADE_SECRET'"'"', '"'"''"'"');
define('"'"'EXCH_BTER_SECRET'"'"', '"'"''"'"');
define('"'"'EXCH_CCEX_SECRET'"'"', '"'"''"'"');
define('"'"'EXCH_CEXIO_SECRET'"'"', '"'"''"'"');
define('"'"'EXCH_COINMARKETS_PASS'"'"', '"'"''"'"');
define('"'"'EXCH_CRYPTOPIA_SECRET'"'"', '"'"''"'"');
define('"'"'EXCH_EMPOEX_SECKEY'"'"', '"'"''"'"');
define('"'"'EXCH_HITBTC_SECRET'"'"', '"'"''"'"');
define('"'"'EXCH_KRAKEN_SECRET'"'"', '"'"''"'"');
define('"'"'EXCH_KUCOIN_SECRET'"'"', '"'"''"'"');
define('"'"'EXCH_LIVECOIN_SECRET'"'"', '"'"''"'"');
define('"'"'EXCH_NOVA_SECRET'"'"', '"'"''"'"');
define('"'"'EXCH_POLONIEX_SECRET'"'"', '"'"''"'"');
define('"'"'EXCH_STOCKSEXCHANGE_SECRET'"'"', '"'"''"'"');
define('"'"'EXCH_YOBIT_SECRET'"'"', '"'"''"'"');
' | sudo -E tee /etc/yiimp/keys.php >/dev/null 2>&1

if [[ ("$wireguard" == "false") ]]; then

echo '
<?php
ini_set('"'"'date.timezone'"'"', '"'"'UTC'"'"');
define('"'"'YAAMP_LOGS'"'"', '"'"''"${STORAGE_ROOT}/yiimp/site/log"''"'"');
define('"'"'YAAMP_HTDOCS'"'"', '"'"''"${STORAGE_ROOT}/yiimp/site/web"''"'"');
define('"'"'YAAMP_BIN'"'"', '"'"'/bin'"'"');
define('"'"'YAAMP_DBHOST'"'"', '"'"''"localhost"''"'"');
define('"'"'YAAMP_DBNAME'"'"', '"'"'yiimpfrontend'"'"');
define('"'"'YAAMP_DBUSER'"'"', '"'"'panel'"'"');
define('"'"'YAAMP_DBPASSWORD'"'"', '"'"''"${PanelUserDBPassword}"''"'"');
define('"'"'YAAMP_PRODUCTION'"'"', true);
define('"'"'YAAMP_RENTAL'"'"', false);
define('"'"'YAAMP_LIMIT_ESTIMATE'"'"', false);
define('"'"'YAAMP_FEES_MINING'"'"', 0.5);
define('"'"'YAAMP_FEES_EXCHANGE'"'"', 2);
define('"'"'YAAMP_FEES_RENTING'"'"', 2);
define('"'"'YAAMP_TXFEE_RENTING_WD'"'"', 0.002);
define('"'"'YAAMP_PAYMENTS_FREQ'"'"', 3*60*60);
define('"'"'YAAMP_PAYMENTS_MINI'"'"', 0.001);
define('"'"'YAAMP_ALLOW_EXCHANGE'"'"', false);
define('"'"'YIIMP_PUBLIC_EXPLORER'"'"', false);
define('"'"'YIIMP_PUBLIC_BENCHMARK'"'"', false);
define('"'"'YIIMP_FIAT_ALTERNATIVE'"'"', '"'"'USD'"'"'); // USD is main
define('"'"'YAAMP_USE_NICEHASH_API'"'"', false);
define('"'"'YAAMP_BTCADDRESS'"'"', '"'"'12Pt3vQhQpXvyzBd5qcoL17ouhNFyihyz5'"'"');
define('"'"'YAAMP_SITE_URL'"'"', '"'"''"${DomainName}"''"'"');
define('"'"'YAAMP_STRATUM_URL'"'"', '"'"''"${StratumURL}"''"'"'); // change if your stratum server is on a different host
define('"'"'YAAMP_SITE_NAME'"'"', '"'"'CryptoPool.Builders'"'"');
define('"'"'YAAMP_ADMIN_EMAIL'"'"', '"'"''"${SupportEmail}"''"'"');
define('"'"'YAAMP_ADMIN_IP'"'"', '"'"''"${PublicIP}"''"'"'); // samples: "80.236.118.26,90.234.221.11" or "10.0.0.1/8"
define('"'"'YAAMP_ADMIN_WEBCONSOLE'"'"', true);
define('"'"'YAAMP_CREATE_NEW_COINS'"'"', false);
define('"'"'YAAMP_NOTIFY_NEW_COINS'"'"', false);
define('"'"'YAAMP_DEFAULT_ALGO'"'"', '"'"'x11'"'"');
define('"'"'YAAMP_USE_NGINX'"'"', true);
// Exchange public keys (private keys are in a separate config file)
define('"'"'EXCH_CRYPTOPIA_KEY'"'"', '"'"''"'"');
define('"'"'EXCH_POLONIEX_KEY'"'"', '"'"''"'"');
define('"'"'EXCH_BITTREX_KEY'"'"', '"'"''"'"');
define('"'"'EXCH_BLEUTRADE_KEY'"'"', '"'"''"'"');
define('"'"'EXCH_BTER_KEY'"'"', '"'"''"'"');
define('"'"'EXCH_YOBIT_KEY'"'"', '"'"''"'"');
define('"'"'EXCH_CCEX_KEY'"'"', '"'"''"'"');
define('"'"'EXCH_CEXIO_ID'"'"', '"'"''"'"');
define('"'"'EXCH_CEXIO_KEY'"'"', '"'"''"'"');
define('"'"'EXCH_COINMARKETS_USER'"'"', '"'"''"'"');
define('"'"'EXCH_COINMARKETS_PIN'"'"', '"'"''"'"');
define('"'"'EXCH_CREX24_KEY'"'"', '"'"''"'"');
define('"'"'EXCH_BINANCE_KEY'"'"', '"'"''"'"');
define('"'"'EXCH_BITSTAMP_ID'"'"', '"'"''"'"');
define('"'"'EXCH_BITSTAMP_KEY'"'"', '"'"''"'"');
define('"'"'EXCH_HITBTC_KEY'"'"', '"'"''"'"');
define('"'"'EXCH_KRAKEN_KEY'"'"', '"'"''"'"');
define('"'"'EXCH_KUCOIN_KEY'"'"', '"'"''"'"');
define('"'"'EXCH_LIVECOIN_KEY'"'"', '"'"''"'"');
define('"'"'EXCH_NOVA_KEY'"'"', '"'"''"'"');
define('"'"'EXCH_STOCKSEXCHANGE_KEY'"'"', '"'"''"'"');
// Automatic withdraw to Yaamp btc wallet if btc balance > 0.3
define('"'"'EXCH_AUTO_WITHDRAW'"'"', 0.3);
// nicehash keys deposit account & amount to deposit at a time
define('"'"'NICEHASH_API_KEY'"'"','"'"'521c254d-8cc7-4319-83d2-ac6c604b5b49'"'"');
define('"'"'NICEHASH_API_ID'"'"','"'"'9205'"'"');
define('"'"'NICEHASH_DEPOSIT'"'"','"'"'3J9tapPoFCtouAZH7Th8HAPsD8aoykEHzk'"'"');
define('"'"'NICEHASH_DEPOSIT_AMOUNT'"'"','"'"'0.01'"'"');
$cold_wallet_table = array(
'"'"'12Pt3vQhQpXvyzBd5qcoL17ouhNFyihyz5'"'"' => 0.10,
);
// Sample fixed pool fees
$configFixedPoolFees = array(
'"'"'zr5'"'"' => 2.0,
'"'"'scrypt'"'"' => 20.0,
'"'"'sha256'"'"' => 5.0,
);
// Sample custom stratum ports
$configCustomPorts = array(
// '"'"'x11'"'"' => 7000,
);
// mBTC Coefs per algo (default is 1.0)
$configAlgoNormCoef = array(
// '"'"'x11'"'"' => 5.0,
);' | sudo -E tee $STORAGE_ROOT/yiimp/site/configuration/serverconfig.php >/dev/null 2>&1

else

	echo '
	<?php
	ini_set('"'"'date.timezone'"'"', '"'"'UTC'"'"');
	define('"'"'YAAMP_LOGS'"'"', '"'"''"${STORAGE_ROOT}/yiimp/site/log"''"'"');
	define('"'"'YAAMP_HTDOCS'"'"', '"'"''"${STORAGE_ROOT}/yiimp/site/web"''"'"');
	define('"'"'YAAMP_BIN'"'"', '"'"'/bin'"'"');
	define('"'"'YAAMP_DBHOST'"'"', '"'"''"${DBInternalIP}"''"'"');
	define('"'"'YAAMP_DBNAME'"'"', '"'"'yiimpfrontend'"'"');
	define('"'"'YAAMP_DBUSER'"'"', '"'"'panel'"'"');
	define('"'"'YAAMP_DBPASSWORD'"'"', '"'"''"${PanelUserDBPassword}"''"'"');
	define('"'"'YAAMP_PRODUCTION'"'"', true);
	define('"'"'YAAMP_RENTAL'"'"', false);
	define('"'"'YAAMP_LIMIT_ESTIMATE'"'"', false);
	define('"'"'YAAMP_FEES_MINING'"'"', 0.5);
	define('"'"'YAAMP_FEES_EXCHANGE'"'"', 2);
	define('"'"'YAAMP_FEES_RENTING'"'"', 2);
	define('"'"'YAAMP_TXFEE_RENTING_WD'"'"', 0.002);
	define('"'"'YAAMP_PAYMENTS_FREQ'"'"', 3*60*60);
	define('"'"'YAAMP_PAYMENTS_MINI'"'"', 0.001);
	define('"'"'YAAMP_ALLOW_EXCHANGE'"'"', false);
	define('"'"'YIIMP_PUBLIC_EXPLORER'"'"', false);
	define('"'"'YIIMP_PUBLIC_BENCHMARK'"'"', false);
	define('"'"'YIIMP_FIAT_ALTERNATIVE'"'"', '"'"'USD'"'"'); // USD is main
	define('"'"'YAAMP_USE_NICEHASH_API'"'"', false);
	define('"'"'YAAMP_BTCADDRESS'"'"', '"'"'12Pt3vQhQpXvyzBd5qcoL17ouhNFyihyz5'"'"');
	define('"'"'YAAMP_SITE_URL'"'"', '"'"''"${DomainName}"''"'"');
	define('"'"'YAAMP_STRATUM_URL'"'"', '"'"''"${StratumURL}"''"'"'); // change if your stratum server is on a different host
	define('"'"'YAAMP_SITE_NAME'"'"', '"'"'CryptoPool.Builders'"'"');
	define('"'"'YAAMP_ADMIN_EMAIL'"'"', '"'"''"${SupportEmail}"''"'"');
	define('"'"'YAAMP_ADMIN_IP'"'"', '"'"''"${PublicIP}"''"'"'); // samples: "80.236.118.26,90.234.221.11" or "10.0.0.1/8"
	define('"'"'YAAMP_ADMIN_WEBCONSOLE'"'"', true);
	define('"'"'YAAMP_CREATE_NEW_COINS'"'"', false);
	define('"'"'YAAMP_NOTIFY_NEW_COINS'"'"', false);
	define('"'"'YAAMP_DEFAULT_ALGO'"'"', '"'"'x11'"'"');
	define('"'"'YAAMP_USE_NGINX'"'"', true);
	// Exchange public keys (private keys are in a separate config file)
	define('"'"'EXCH_CRYPTOPIA_KEY'"'"', '"'"''"'"');
	define('"'"'EXCH_POLONIEX_KEY'"'"', '"'"''"'"');
	define('"'"'EXCH_BITTREX_KEY'"'"', '"'"''"'"');
	define('"'"'EXCH_BLEUTRADE_KEY'"'"', '"'"''"'"');
	define('"'"'EXCH_BTER_KEY'"'"', '"'"''"'"');
	define('"'"'EXCH_YOBIT_KEY'"'"', '"'"''"'"');
	define('"'"'EXCH_CCEX_KEY'"'"', '"'"''"'"');
	define('"'"'EXCH_CEXIO_ID'"'"', '"'"''"'"');
	define('"'"'EXCH_CEXIO_KEY'"'"', '"'"''"'"');
	define('"'"'EXCH_COINMARKETS_USER'"'"', '"'"''"'"');
	define('"'"'EXCH_COINMARKETS_PIN'"'"', '"'"''"'"');
	define('"'"'EXCH_CREX24_KEY'"'"', '"'"''"'"');
	define('"'"'EXCH_BINANCE_KEY'"'"', '"'"''"'"');
	define('"'"'EXCH_BITSTAMP_ID'"'"', '"'"''"'"');
	define('"'"'EXCH_BITSTAMP_KEY'"'"', '"'"''"'"');
	define('"'"'EXCH_HITBTC_KEY'"'"', '"'"''"'"');
	define('"'"'EXCH_KRAKEN_KEY'"'"', '"'"''"'"');
	define('"'"'EXCH_KUCOIN_KEY'"'"', '"'"''"'"');
	define('"'"'EXCH_LIVECOIN_KEY'"'"', '"'"''"'"');
	define('"'"'EXCH_NOVA_KEY'"'"', '"'"''"'"');
	define('"'"'EXCH_STOCKSEXCHANGE_KEY'"'"', '"'"''"'"');
	// Automatic withdraw to Yaamp btc wallet if btc balance > 0.3
	define('"'"'EXCH_AUTO_WITHDRAW'"'"', 0.3);
	// nicehash keys deposit account & amount to deposit at a time
	define('"'"'NICEHASH_API_KEY'"'"','"'"'521c254d-8cc7-4319-83d2-ac6c604b5b49'"'"');
	define('"'"'NICEHASH_API_ID'"'"','"'"'9205'"'"');
	define('"'"'NICEHASH_DEPOSIT'"'"','"'"'3J9tapPoFCtouAZH7Th8HAPsD8aoykEHzk'"'"');
	define('"'"'NICEHASH_DEPOSIT_AMOUNT'"'"','"'"'0.01'"'"');
	$cold_wallet_table = array(
	'"'"'12Pt3vQhQpXvyzBd5qcoL17ouhNFyihyz5'"'"' => 0.10,
	);
	// Sample fixed pool fees
	$configFixedPoolFees = array(
	'"'"'zr5'"'"' => 2.0,
	'"'"'scrypt'"'"' => 20.0,
	'"'"'sha256'"'"' => 5.0,
	);
	// Sample custom stratum ports
	$configCustomPorts = array(
	// '"'"'x11'"'"' => 7000,
	);
	// mBTC Coefs per algo (default is 1.0)
	$configAlgoNormCoef = array(
	// '"'"'x11'"'"' => 5.0,
	);' | sudo -E tee $STORAGE_ROOT/yiimp/site/configuration/serverconfig.php >/dev/null 2>&1
fi

echo Setting correct folder permissions...
whoami=`whoami`
sudo usermod -aG www-data $whoami
sudo usermod -a -G www-data $whoami
sudo usermod -a -G crypto-data $whoami
sudo usermod -a -G crypto-data www-data

sudo find $STORAGE_ROOT/yiimp/site/ -type d -exec chmod 775 {} +
sudo find $STORAGE_ROOT/yiimp/site/ -type f -exec chmod 664 {} +

sudo chgrp www-data $STORAGE_ROOT -R
sudo chmod g+w $STORAGE_ROOT -R

cd $HOME/multipool/yiimp_single

#Updating YiiMP files for cryptopool.builders build
echo Adding the cryptopool.builders flare to YiiMP...

sudo sed -i 's/YII MINING POOLS/'${DomainName}' Mining Pool/g' $STORAGE_ROOT/yiimp/site/web/yaamp/modules/site/index.php
sudo sed -i 's/domain/'${DomainName}'/g' $STORAGE_ROOT/yiimp/site/web/yaamp/modules/site/index.php
sudo sed -i 's/Notes/AddNodes/g' $STORAGE_ROOT/yiimp/site/web/yaamp/models/db_coinsModel.php
sudo sed -i "s|serverconfig.php|${STORAGE_ROOT}/yiimp/site/configuration/serverconfig.php|g" $STORAGE_ROOT/yiimp/site/web/index.php
sudo sed -i "s|serverconfig.php|${STORAGE_ROOT}/yiimp/site/configuration/serverconfig.php|g" $STORAGE_ROOT/yiimp/site/web/runconsole.php
sudo sed -i "s|serverconfig.php|${STORAGE_ROOT}/yiimp/site/configuration/serverconfig.php|g" $STORAGE_ROOT/yiimp/site/web/run.php
sudo sed -i "s|serverconfig.php|${STORAGE_ROOT}/yiimp/site/configuration/serverconfig.php|g" $STORAGE_ROOT/yiimp/site/web/yaamp/yiic.php
sudo sed -i "s|serverconfig.php|${STORAGE_ROOT}/yiimp/site/configuration/serverconfig.php|g" $STORAGE_ROOT/yiimp/site/web/yaamp/modules/thread/CronjobController.php
sudo sed -i "s|/root/backup|${STORAGE_ROOT}/yiimp/site/backup|g" $STORAGE_ROOT/yiimp/site/web/yaamp/core/backend/system.php
sudo sed -i 's/service $webserver start/sudo service $webserver start/g' $STORAGE_ROOT/yiimp/site/web/yaamp/modules/thread/CronjobController.php
sudo sed -i 's/service nginx stop/sudo service nginx stop/g' $STORAGE_ROOT/yiimp/site/web/yaamp/modules/thread/CronjobController.php

echo '#!/usr/bin/env bash

PHP_CLI='"'"''"php -d max_execution_time=120"''"'"'

DIR='""''"${STORAGE_ROOT}"''""'/yiimp/site/web/
cd ${DIR}

date
echo started in ${DIR}

while true; do
${PHP_CLI} runconsole.php cronjob/run
sleep 90
done
exec bash' | sudo -E tee $STORAGE_ROOT/yiimp/site/crons/main.sh >/dev/null 2>&1
sudo chmod +x $STORAGE_ROOT/yiimp/site/crons/main.sh

echo '#!/usr/bin/env bash

PHP_CLI='"'"''"php -d max_execution_time=120"''"'"'

DIR='""''"${STORAGE_ROOT}"''""'/yiimp/site/web/
cd ${DIR}

date
echo started in ${DIR}

while true; do
${PHP_CLI} runconsole.php cronjob/runLoop2
sleep 60
done
exec bash' | sudo -E tee $STORAGE_ROOT/yiimp/site/crons/loop2.sh >/dev/null 2>&1
sudo chmod +x $STORAGE_ROOT/yiimp/site/crons/loop2.sh

echo '#!/usr/bin/env bash

PHP_CLI='"'"''"php -d max_execution_time=60"''"'"'

DIR='""''"${STORAGE_ROOT}"''""'/yiimp/site/web/
cd ${DIR}

date
echo started in ${DIR}

while true; do
${PHP_CLI} runconsole.php cronjob/runBlocks
sleep 20
done
exec bash' | sudo -E tee $STORAGE_ROOT/yiimp/site/crons/blocks.sh >/dev/null 2>&1
sudo chmod +x $STORAGE_ROOT/yiimp/site/crons/blocks.sh

echo Web build complete...
