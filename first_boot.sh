#!/usr/bin/env bash


#####################################################
# Created by cryptopool.builders for crypto use...
#####################################################
# Needs to be ran after the first reboot of the system after permissions are set
#####################################################

source /etc/functions.sh

sleep 5
hide_output yiimp checkup

# Prevents error when trying to log in to admin panel the first time...

sudo touch $STORAGE_ROOT/yiimp/site/log/debug.log
sudo chmod 777 $STORAGE_ROOT/yiimp/site/log/.
sudo chmod 777 $STORAGE_ROOT/yiimp/site/log/debug.log

# Delete me no longer needed after it runs the first time

sudo rm -r $STORAGE_ROOT/yiimp/first_boot.sh
cd $HOME/multipool/yiimp_single
