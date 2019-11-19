#####################################################
# Source https://mailinabox.email/ https://github.com/mail-in-a-box/mailinabox
# Updated by cryptopool.builders for crypto use...
#####################################################

source /etc/functions.sh
source /etc/multipool.conf
source $HOME/multipool/yiimp_single/.wireguard.install.cnf
if [[ ("$wireguard" == "true") ]]; then
source $STORAGE_ROOT/yiimp/.wireguard.conf
fi

if [[ ("$wireguard" == "true") ]]; then
message_box "Ultimate Crypto-Server Setup Installer" \
"You have choosen to install YiiMP Single Server with WireGuard!
\n\nThis option will install all componets of YiiMP on a single server along with WireGuard so you can easily add additional servers in the future.
\n\nPlease make sure any domain name or sub domain names are pointed to this servers IP prior to running this installer.
\n\nAfter answering the following questions, setup will be automated.
\n\nNOTE: If installing on a system with less then 8 GB of RAM you may experience system issues!"
else
message_box "Ultimate Crypto-Server Setup Installer" \
"You have choosen to install YiiMP Single Server!
\n\nThis option will install all componets of YiiMP on a single server.
\n\nPlease make sure any domain name or sub domain names are pointed to this servers IP prior to running this installer.
\n\nAfter answering the following questions, setup will be automated.
\n\nNOTE: If installing on a system with less then 8 GB of RAM you may experience system issues!"
fi


# Begin user inputted responses for auto install


dialog --title "Using Domain Name" \
--yesno "Are you using a domain name? Example: example.com?
Make sure the DNS is updated!" 7 60
response=$?
case $response in
   0) UsingDomain=yes;;
   1) UsingDomain=no;;
   255) echo "[ESC] key pressed.";;
esac

if [[ ("$UsingDomain" == "yes") ]]; then

dialog --title "Using Sub-Domain" \
--yesno "Are you using a sub-domain for the main website domain? Example pool.example.com?
Make sure the DNS is updated!" 7 60
response=$?
case $response in
   0) UsingSubDomain=yes;;
   1) UsingSubDomain=no;;
   255) echo "[ESC] key pressed.";;
esac

if [ -z "${DomainName:-}" ]; then
DEFAULT_DomainName=example.com
input_box "Domain Name" \
"Enter your domain name. If using a subdomain enter the full domain as in pool.example.com
\n\nDo not add www. to the domain name.
\n\nMake sure the domain is pointed to this server before continuing!
\n\nDomain Name:" \
${DEFAULT_DomainName} \
DomainName

if [ -z "${DomainName}" ]; then
# user hit ESC/cancel
exit
fi
fi

if [ -z "${StratumURL:-}" ]; then
DEFAULT_StratumURL=stratum.${DomainName}
input_box "Stratum URL" \
"Enter your stratum URL. It is recommended to use another subdomain such as stratum.${DomainName}
\n\nDo not add www. to the domain name.
\n\nStratum URL:" \
${DEFAULT_StratumURL} \
StratumURL

if [ -z "${StratumURL}" ]; then
# user hit ESC/cancel
exit
fi
fi

dialog --title "Install SSL" \
--yesno "Would you like the system to install SSL automatically?" 7 60
response=$?
case $response in
   0) InstallSSL=yes;;
   1) InstallSSL=no;;
   255) echo "[ESC] key pressed.";;
esac
else

# If user is not using a domain and is just using the server IP these fileds can be automatically detected.

# Sets server IP automatically
DomainName=$(get_publicip_from_web_service 4 || get_default_privateip 4)
StratumURL=$(get_publicip_from_web_service 4 || get_default_privateip 4)
UsingSubDomain=no
InstallSSL=no
fi

# Back to user input questions regardless of domain name or IP use
if [ -z "${SupportEmail:-}" ]; then
DEFAULT_SupportEmail=root@localhost
input_box "System Email" \
"Enter an email address for the system to send alerts and other important messages.
\n\nSystem Email:" \
${DEFAULT_SupportEmail} \
SupportEmail

if [ -z "${SupportEmail}" ]; then
# user hit ESC/cancel
exit
fi
fi

if [ -z "${AdminPanel:-}" ]; then
DEFAULT_AdminPanel=AdminPortal
input_box "Admin Panel Location" \
"Enter your desired location name for admin access..
\n\nOnce set you will access the YiiMP admin at ${DomainName}/site/AdminPortal
\n\nDesired Admin Panel Location:" \
${DEFAULT_AdminPanel} \
AdminPanel

if [ -z "${AdminPanel}" ]; then
# user hit ESC/cancel
exit
fi
fi

dialog --title "Use AutoExchange" \
--yesno "Would you like the stratum to be built with autoexchange enabled?" 7 60
response=$?
case $response in
   0) AutoExchange=yes;;
   1) AutoExchange=no;;
   255) echo "[ESC] key pressed.";;
