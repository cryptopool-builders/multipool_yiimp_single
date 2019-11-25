#!/usr/bin/env bash


#####################################################
# This is the entry point for configuring the system.
# Source https://mailinabox.email/ https://github.com/mail-in-a-box/mailinabox
# Updated by cryptopool.builders for crypto use...
#####################################################

source /etc/functions.sh
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
echo -e " Creating the temporary YiiMP installation folder...$COL_RESET"
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
echo -e "$GREEN Folders created...$COL_RESET"
# Start the installation.
source menu.sh
source questions.sh
source $HOME/multipool/yiimp_single/.wireguard.install.cnf
if [[ ("$wireguard" == "true") ]]; then
  source wireguard.sh
fi
source system.sh
source self_ssl.sh
source db.sh
source nginx_upgrade.sh
source web.sh
source stratum.sh
source daemon.sh
if [[ ("$UsingDomain" == "Yes") ]]; then
source send_mail.sh
fi
source server_cleanup.sh
source motd.sh
source server_harden.sh
source $STORAGE_ROOT/yiimp/.yiimp.conf

clear

if [[ ("$UsingDomain" == "Yes") ]]; then
  echo -e "Installation of your YiiMP single server is now completed."
  echo -e "You $RED*MUST REBOOT*$COL_RESET the machine to finalize the machine updates and folder permissions! $MAGENTA YiiMP will not function until a reboot is performed!$COL_RESET"
  echo
  echo -e "$YELLOW Important!$COL_RESET After first reboot it may take up to 1 minute for the main|loop2|blocks|debug screens to start!"
  echo -e "If they show$RED stopped$COL_RESET, after 1 minute, type$GREEN motd$COL_RESET to refresh the screen."
  echo
  echo -e "You can access your admin panel at,$BLUE http://${DomainName}/site/${AdminPanel} $COL_RESET"
  echo
  echo -e "$RED By default all stratum ports are blocked by the firewall.$COL_RESET To allow a port through, from the command prompt type $GREEN sudo ufw allow port number.$COL_RESET"
  echo "Database user names and passwords can be found in $STORAGE_ROOT/yiimp_setup/.my.cnf"
else
  echo -e "Installation of your YiiMP single server is now completed."
  echo -e "You $RED*MUST REBOOT*$COL_RESET the machine to finalize the machine updates and folder permissions! $MAGENTA YiiMP will not function until a reboot is performed!$COL_RESET"
  echo
  echo -e "$YELLOW Important!$COL_RESET After first reboot it may take up to 1 minute for the main|loop2|blocks|debug screens to start!"
  echo -e "If they show$RED stopped$COL_RESET, after 1 minute, type$GREEN motd$COL_RESET to refresh the screen."
  echo
  echo -e "You can access your admin panel at,$BLUE http://${DomainName}/site/${AdminPanel} $COL_RESET"
  echo -e "You will be alerted that the website has an invalid certificate."
  echo
  echo -e "$RED By default all stratum ports are blocked by the firewall.$COL_RESET To allow a port through, from the command prompt type $GREEN sudo ufw allow port number.$COL_RESET"
  echo "Database user names and passwords can be found in $STORAGE_ROOT/yiimp_setup/.my.cnf"
fi
exit 0
