#!/usr/bin/env bash

#####################################################
# Created by cryptopool.builders for crypto use...
#####################################################

source /etc/functions.sh
source /etc/multipool.conf
source $STORAGE_ROOT/yiimp/.yiimp.conf
source $HOME/multipool/yiimp_single/.wireguard.install.cnf

#Create keys file
echo '<?php
// Sample config file to put in /etc/yiimp/keys.php
define('"'"'YIIMP_MYSQLDUMP_USER'"'"', '"'"''"${YiiMPPanelName}"''"'"');
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
cd $HOME/multipool/yiimp_single
