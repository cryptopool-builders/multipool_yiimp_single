#####################################################
# Created by cryptopool.builders for crypto use...
#####################################################

source $HOME/multipool/yiimp_single/.wireguard.install.cnf
source $STORAGE_ROOT/yiimp/.wireguard.conf
source /etc/multipool.conf

sudo add-apt-repository ppa:wireguard/wireguard -y
sudo apt-get update -y
sudo apt-get install wireguard-dkms wireguard-tools -y
(umask 077 && printf "[Interface]\nPrivateKey = " | sudo tee /etc/wireguard/wg0.conf > /dev/null)
wg genkey | sudo tee -a /etc/wireguard/wg0.conf | wg pubkey | sudo tee /etc/wireguard/publickey

# Install WireGuard on main server.
echo "ListenPort = 6121" | hide_output sudo tee -a /etc/wireguard/wg0.conf
echo "SaveConfig = true" | hide_output sudo tee -a /etc/wireguard/wg0.conf
echo "Address = ${DBInternalIP}/24" | hide_output sudo tee -a /etc/wireguard/wg0.conf
cd $HOME
sudo systemctl start wg-quick@wg0
sudo systemctl enable wg-quick@wg0
sudo ufw allow 6121
clear
dbpublic=${PUBLIC_IP}
mypublic="$(sudo cat /etc/wireguard/publickey)"

echo '  Public Ip: '"${dbpublic}"'
Public Key: '"${mypublic}"'
' | sudo -E tee $STORAGE_ROOT/yiimp/.wireguard_public.conf >/dev/null 2>&1;
