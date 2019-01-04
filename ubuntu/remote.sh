#####################################################
# Created by cryptopool.builders for crypto use...
#####################################################

#!/usr/bin/env bash
# Copy the default algo.conf to the new coin.algo.conf

source /tmp/var_tmp.conf

cd /home/crypto-data/yiimp/site/stratum/config
cp -r $coinalgo.conf $coinsymbollower.$coinalgo.conf

# Insert the port in to the new coin.algo.conf
sed -i '/port/c\port = '${coinport}'' $coinsymbollower.$coinalgo.conf

# Insert the include
sed -i -e '$a\
[WALLETS]\
include = '${coinsymbol}'' $coinsymbollower.$coinalgo.conf

# Insert the exclude
sed -i -e '$a\
[WALLETS]\
exclude = '${coinsymbol}'' $coinalgo.conf

cd /tmp
sudo chmod +x stratum.${coinsymbollower}
cp -r stratum.${coinsymbollower} /home/crypto-data/yiimp/site/stratum/config
sudo cp -r stratum.${coinsymbollower} /usr/bin
sudo ufw allow $coinport
bash stratum.${coinsymbollower} start ${coinsymbollower}

exit 0
