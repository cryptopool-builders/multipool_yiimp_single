#####################################################
# Created by cryptopool.builders for crypto use...
#####################################################

source /etc/functions.sh
source $STORAGE_ROOT/yiimp/.yiimp.conf
source $HOME/multipool/yiimp_single/.wireguard.install.cnf
if [[ ("$wireguard" == "true") ]]; then
source $STORAGE_ROOT/yiimp/.wireguard.conf
fi

echo -e " Installing MariaDB...$COL_RESET"
MARIADB_VERSION='10.3'
sudo debconf-set-selections <<< "maria-db-$MARIADB_VERSION mysql-server/root_password password $DBRootPassword"
sudo debconf-set-selections <<< "maria-db-$MARIADB_VERSION mysql-server/root_password_again password $DBRootPassword"
apt_install mariadb-server mariadb-client
echo -e "$GREEN MariaDB build complete...$COL_RESET"
echo -e " Creating DB users for YiiMP...$COL_RESET"

if [[ ("$wireguard" == "false") ]]; then
Q1="CREATE DATABASE IF NOT EXISTS yiimpfrontend;"
Q2="GRANT ALL ON yiimpfrontend.* TO 'panel'@'localhost' IDENTIFIED BY '$PanelUserDBPassword';"
Q3="GRANT ALL ON yiimpfrontend.* TO 'stratum'@'localhost' IDENTIFIED BY '$StratumUserDBPassword';"
Q4="FLUSH PRIVILEGES;"
SQL="${Q1}${Q2}${Q3}${Q4}"
sudo mysql -u root -p"${DBRootPassword}" -e "$SQL"
else
  Q1="CREATE DATABASE IF NOT EXISTS yiimpfrontend;"
  Q2="GRANT ALL ON yiimpfrontend.* TO 'panel'@'${DBInternalIP}' IDENTIFIED BY '$PanelUserDBPassword';"
  Q3="GRANT ALL ON yiimpfrontend.* TO 'stratum'@'${DBInternalIP}' IDENTIFIED BY '$StratumUserDBPassword';"
  Q4="FLUSH PRIVILEGES;"
  SQL="${Q1}${Q2}${Q3}${Q4}"
  sudo mysql -u root -p"${DBRootPassword}" -e "$SQL"
fi
echo -e "$GREEN Database creation complete...$COL_RESET"

echo -e " Creating my.cnf...$COL_RESET"

if [[ ("$wireguard" == "false") ]]; then
echo '[clienthost1]
user=panel
password='"${PanelUserDBPassword}"'
database=yiimpfrontend
host=localhost
[clienthost2]
user=stratum
password='"${StratumUserDBPassword}"'
database=yiimpfrontend
host=localhost
[mysql]
user=root
password='"${DBRootPassword}"'
' | sudo -E tee $STORAGE_ROOT/yiimp/.my.cnf >/dev/null 2>&1
else
echo '[clienthost1]
  user=panel
  password='"${PanelUserDBPassword}"'
  database=yiimpfrontend
  host='"${DBInternalIP}"'
  [clienthost2]
  user=stratum
  password='"${StratumUserDBPassword}"'
  database=yiimpfrontend
  host='"${DBInternalIP}"'
  [mysql]
  user=root
  password='"${DBRootPassword}"'
  ' | sudo -E tee $STORAGE_ROOT/yiimp/.my.cnf >/dev/null 2>&1
fi

sudo chmod 0600 $STORAGE_ROOT/yiimp/.my.cnf
echo -e "$GREEN Passwords can be found in $STORAGE_ROOT/yiimp/.my.cnf$COL_RESET"

