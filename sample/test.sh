#!/bin/sh
echo '{"field1":"123456","field2":"awesome"}' \
  | openssl s_client \
    -connect 192.168.1.138:8889 \
    -cert certs/$1-cert.pem -key certs/$1.key \
    -CAfile certs/ca.pem

