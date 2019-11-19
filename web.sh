#!/usr/bin/env bash

#####################################################
# Source https://mailinabox.email/ https://github.com/mail-in-a-box/mailinabox
# Updated by cryptopool.builders for crypto use...
#####################################################

source /etc/functions.sh
source /etc/multipool.conf
source $STORAGE_ROOT/yiimp/.yiimp.conf
source $HOME/multipool/yiimp_single/.wireguard.install.cnf
if [[ ("$wireguard" == "true") ]]; then
source $STORAGE_ROOT/yiimp/.wireguard.conf
fi

echo -e " Building web file structure and copying files...$COL_RESET"
cd $STORAGE_ROOT/yiimp/yiimp_setup/yiimp
sudo sed -i 's/AdminRights/'${AdminPanel}'/' $STORAGE_ROOT/yiimp/yiimp_setup/yiimp/web/yaamp/modules/site/SiteController.php
sudo cp -r $STORAGE_ROOT/yiimp/yiimp_setup/yiimp/web $STORAGE_ROOT/yiimp/site/
cd $STORAGE_ROOT/yiimp/yiimp_setup/
sudo cp -r $STORAGE_ROOT/yiimp/yiimp_setup/yiimp/bin/. /bin/
sudo mkdir -p /var/www/${DomainName}/html
sudo mkdir -p /etc/yiimp
sudo mkdir -p $STORAGE_ROOT/yiimp/site/backup/
sudo sed -i "s|ROOTDIR=/data/yiimp|ROOTDIR=${STORAGE_ROOT}/yiimp/site|g" /bin/yiimp

echo -e " Creating NGINX config file...$COL_RESET"
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
source nginx_subdomain_nonssl.sh
if [[ ("$InstallSSL" == "y" || "$InstallSSL" == "Y" || "$InstallSSL" == "yes" || "$InstallSSL" == "Yes" || "$InstallSSL" == "YES") ]]; then
source nginx_subdomain_ssl.sh
else
source nginx_domain_nonssl.sh
if [[ ("$InstallSSL" == "y" || "$InstallSSL" == "Y" || "$InstallSSL" == "yes" || "$InstallSSL" == "Yes" || "$InstallSSL" == "YES") ]]; then
source nginx_domain_ssl.sh
fi
echo -e " Creating YiiMP configuration files...$COL_RESET"

#Create keys file
echo '<?php
// Sample config file to put in /etc/yiimp/keys.php
define('"'"'YIIMP_MYSQLDUMP_USER'"'"', '"'"'panel'"'"');
define('"'"'YIIMP_MYSQLDUMP_PASS'"'"', '"'"''"${PanelUserDBPassword}"''"'"');
define('"'"'YIIMP_MYSQLDUMP_PATH'"'"', '"'"''"${STORAGE_ROOT}/yiimp/site/backup"''"'"');
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

echo -e " Setting correct folder permissions...$COL_RESET"
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
echo -e " Adding the cryptopool.builders flare to YiiMP...$COL_RESET"

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

if [[ ("$wireguard" == "true") ]]; then
sudo sed -i '/# onlynet=ipv4/i\        echo "rpcallowip='${DBInternalIP}'\\n";' $STORAGE_ROOT/yiimp/site/web/yaamp/modules/site/coin_form.php
sudo sed -i "s|blocknotify=blocknotify 127.0.0.1|blocknotify=blocknotify ${DBInternalIP}|g" $STORAGE_ROOT/yiimp/site/web/yaamp/modules/site/coin_form.php
fi
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

echo -e "$GREEN Web build complete...$COL_RESET"
cd $HOME/multipool/yiimp_single
