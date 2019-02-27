#####################################################
# Source code https://github.com/end222/pacmenu
# Updated by cryptopool.builders for crypto use...
#####################################################

source /etc/functions.sh
cd $HOME/multipool/yiimp_multi

RESULT=$(dialog --stdout --title "Ultimate Crypto-Server Setup Installer" --menu "Choose one" -1 60 6 \
1 "Install Wireguard on DB Server or DB-Stratum Server" \
2 "Install Wireguard on Web Server" \
3 "Install Wireguard on First Stratum Server Only" \
4 "Install Wireguard on Daemon Server" \
5 "Install Wireguard on Additional Server(s)" \
6 Exit)
if [ $RESULT = ]
then
exit ;
fi

if [ $RESULT = 1 ]
then
clear;
echo 'server_type='db'
DBInternalIP='10.0.0.2'
' | sudo -E tee $STORAGE_ROOT/yiimp/.wireguard.conf >/dev/null 2>&1;
cd $HOME/multipool/yiimp_multi
source wireguard.sh;
exit ;
fi

if [ $RESULT = 2 ]
then
clear;
read -e -p "Please enter the DB servers PUBLIC IP : " DBServerIP;
read -e -p "Please enter the DB public key that was displayed : " DBPublicKey;
echo 'server_type='web'
WebInternalIP='10.0.0.3'
DBInternalIP='10.0.0.2'
DBServerIP='"${DBServerIP}"'
DBPublicKey='"${DBPublicKey}"'
' | sudo -E tee $STORAGE_ROOT/yiimp/.wireguard.conf >/dev/null 2>&1;
cd $HOME/multipool/yiimp_multi
source wireguard.sh;
exit ;
fi

if [ $RESULT = 3 ]
then
clear;
read -e -p "Please enter the DB servers PUBLIC IP : " DBServerIP;
read -e -p "Please enter the DB public key that was displayed : " DBPublicKey;
echo 'server_type='stratum'
StratumInternalIP='10.0.0.4'
DBInternalIP='10.0.0.2'
DBServerIP='"${DBServerIP}"'
DBPublicKey='"${DBPublicKey}"'
' | sudo -E tee $STORAGE_ROOT/yiimp/.wireguard.conf >/dev/null 2>&1;
cd $HOME/multipool/yiimp_multi
source wireguard.sh;
exit ;
fi

if [ $RESULT = 4 ]
then
clear;
read -e -p "Please enter the DB servers PUBLIC IP : " DBServerIP;
read -e -p "Please enter the DB public key that was displayed : " DBPublicKey;
echo 'server_type='daemon'
DaemonInternalIP='10.0.0.5'
DBInternalIP='10.0.0.2'
DBServerIP='"${DBServerIP}"'
DBPublicKey='"${DBPublicKey}"'
' | sudo -E tee $STORAGE_ROOT/yiimp/.wireguard.conf >/dev/null 2>&1;
cd $HOME/multipool/yiimp_multi
source wireguard.sh;
exit ;
fi

if [ $RESULT = 5 ]
then
clear;
source wire_warning.sh

if [ -z "$AdditionalInternalIP" ]; then
DEFAULT_AdditionalInternalIP='10.0.0.x'
input_box "Additional Server Private IP" \
"Enter the new Private IP of this server.
\n\nMake sure not to reuse an IP already in use!
\n\nPrivate IP address:" \
$DEFAULT_AdditionalInternalIP \
AdditionalInternalIP

if [ -z "$AdditionalInternalIP" ]; then
user hit ESC/cancel
exit
fi
fi

if [ -z "$DBServerIP" ]; then
DEFAULT_DBServerIP='x.x.x.x'
input_box "DB Server Public IP" \
"Enter the Public IP of your DB Server.
\n\nDB Public IP address:" \
$DEFAULT_DBServerIP \
DBServerIP

if [ -z "$DBServerIP" ]; then
user hit ESC/cancel
exit
fi
fi

if [ -z "$DBPublicKey" ]; then
DEFAULT_DBPublicKey='PublicKey'
input_box "DB Server Public Key" \
"Enter the Public Key of your DB Server.
\n\nDB Public Key:" \
$DEFAULT_DBPublicKey \
DBPublicKey

if [ -z "$DBPublicKey" ]; then
user hit ESC/cancel
exit
fi
fi

echo 'server_type='additional'
AdditionalInternalIP='"${AdditionalInternalIP}"'
DBInternalIP='10.0.0.2'
DBServerIP='"${DBServerIP}"'
DBPublicKey='"${DBPublicKey}"'
' | sudo -E tee $STORAGE_ROOT/yiimp/.wireguard.conf >/dev/null 2>&1;
cd $HOME/multipool/yiimp_multi
source wireguard.sh;
exit ;
fi

if [ $RESULT = 6 ]
then
clear;
exit;
fi
cd $HOME/multipool/yiimp_multi