esac

dialog --title "Use Dedicated Coin Ports" \
--yesno "Would you like YiiMP to be built with dedicated coin ports?" 7 60
response=$?
case $response in
   0) CoinPort=yes;;
   1) CoinPort=no;;
   255) echo "[ESC] key pressed.";;
esac

if [ -z "${PublicIP:-}" ]; then
  if pstree -p | egrep --quiet --extended-regexp ".*sshd.*\($$\)"; then
    DEFAULT_PublicIP=$(echo $SSH_CLIENT | awk '{ print $1}')
    else
    DEFAULT_PublicIP=192.168.0.1
fi
input_box "Your Public IP" \
"Enter your public IP from the remote system you will access your admin panel from.
\n\nWe have guessed your public IP from the IP used to access this system.
\n\nGo to whatsmyip.org if you are unsure this is your public IP.
\n\nYour Public IP:" \
${DEFAULT_PublicIP} \
PublicIP

if [ -z "${PublicIP}" ]; then
# user hit ESC/cancel
exit
fi
fi

# These are all autgenerated but give user the oppertunity to set
if [ -z "${DBRootPassword:-}" ]; then
DEFAULT_DBRootPassword=$(openssl rand -base64 29 | tr -d "=+/")
input_box "Database Root Password" \
"Enter your desired database root password.
\n\nYou may use the system generated password shown.
\n\nDesired Database Password:" \
${DEFAULT_DBRootPassword} \
DBRootPassword

if [ -z "${DBRootPassword}" ]; then
# user hit ESC/cancel
exit
fi
fi

if [ -z "${PanelUserDBPassword:-}" ]; then
DEFAULT_PanelUserDBPassword=$(openssl rand -base64 29 | tr -d "=+/")
input_box "Database Panel Password" \
"Enter your desired database panel password.
\n\nYou may use the system generated password shown.
\n\nDesired Database Password:" \
${DEFAULT_PanelUserDBPassword} \
PanelUserDBPassword

if [ -z "${PanelUserDBPassword}" ]; then
# user hit ESC/cancel
exit
fi
fi

if [ -z "${StratumUserDBPassword:-}" ]; then
DEFAULT_StratumUserDBPassword=$(openssl rand -base64 29 | tr -d "=+/")
input_box "Database Stratum Password" \
"Enter your desired database stratum password.
\n\nYou may use the system generated password shown.
\n\nDesired Database Password:" \
${DEFAULT_StratumUserDBPassword} \
StratumUserDBPassword

if [ -z "${StratumUserDBPassword}" ]; then
# user hit ESC/cancel
exit
fi
fi

clear


dialog --title "Verify Your Responses" \
--yesno "Please verify your answers to continue setup:

Dedicated Coin Ports : ${CoinPort}
AutoExchange : ${AutoExchange}
Using Domain : ${UsingDomain}
Using Sub-Domain : ${UsingSubDomain}
Install SSL      : ${InstallSSL}
Domain Name      : ${DomainName}
Stratum URL      : ${StratumURL}
System Email     : ${SupportEmail}
Your Public IP   : ${PublicIP}
Admin Location   : ${AdminPanel}" 16 60


# Get exit status
# 0 means user hit [yes] button.
# 1 means user hit [no] button.
# 255 means user hit [Esc] key.
response=$?
case $response in

0)
# Save the global options in $STORAGE_ROOT/yiimp/.yiimp.conf so that standalone
# tools know where to look for data.
if [[ ("$wireguard" == "true") ]]; then
echo 'STORAGE_USER='"${STORAGE_USER}"'
UsingDomain='"${UsingDomain}"'
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
CoinPort='"${CoinPort}"'
AutoExchange='"${AutoExchange}"'
DBInternalIP='"${DBInternalIP}"'
# Unless you do some serious modifications this installer will not work with any other repo of yiimp!
YiiMPRepo='https://github.com/cryptopool-builders/yiimp.git'
' | sudo -E tee $STORAGE_ROOT/yiimp/.yiimp.conf >/dev/null 2>&1
else
echo 'STORAGE_USER='"${STORAGE_USER}"'
STORAGE_ROOT='"${STORAGE_ROOT}"'
UsingDomain='"${UsingDomain}"'
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
CoinPort='"${CoinPort}"'
AutoExchange='"${AutoExchange}"'
# Unless you do some serious modifications this installer will not work with any other repo of yiimp!
YiiMPRepo='https://github.com/cryptopool-builders/yiimp.git'
' | sudo -E tee $STORAGE_ROOT/yiimp/.yiimp.conf >/dev/null 2>&1
fi;;
1)

clear
bash $(basename $0) && exit;;

255)
clear
echo "User canceled installation"
exit 0
;;
esac


cd $HOME/multipool/yiimp_single
