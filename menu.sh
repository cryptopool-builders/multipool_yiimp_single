#####################################################
# Source code https://github.com/end222/pacmenu
# Updated by cryptopool.builders for crypto use...
#####################################################

source /etc/functions.sh

RESULT=$(dialog --stdout --title "Ultimate Crypto-Server Setup Installer v1.26" --menu "Choose one" -1 60 5 \
1 "YiiMP - Single Server" \
2 "YiiMP - Single Server with WireGuard" \
3 "YiiMP - Add Stratum Server" \
4 "YiiMP - Add Daemon Server" \
5 Exit)
if [ $RESULT = ]
then
exit ;
fi


if [ $RESULT = 1 ]
then
clear;
echo '
wireguard=false
' | sudo -E tee $HOME/multipool/daemon_builder/.wireguard.install.cnf >/dev/null 2>&1;
fi

if [ $RESULT = 2 ]
then
clear;
echo '
wireguard=true
' | sudo -E tee $HOME/multipool/daemon_builder/.wireguard.install.cnf >/dev/null 2>&1;
echo 'server_type='db'
DBInternalIP='10.0.0.2'
' | sudo -E tee $STORAGE_ROOT/yiimp/.wireguard.conf >/dev/null 2>&1;
fi

if [ $RESULT = 5 ]
then
clear;
exit;
fi
