#!/usr/bin/env bash

#####################################################
# Source https://mailinabox.email/ https://github.com/mail-in-a-box/mailinabox
# Updated by cryptopool.builders for crypto use...
#####################################################

source /etc/functions.sh
source /etc/multipool.conf
source $STORAGE_ROOT/yiimp/.yiimp.conf

set -eu -o pipefail

function print_error {
    read line file <<<$(caller)
    echo "An error occurred in line $line of file $file:" >&2
    sed "${line}q;d" "$file" >&2
}
trap print_error ERR

if [[ ("$wireguard" == "true") ]]; then
source $STORAGE_ROOT/yiimp/.wireguard.conf
fi
echo -e " Creating initial SSL certificate...$COL_RESET"


# Install openssl.

apt_install openssl

# Create a directory to store TLS-related things like "SSL" certificates.

sudo mkdir -p $STORAGE_ROOT/ssl

# Since we properly seed /dev/urandom in system.sh we should be fine, but I leave
# in the rest of the notes in case that ever changes.
if [ ! -f $STORAGE_ROOT/ssl/ssl_private_key.pem ]; then
	# Set the umask so the key file is never world-readable.
	(umask 077; hide_output \
		sudo openssl genrsa -out $STORAGE_ROOT/ssl/ssl_private_key.pem 2048)
fi

# Generate a self-signed SSL certificate because things like nginx, dovecot,
# etc. won't even start without some certificate in place, and we need nginx
# so we can offer the user a control panel to install a better certificate.
if [ ! -f $STORAGE_ROOT/ssl/ssl_certificate.pem ]; then
	# Generate a certificate signing request.
	CSR=/tmp/ssl_cert_sign_req-$$.csr
	hide_output \
	sudo openssl req -new -key $STORAGE_ROOT/ssl/ssl_private_key.pem -out $CSR \
	  -sha256 -subj "/CN=$PRIMARY_HOSTNAME"

	# Generate the self-signed certificate.
	CERT=$STORAGE_ROOT/ssl/$PRIMARY_HOSTNAME-selfsigned-$(date --rfc-3339=date | sed s/-//g).pem
	hide_output \
	sudo openssl x509 -req -days 365 \
	  -in $CSR -signkey $STORAGE_ROOT/ssl/ssl_private_key.pem -out $CERT

	# Delete the certificate signing request because it has no other purpose.
sudo rm -f $CSR

	# Symlink the certificate into the system certificate path, so system services
	# can find it.
sudo ln -s $CERT $STORAGE_ROOT/ssl/ssl_certificate.pem
fi

# Generate some Diffie-Hellman cipher bits.
# openssl's default bit length for this is 1024 bits, but we'll create
# 2048 bits of bits per the latest recommendations.
if [ ! -f /etc/nginx/dhparam.pem ]; then
  hide_output \
sudo openssl dhparam -out /etc/nginx/dhparam.pem 2048
fi

echo -e "$GREEN Initial Self Signed SSL Generation complete...$COL_RESET"
set +eu +o pipefail
cd $HOME/multipool/yiimp_single
