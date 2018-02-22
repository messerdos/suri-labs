#!/bin/bash

#....
# Make sure only root can run our script
if [ "$(id -u)" == "0" ]; then
   echo "This script must be run not as root" 1>&2
   exit 1
fi

vagrant -v > /dev/null 2>&1 || { echo "Vagrant is required but it's not installed. Aborting." >&2; exit 1; }

vagrant plugin list | grep vbguest > /dev/null 2>&1 || { echo "Vagrant vbguest plugin is required but it's not installed. Aborting." >&2; exit 1; }

if [ ! -f ./easy-rsa/easyrsa3/easyrsa ]; then
    echo "easy-rsa not found! Plz run: `git submodule init && git submodule update` to update source modules"
fi

echo "Preparing crypto keys for our project"
echo "We need init pki env and generate server and client certificates and keys"
echo "You should choose new password for ca cert and use it througout the procedure" 
echo "Ready? Hit [Enter]" && read
cd ./easy-rsa/easyrsa3/ && ./easyrsa init-pki &&
./easyrsa build-ca &&
./easyrsa gen-req server nopass && ./easyrsa gen-req client nopass &&
./easyrsa sign-req server server && ./easyrsa sign-req client client &&
./easyrsa gen-dh && 
vagrant up
