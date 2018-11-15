#####################################################
# Source https://mailinabox.email/ https://github.com/mail-in-a-box/mailinabox
# Updated by cryptopool.builders for crypto use...
#####################################################

source /etc/functions.sh
source /etc/multipool.conf

show_menu(){
message_box "Ultimate Crypto-Server Setup Installer v1.02" \
"You have choosen to install YiiMP Single Server!
\n\nThis option will install all componets of YiiMP on a single server.
\n\nAfter answering the following questions, setup will be automated.
\n\nNOTE: If installing on a system with less then 8 GB of RAM you may experience system issues!"

if [ -z "$UsingSubDomain" ]; then
DEFAULT_UsingSubDomain=no
input_box "Using Sub-Domain" \
"Are you using a sub-domain for the main website domain? Example pool.example.com?
\n\nPlease answer (y)es or (n)o only:" \
$DEFAULT_UsingSubDomain \
UsingSubDomain

if [ -z "$UsingSubDomain" ]; then
# user hit ESC/cancel
exit
fi
fi

if [ -z "$InstallSSL" ]; then
DEFAULT_InstallSSL=yes
input_box "Install SSL" \
"Would you like the system to install SSL automatically?
\n\nPlease answer (y)es or (n)o only:" \
$DEFAULT_InstallSSL \
InstallSSL

if [ -z "$InstallSSL" ]; then
# user hit ESC/cancel
exit
fi
fi

if [ -z "$DomainName" ]; then
DEFAULT_DomainName=$(get_publicip_from_web_service 4 || get_default_privateip 4)
input_box "Domain Name" \
"Enter your domain name. If using a subdomain enter the full domain as in pool.example.com
\n\nDo not add www. to the domain name.
\n\nDomain Name:" \
$DEFAULT_DomainName \
DomainName

if [ -z "$DomainName" ]; then
# user hit ESC/cancel
exit
fi
fi

if [ -z "$StratumURL" ]; then
DEFAULT_StratumURL=stratum.$DomainName
input_box "Stratum URL" \
"Enter your stratum URL. It is recommended to use another subdomain such as stratum.$DomainName
\n\nDo not add www. to the domain name.
\n\nStratum URL:" \
$DEFAULT_StratumURL \
StratumURL

if [ -z "$StratumURL" ]; then
# user hit ESC/cancel
exit
fi
fi

if [ -z "$SupportEmail" ]; then
DEFAULT_SupportEmail=support@$DomainName
input_box "System Email" \
"Enter an email address for the system to send alerts and other important messages.
\n\nSystem Email:" \
$DEFAULT_SupportEmail \
SupportEmail

if [ -z "$SupportEmail" ]; then
# user hit ESC/cancel
exit
fi
fi

if [ -z "$PublicIP" ]; then
DEFAULT_PublicIP=$(echo $SSH_CLIENT | awk '{ print $1}')
input_box "Your Public IP" \
"Enter your public IP from the remote system you will access your admin panel from.
\n\nWe have guessed your public IP from the IP used to access this system.
\n\nGo to whatsmyip.org if you are unsure this is your public IP.
\n\nYour Public IP:" \
$DEFAULT_PublicIP \
PublicIP

if [ -z "$PublicIP" ]; then
# user hit ESC/cancel
exit
fi
fi

if [ -z "$DBRootPassword" ]; then
DEFAULT_DBRootPassword=$(openssl rand -base64 29 | tr -d "=+/")
input_box "Database Root Password" \
"Enter your desired database root password.
\n\nYou may use the system generated password shown.
\n\nDesired Database Password:" \
$DEFAULT_DBRootPassword \
DBRootPassword

if [ -z "$DBRootPassword" ]; then
# user hit ESC/cancel
exit
fi
fi

if [ -z "$PanelUserDBPassword" ]; then
DEFAULT_PanelUserDBPassword=$(openssl rand -base64 29 | tr -d "=+/")
input_box "Database Panel Password" \
"Enter your desired database panel password.
\n\nYou may use the system generated password shown.
\n\nDesired Database Password:" \
$DEFAULT_PanelUserDBPassword \
PanelUserDBPassword

if [ -z "$PanelUserDBPassword" ]; then
# user hit ESC/cancel
exit
fi
fi

if [ -z "$StratumUserDBPassword" ]; then
DEFAULT_StratumUserDBPassword=$(openssl rand -base64 29 | tr -d "=+/")
input_box "Database Stratum Password" \
"Enter your desired database stratum password.
\n\nYou may use the system generated password shown.
\n\nDesired Database Password:" \
$DEFAULT_StratumUserDBPassword \
StratumUserDBPassword

if [ -z "$StratumUserDBPassword" ]; then
# user hit ESC/cancel
exit
fi
fi

if [ -z "$AdminPanel" ]; then
DEFAULT_AdminPanel=AdminPortal
input_box "Admin Panel Location" \
"Enter your desired location name for admin access..
\n\nOnce set you will access the YiiMP admin at $DomainName/site/AdminPortal
\n\nDesired Admin Panel Location:" \
$DEFAULT_AdminPanel \
AdminPanel

if [ -z "$AdminPanel" ]; then
# user hit ESC/cancel
exit
fi
fi

clear

dialog --title "Verify Your Answers" \
--yesno "Please verify your answer before you continue:

Using Sub-Domain : ${InstallSub}
Install SSL      : ${InstallSSL}
Domain Name      : ${DomainName}
Stratum URL      : ${StratumURL}
System Email     : ${SupportEmail}
Your Public IP   : ${PublicIP}
Admin Location   : ${AdminPanel}" 15 60


# Get exit status
# 0 means user hit [yes] button.
# 1 means user hit [no] button.
# 255 means user hit [Esc] key.
response=$?
case $response in

0)
# Save the global options in $STORAGE_ROOT/yiimp/.yiimp.conf so that standalone
# tools know where to look for data.
echo 'STORAGE_USER='"${STORAGE_USER}"'
STORAGE_ROOT='"${STORAGE_ROOT}"'
DomainName='"${DomainName}"'
StratumURL='"${StratumURL}"'
SupportEmail='"${SupportEmail}"'
PublicIP='"${PublicIP}"'
DBRootPassword='"'"''"${DBRootPassword}"''"'"'
AdminPanel='"${AdminPanel}"'
PanelUserDBPassword='"'"''"${PanelUserDBPassword}"''"'"'
StratumUserDBPassword='"'"''"${StratumUserDBPassword}"''"'"'
UsingSubDomain='"${UsingSubDomain}"'
InstallSSL='"${InstallSSL}"'
# Unless you do some serious modifications this installer will not work with any other repo of yiimp!
YiiMPRepo='https://github.com/cryptopool-builders/yiimp.git'
' | sudo -E tee $STORAGE_ROOT/yiimp/.yiimp.conf >/dev/null 2>&1 ;;

1)

clear;
show_menu;
;;

255)

clear;
show_menu;
;;

}
cd $HOME/multipool/yiimp_single
