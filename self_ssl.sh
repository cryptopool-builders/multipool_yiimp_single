#####################################################
# Modified by cryptopool.builders for crypto use...
# Source https://gist.github.com/adamrunner/285746ca0f22b0f2e10192427e0b703c
#####################################################

source /etc/functions.sh
source $STORAGE_ROOT/yiimp/.yiimp.conf
cd $HOME/multipool/yiimp_single

# Installs self signed SSL
echo -e " Installing Self Signed SSL...$COL_RESET"
# Make DIR
sudo mkdir /etc/ssl/private
sudo chmod 700 /etc/ssl/private
cd /etc/ssl/private
# Set external server IP
IP=$(get_publicip_from_web_service 4 || get_default_privateip 4)
DOMAIN=nginx-selfsigned
# Generate a passphrase
export PASSPHRASE=$(head -c 500 /dev/urandom | tr -dc a-z0-9A-Z | head -c 128; echo)
# Certificate details
subj="
C=US
ST=NC
O=cryptopool.builders
localityName=cryptopool.builders
commonName=$IP
organizationalUnitName=cryptopool.builders
emailAddress=admin@example.com
"
# Generate the server private key
hide_output sudo openssl genrsa -des3 -out $DOMAIN.key -passout env:PASSPHRASE 2048
# Generate the CSR
hide_output sudo openssl req \
    -new \
    -batch \
    -subj "$(echo -n "$subj" | tr "\n" "/")" \
    -key $DOMAIN.key \
    -out $DOMAIN.csr \
    -passin env:PASSPHRASE

sudo cp $DOMAIN.key $DOMAIN.key.org
# Strip the password so we don't have to type it every time we restart Apache
hide_output sudo openssl rsa -in $DOMAIN.key.org -out $DOMAIN.key -passin env:PASSPHRASE
# Generate the cert (good for 10 years)
hide_output sudo openssl x509 -req -days 3650 -in $DOMAIN.csr -signkey $DOMAIN.key -out $DOMAIN.crt
hide_output sudo openssl dhparam -out /etc/ssl/certs/dhparam.pem 2048

echo -e "$GREEN Self Signed SSL Generation complete...$COL_RESET"
cd $HOME/multipool/yiimp_single
