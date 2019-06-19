#####################################################
# Created by cryptopool.builders for crypto use...
#####################################################

source /etc/functions.sh
source /etc/multipool.conf
source $STORAGE_ROOT/yiimp/.yiimp.conf

echo -e "$YELLOW Installing mail system $COL_RESET"

echo ${DomainName} | hide_output sudo tee -a /etc/hostname
sudo hostname "${DomainName}"

sudo debconf-set-selections <<< "postfix postfix/mailname string ${host_name}"
sudo debconf-set-selections <<< "postfix postfix/main_mailer_type string 'Internet Site'"
apt_install mailutils

sudo sed -i 's/inet_interfaces = all/inet_interfaces = loopback-only/g' /etc/postfix/main.cf
sudo sed -i 's/mydestination/# mydestination/g' /etc/postfix/main.cf
sudo sed -i '/#mydestination/i mydestination = $myhostname, localhost.$mydomain, $mydomain' /etc/postfix/main.cf

sudo systemctl restart postfix
whoami=`whoami`

sudo sed -i '/postmaster:    root/a root:          '${SupportEmail}'' /etc/aliases
sudo sed -i '/root:/a '$whoami':     '${SupportEmail}'' /etc/aliases
sudo newaliases

sudo adduser $whoami mail
echo -e "$GREEN Mail system complete...$COL_RESET"
cd $HOME/multipool/yiimp_single
