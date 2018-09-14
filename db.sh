source /etc/functions.sh
source $STORAGE_ROOT/yiimp/.yiimp.conf

echo Installing MariaDB...
MARIADB_VERSION='10.3'
sudo debconf-set-selections <<< "maria-db-$MARIADB_VERSION mysql-server/root_password password $DBRootPassword"
sudo debconf-set-selections <<< "maria-db-$MARIADB_VERSION mysql-server/root_password_again password $DBRootPassword"
apt_install mariadb-server mariadb-client

echo Creating DB users for YiiMP...
Q1="CREATE DATABASE IF NOT EXISTS yiimpfrontend;"
Q2="GRANT ALL ON *.* TO 'panel'@'$localhost' IDENTIFIED BY '$PanelUserDBPassword';"
Q3="GRANT ALL ON *.* TO 'stratum'@'localhost' IDENTIFIED BY '$StratumUserDBPassword';"
Q4="FLUSH PRIVILEGES;"
SQL="${Q1}${Q2}${Q3}${Q4}"
sudo mysql -u root -p"${DBRootPassword}" -e "$SQL"

echo Creating my.cnf...
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

sudo chmod 0600 $STORAGE_ROOT/yiimp/.my.cnf
echo Passwords can be found in $STORAGE_ROOT/yiimp/.my.cnf

echo Importing YiiMP Default database values...
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

echo Database build complete...
cd $HOME/multipool/yiimp_single
