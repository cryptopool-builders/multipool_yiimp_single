#####################################################
# Created by cryptopool.builders for crypto use...
#####################################################

source /etc/functions.sh
source $STORAGE_ROOT/yiimp/.yiimp.conf
cd $HOME/multipool/yiimp_single

# NGINX upgrade
echo -e " Upgrading NGINX...$COL_RESET"
hide_output sudo wget https://nginx.org/keys/nginx_signing.key
hide_output sudo apt-key add nginx_signing.key
sudo rm -r nginx_signing.key
echo 'deb https://nginx.org/packages/mainline/ubuntu/ xenial nginx
deb-src https://nginx.org/packages/mainline/ubuntu/ xenial nginx
' | sudo -E tee /etc/apt/sources.list.d/nginx.list >/dev/null 2>&1

hide_output sudo apt-get update
apt_install nginx

sudo mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.old
sudo cp -r nginx_confs/nginx.conf /etc/nginx/

sudo rm -r /etc/nginx/conf.d/default.conf
sudo rm -r /etc/nginx/sites-available/default
sudo rm -r /etc/nginx/sites-enabled/default
echo -e "$GREEN NGINX upgrade complete...$COL_RESET"
restart_service nginx
restart_service php7.3-fpm
cd $HOME/multipool/yiimp_single