echo -e " Importing YiiMP Default database values...$COL_RESET"
cd $STORAGE_ROOT/yiimp/yiimp_setup/yiimp/sql
# import sql dump
sudo zcat 2016-04-03-yaamp.sql.gz | sudo mysql -u root -p"${DBRootPassword}" yiimpfrontend
# oh the humanity!
sudo mysql -u root -p"${DBRootPassword}" yiimpfrontend --force < 2016-04-24-market_history.sql
sudo mysql -u root -p"${DBRootPassword}" yiimpfrontend --force < 2016-04-27-settings.sql
sudo mysql -u root -p"${DBRootPassword}" yiimpfrontend --force < 2016-05-11-coins.sql
sudo mysql -u root -p"${DBRootPassword}" yiimpfrontend --force < 2016-05-15-benchmarks.sql
sudo mysql -u root -p"${DBRootPassword}" yiimpfrontend --force < 2016-05-23-bookmarks.sql
sudo mysql -u root -p"${DBRootPassword}" yiimpfrontend --force < 2016-06-01-notifications.sql
sudo mysql -u root -p"${DBRootPassword}" yiimpfrontend --force < 2016-06-04-bench_chips.sql
sudo mysql -u root -p"${DBRootPassword}" yiimpfrontend --force < 2016-11-23-coins.sql
sudo mysql -u root -p"${DBRootPassword}" yiimpfrontend --force < 2017-02-05-benchmarks.sql
sudo mysql -u root -p"${DBRootPassword}" yiimpfrontend --force < 2017-03-31-earnings_index.sql
sudo mysql -u root -p"${DBRootPassword}" yiimpfrontend --force < 2017-05-accounts_case_swaptime.sql
sudo mysql -u root -p"${DBRootPassword}" yiimpfrontend --force < 2017-06-payouts_coinid_memo.sql
sudo mysql -u root -p"${DBRootPassword}" yiimpfrontend --force < 2017-09-notifications.sql
sudo mysql -u root -p"${DBRootPassword}" yiimpfrontend --force < 2017-10-bookmarks.sql
sudo mysql -u root -p"${DBRootPassword}" yiimpfrontend --force < 2017-11-segwit.sql
sudo mysql -u root -p"${DBRootPassword}" yiimpfrontend --force < 2018-01-stratums_ports.sql
sudo mysql -u root -p"${DBRootPassword}" yiimpfrontend --force < 2018-02-coins_getinfo.sql
sudo mysql -u root -p"${DBRootPassword}" yiimpfrontend --force < 2019-03-coins_thepool_life.sql
echo -e "$GREEN Database import complete...$COL_RESET"

echo -e " Tweaking MariaDB for better performance...$COL_RESET"
if [[ ("$wireguard" == "false") ]]; then
sudo sed -i '/max_connections/c\max_connections         = 800' /etc/mysql/my.cnf
sudo sed -i '/thread_cache_size/c\thread_cache_size       = 512' /etc/mysql/my.cnf
sudo sed -i '/tmp_table_size/c\tmp_table_size          = 128M' /etc/mysql/my.cnf
sudo sed -i '/max_heap_table_size/c\max_heap_table_size     = 128M' /etc/mysql/my.cnf
sudo sed -i '/wait_timeout/c\wait_timeout            = 60' /etc/mysql/my.cnf
sudo sed -i '/max_allowed_packet/c\max_allowed_packet      = 64M' /etc/mysql/my.cnf
else
  sudo sed -i '/max_connections/c\max_connections         = 800' /etc/mysql/my.cnf
  sudo sed -i '/thread_cache_size/c\thread_cache_size       = 512' /etc/mysql/my.cnf
  sudo sed -i '/tmp_table_size/c\tmp_table_size          = 128M' /etc/mysql/my.cnf
  sudo sed -i '/max_heap_table_size/c\max_heap_table_size     = 128M' /etc/mysql/my.cnf
  sudo sed -i '/wait_timeout/c\wait_timeout            = 60' /etc/mysql/my.cnf
  sudo sed -i '/max_allowed_packet/c\max_allowed_packet      = 64M' /etc/mysql/my.cnf
  sudo sed -i 's/#bind-address=0.0.0.0/bind-address='${DBInternalIP}'/g' /etc/mysql/my.cnf
fi
echo -e "$GREEN Database tweak complete...$COL_RESET"
restart_service mysql
echo
echo -e "$GREEN Database build complete...$COL_RESET"
cd $HOME/multipool/yiimp_single
