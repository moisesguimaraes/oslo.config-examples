#!/bin/bash

set -eu

SUBJ_PREFIX="/C=CZ/ST=Jihomoravsky kraj/L=Brno/O=OpenStack Common Libraries/OU=Engineering"
CA_KEY_SIZE=4096
KEY_SIZE=2048

# clean up
rm -rf serial index.txt certs crl csr intermediate_cas newcerts private

function gen_ca() {
    touch index.txt
    echo 1000 > serial

    for d in certs crl csr newcerts private
    do [ ! -d $d ] && mkdir $d
    done
    chmod 700 private
}

function gen_key() {
    file_name=private/$1.key.pem

    if [ -f $file_name ]; then
        rm -f $file_name
    fi

    openssl genrsa -out $file_name $2
    chmod 400 $file_name
}

function gen_csr() {
    openssl req -new \
                -subj "$SUBJ_PREFIX/CN=$1" \
                -key private/$2.key.pem \
                -out csr/$2.csr.pem \
                -config $3
}

function gen_cert() {
    openssl ca -batch \
               -in $1/csr/$2.csr.pem \
               -out $1/certs/$2.cert.pem \
               -config $3 -extensions $4 -days $5
    chmod 444 $1/certs/$2.cert.pem
}

### Root CA

echo -e "\n> Generating Root CA database"
gen_ca

echo -e "\n> Generating Root CA key"
gen_key ca $CA_KEY_SIZE

echo -e "\n> Generating Root CA cert"
openssl req -new -text -x509 -days 7300 -batch \
            -config root_ca_openssl.conf -extensions v3_ca \
            -key private/ca.key.pem -out certs/ca.cert.pem \
            -subj "$SUBJ_PREFIX/CN=Root CA"
chmod 444 certs/ca.cert.pem

### Server certificate

echo -e "\n> Generating Server key"
gen_key server $KEY_SIZE

echo -e "\n> Generating Server cert"
gen_csr "Server" server root_ca_openssl.conf
gen_cert . server root_ca_openssl.conf server_cert 375

### Intermediate CAs

echo -e "\n> Generating Intermediate CAs"
[ ! -d intermediate_cas ] && mkdir intermediate_cas
for i in $(seq -f "%03g" 1 5); do \
    cd intermediate_cas
    
    echo -e "\n>> Generating Intermediate CA $i database"
    [ ! -d $i ] && mkdir $i
    cd $i
    gen_ca

    echo -e "\n>> Generating Intermediate CA $i key"
    gen_key intermediate $CA_KEY_SIZE

    echo -e "\n>> Generating Intermediate CA $i cert"
    gen_csr "Intermediate CA $i" intermediate \
            ../../intermediate_ca_openssl.conf
    cd ../..
    gen_cert intermediate_cas/$i intermediate \
             root_ca_openssl.conf v3_intermediate_ca 3650
done

### Nodes certificates
cd intermediate_cas
for i in $(seq -f "%03g" 1 5); do \
    cd $i
    for j in $(seq -f "%03g" 1 5); do \
        echo -e "\n>> Generating Node $i$j key"
        gen_key node$i$j $KEY_SIZE

        echo -e "\n>> Generating Node $i$j cert"
        gen_csr "Node $i$j" node$i$j \
                ../../intermediate_ca_openssl.conf
        gen_cert . node$i$j \
                 ../../intermediate_ca_openssl.conf usr_cert 21
        cat certs/node$i$j.cert.pem certs/intermediate.cert.pem \
            > certs/node$i$j.chain.pem
    done
    rm -f *.old
    cd ..
done
cd ..
rm -f *.old
