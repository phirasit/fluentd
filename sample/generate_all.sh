#!/bin/sh
if [ ! -f ./certs/ca.pem ]; then
  ./generate_ca_cert.rb ./certs/server.key ./certs/ca.pem
fi
./generate_csr.rb $1 ./certs/$1.key certs/$1-csr.pem
./generate_cert.rb ./certs/server.key ./certs/ca.pem ./certs/$1-csr.pem ./certs/$1-cert.pem

# verify pem
openssl verify -CAfile ./certs/ca.pem ./certs/$1-cert.pem

