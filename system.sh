#####################################################
# Source https://mailinabox.email/ https://github.com/mail-in-a-box/mailinabox
# Updated by cryptopool.builders for crypto use...
#####################################################

clear
source /etc/functions.sh
source $STORAGE_ROOT/yiimp/.yiimp.conf
source $HOME/multipool/yiimp_single/.wireguard.install.cnf
if [[ ("$wireguard" == "true") ]]; then
source $STORAGE_ROOT/yiimp/.wireguard.conf
fi

if [[ ("$UsingDomain" == "yes") ]]; then
	echo ${DomainName} | hide_output sudo tee -a /etc/hostname
	sudo hostname "${DomainName}"
fi

# Set timezone
echo -e " Setting TimeZone to UTC...$COL_RESET"
if [ ! -f /etc/timezone ]; then
echo "Setting timezone to UTC."
echo "Etc/UTC" > sudo /etc/timezone
restart_service rsyslog
fi
echo -e "$GREEN Done...$COL_RESET"

# Add repository
echo -e " Adding the required repsoitories...$COL_RESET"
if [ ! -f /usr/bin/add-apt-repository ]; then
echo "Installing add-apt-repository..."
hide_output sudo apt-get -y update
apt_install software-properties-common
fi
echo -e "$GREEN Done...$COL_RESET"

# PHP 7
echo -e " Installing Ondrej PHP PPA...$COL_RESET"
if [ ! -f /etc/apt/sources.list.d/ondrej-php-bionic.list ]; then
hide_output sudo add-apt-repository -y ppa:ondrej/php
fi
echo -e "$GREEN Done...$COL_RESET"

# CertBot
echo -e " Installing CertBot PPA...$COL_RESET"
hide_output sudo add-apt-repository -y ppa:certbot/certbot
echo -e "$GREEN Done...$COL_RESET"

# MariaDB
echo -e " Installing MariaDB Repository...$COL_RESET"
hide_output sudo apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xF1656F24C74CD1D8
if [[ ("$DISTRO" == "16") ]]; then
sudo add-apt-repository 'deb [arch=amd64,arm64,i386,ppc64el] http://mirror.timeweb.ru/mariadb/repo/10.4/ubuntu xenial main'
else
sudo add-apt-repository 'deb [arch=amd64,arm64,ppc64el] http://mirror.timeweb.ru/mariadb/repo/10.4/ubuntu bionic main'
fi
echo -e "$GREEN Done...$COL_RESET"

# Upgrade System Files
echo -e " Updating system packages...$COL_RESET"
hide_output sudo apt-get update
echo -e "$GREEN Done...$COL_RESET"
echo -e " Upgrading system packages...$COL_RESET"
if [ ! -f /boot/grub/menu.lst ]; then
apt_get_quiet upgrade
else
sudo rm /boot/grub/menu.lst
hide_output sudo update-grub-legacy-ec2 -y
apt_get_quiet upgrade
fi
echo -e "$GREEN Done...$COL_RESET"
echo -e " Running Dist-Upgrade...$COL_RESET"
apt_get_quiet dist-upgrade
echo -e "$GREEN Done...$COL_RESET"
echo -e " Running Autoremove...$COL_RESET"
apt_get_quiet autoremove

echo -e "$GREEN Done...$COL_RESET"
echo -e " Installing Base system packages...$COL_RESET"
apt_install python3 python3-dev python3-pip \
wget curl git sudo coreutils bc \
haveged pollinate unzip \
unattended-upgrades cron ntp fail2ban screen rsyslog

# ### Seed /dev/urandom
echo -e "$GREEN Done...$COL_RESET"
echo -e " Initializing system random number generator...$COL_RESET"
hide_output dd if=/dev/random of=/dev/urandom bs=1 count=32 2> /dev/null
hide_output sudo pollinate -q -r

