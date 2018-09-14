#!/bin/bash
source /etc/functions.sh
# Needed to be ran after the first reboot of the system after permissions are set
#####################################################

sleep 5
hide_output yiimp checkup
hide_output yiimp coin MDT delete
hide_output yiimp coin FLAX delete
hide_output yiimp coin CHC delete
hide_output yiimp coin DRP delete
hide_output yiimp coin VTC delete
hide_output yiimp coin FTC delete
hide_output yiimp coin UFO delete
hide_output yiimp coin PXC delete
hide_output yiimp coin HAL delete
hide_output yiimp coin XAI delete
hide_output yiimp coin QRK delete
hide_output yiimp coin MUE delete
hide_output yiimp coin BOD delete
hide_output yiimp coin SRC delete
hide_output yiimp coin BTQ delete
hide_output yiimp coin GEO delete
hide_output yiimp coin DGB delete
hide_output yiimp coin CYP delete
hide_output yiimp coin IDC delete
hide_output yiimp coin NEOS delete
hide_output yiimp coin MYR delete
hide_output yiimp coin XDC delete
hide_output yiimp coin SKC delete
hide_output yiimp coin LOG delete
hide_output yiimp coin ILM delete
hide_output yiimp coin START delete
hide_output yiimp coin URO delete
hide_output yiimp coin DASH delete
hide_output yiimp coin BSC delete
hide_output yiimp coin HEDG delete
hide_output yiimp coin AMBER delete
hide_output yiimp coin HTML5 delete
hide_output yiimp coin ZRC delete
sudo touch $STORAGE_ROOT/yiimp/site/log/debug.log
sudo chmod 777 $STORAGE_ROOT/yiimp/site/log/.
sudo chmod 777 $STORAGE_ROOT/yiimp/site/log/debug.log
# Delete me
sudo rm -r $STORAGE_ROOT/yiimp/first_boot.sh
