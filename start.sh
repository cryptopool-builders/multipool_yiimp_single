#!/usr/bin/env bash


#####################################################
# This is the entry point for configuring the system.
# Source https://mailinabox.email/ https://github.com/mail-in-a-box/mailinabox
# Updated by cryptopool.builders for crypto use...
#####################################################

source /etc/functions.sh # load our functions
source /etc/multipool.conf
# Ensure Python reads/writes files in UTF-8. If the machine
# triggers some other locale in Python, like ASCII encoding,
# Python may not be able to read/write files. This is also
# in the management daemon startup script and the cron script.

if ! locale -a | grep en_US.utf8 > /dev/null; then
# Generate locale if not exists
hide_output locale-gen en_US.UTF-8
fi

export LANGUAGE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_TYPE=en_US.UTF-8

# Fix so line drawing characters are shown correctly in Putty on Windows. See #744.
export NCURSES_NO_UTF8_ACS=1

# Create the temporary installation directory if it doesn't already exist.
echo Creating the temporary YiiMP installation folder...
if [ ! -d $STORAGE_ROOT/yiimp/yiimp_setup ]; then
sudo mkdir -p $STORAGE_ROOT/yiimp/yiimp_setup
sudo mkdir -p $STORAGE_ROOT/yiimp/site/web
sudo mkdir -p $STORAGE_ROOT/yiimp/site/stratum
sudo mkdir -p $STORAGE_ROOT/yiimp/site/configuration
sudo mkdir -p $STORAGE_ROOT/yiimp/site/crons
sudo mkdir -p $STORAGE_ROOT/yiimp/site/log
sudo mkdir -p $STORAGE_ROOT/yiimp/starts
sudo mkdir -p $STORAGE_ROOT/wallets
fi

# Start the installation.
source menu.sh
source questions.sh
source system.sh
source db.sh
source web.sh
source nginx_upgrade.sh
source stratum.sh
source daemon.sh
source send_mail.sh
source server_cleanup.sh
source motd.sh
source server_harden.sh
source $STORAGE_ROOT/yiimp/.yiimp.conf

clear
echo Installation of your YiiMP single server is now completed.
echo You *MUST* reboot the machine to finalize the machine updates and folder permissions! YiiMP will not function until a reboot is performed!
echo
echo "Important! After first reboot it may take up to 1 minute for the main|loop2|blocks|debug screens to start!"
echo "After 1 minute, type motd to refresh"
echo You can access your admin panel at, http://${DomainName}/site/${AdminPanel}
echo
echo By default all stratum ports are blocked by the firewall. To allow a port through, from the command prompt type sudo ufw allow port number.
echo Database user names and passwords can be found in $STORAGE_ROOT/yiimp_setup/.my.cnf
