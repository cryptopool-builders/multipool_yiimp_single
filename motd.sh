#####################################################
# Created by cryptopool.builders for crypto use...
#####################################################

source /etc/functions.sh # load our functions
source /etc/multipool.conf

apt_install lsb-release figlet update-motd \
landscape-common update-notifier-common
cd $HOME/multipool/yiimp_single/ubuntu/etc/update-motd.d
sudo rm -r /etc/update-motd.d/
sudo mkdir /etc/update-motd.d/
sudo touch /etc/update-motd.d/00-header ; sudo touch /etc/update-motd.d/10-sysinfo ; sudo touch /etc/update-motd.d/90-footer
sudo chmod +x /etc/update-motd.d/*
sudo cp -r 00-header 10-sysinfo 90-footer /etc/update-motd.d/
cd $HOME/multipool/yiimp_single/ubuntu
sudo cp -r screens /usr/bin/
sudo chmod +x /usr/bin/screens
echo '
clear
run-parts /etc/update-motd.d/ | sudo tee /etc/motd
' | sudo -E tee /usr/bin/motd >/dev/null 2>&1

sudo chmod +x /usr/bin/motd
cd $HOME/multipool/yiimp_single
