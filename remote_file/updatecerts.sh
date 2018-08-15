#!/bin/bash

cp ../pki/certs/ca.cert.pem nginx/certs
cp ../pki/certs/ca.cert.pem ca_cert.pem

cp ../pki/certs/server.cert.pem nginx/certs
cp ../pki/private/server.key.pem nginx/certs

cp ../pki/intermediate_cas/001/certs/node001001.chain.pem client_cert.pem
cp ../pki/intermediate_cas/001/private/node001001.key.pem client_key.pem