if [ -z "${DISABLE_FIREWALL:-}" ]; then
	# Install `ufw` which provides a simple firewall configuration.
	apt_install ufw

	# Allow incoming connections to SSH.
	ufw_allow ssh;

	# ssh might be running on an alternate port. Use sshd -T to dump sshd's #NODOC
	# settings, find the port it is supposedly running on, and open that port #NODOC
	# too. #NODOC
	SSH_PORT=$(sshd -T 2>/dev/null | grep "^port " | sed "s/port //") #NODOC
	if [ ! -z "$SSH_PORT" ]; then
	if [ "$SSH_PORT" != "22" ]; then

	echo Opening alternate SSH port $SSH_PORT. #NODOC
	ufw_allow $SSH_PORT #NODOC

	fi
	fi

sudo ufw --force enable;
fi #NODOC

echo -e "$GREEN Done...$COL_RESET"
echo -e " Installing YiiMP Required system packages...$COL_RESET"
if [ -f /usr/sbin/apache2 ]; then
echo Removing apache...
hide_output apt-get -y purge apache2 apache2-*
hide_output apt-get -y --purge autoremove
fi
hide_output sudo apt-get update
if [[ ("$DISTRO" == "16") ]]; then
apt_install php7.3-fpm php7.3-opcache php7.3-fpm php7.3 php7.3-common php7.3-gd \
php7.3-mysql php7.3-imap php7.3-cli php7.3-cgi \
php-pear php-auth-sasl mcrypt imagemagick libruby \
php7.3-curl php7.3-intl php7.3-pspell php7.3-recode php7.3-sqlite3 \
php7.3-tidy php7.3-xmlrpc php7.3-xsl memcached php-memcache \
php-imagick php-gettext php7.3-zip php7.3-mbstring \
fail2ban ntpdate python3 python3-dev python3-pip \
curl git sudo coreutils pollinate unzip unattended-upgrades cron \
nginx pwgen libgmp3-dev libmysqlclient-dev libcurl4-gnutls-dev \
libkrb5-dev libldap2-dev libidn11-dev gnutls-dev librtmp-dev \
build-essential libtool autotools-dev automake pkg-config libevent-dev bsdmainutils libssl-dev \
automake cmake
else
apt_install php7.3-fpm php7.3-opcache php7.3-fpm php7.3 php7.3-common php7.3-gd \
php7.3-mysql php7.3-imap php7.3-cli php7.3-cgi \
php-pear php-auth-sasl mcrypt imagemagick libruby \
php7.3-curl php7.3-intl php7.3-pspell php7.3-recode php7.3-sqlite3 \
php7.3-tidy php7.3-xmlrpc php7.3-xsl memcached php-memcache \
php-imagick php-gettext php7.3-zip php7.3-mbstring \
fail2ban ntpdate python3 python3-dev python3-pip \
curl git sudo coreutils pollinate unzip unattended-upgrades cron \
nginx pwgen libgmp3-dev libmysqlclient-dev libcurl4-gnutls-dev \
libkrb5-dev libldap2-dev libidn11-dev gnutls-dev librtmp-dev \
build-essential libtool autotools-dev automake pkg-config libevent-dev bsdmainutils libssl-dev \
libpsl-dev libnghttp2-dev automake cmake
fi

# ### Suppress Upgrade Prompts
# When Ubuntu 20 comes out, we don't want users to be prompted to upgrade,
# because we don't yet support it.
if [ -f /etc/update-manager/release-upgrades ]; then
	editconf.py /etc/update-manager/release-upgrades Prompt=never
sudo rm -f /var/lib/ubuntu-release-upgrader/release-upgrade-available
fi

echo -e "$GREEN Done...$COL_RESET"
echo -e " Downloading CryptoPool.builders YiiMP Repo...$COL_RESET"
hide_output sudo git clone ${YiiMPRepo} $STORAGE_ROOT/yiimp/yiimp_setup/yiimp
if [[ ("$CoinPort" == "Yes") ]]; then
	cd $STORAGE_ROOT/yiimp/yiimp_setup/yiimp
	sudo git fetch
	sudo git checkout multi-port
fi
echo -e "$GREEN System files installed...$COL_RESET"
cd $HOME/multipool/yiimp_single
