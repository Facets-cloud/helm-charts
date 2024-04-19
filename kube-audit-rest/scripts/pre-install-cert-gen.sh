#!/usr/bin/env sh

set -xeuo pipefail

# Generates a self signed certificate and then patches the k8s secret &
# validating webhook config with the tls certs and ca bundle
# =======================================
SCRIPT_HOME="/scripts/"

cd /tmp

# assert openssl is installed
command -v openssl && openssl version

openssl genrsa -out ca.key 2048

# valid for 27 years
openssl req -x509 -new -nodes -key ca.key -subj "/CN=${RELEASE_NAME}" -days 10000 -out ca.crt

openssl genrsa -out server.key 2048

cat $SCRIPT_HOME/csr.conf | envsubst | tee csr.parsed.conf
openssl req -new -key server.key -out server.csr -config csr.parsed.conf

# valid for 27 years
openssl x509 -req -in server.csr -CA ca.crt -CAkey ca.key \
    -CAcreateserial -out server.crt -days 10000 \
    -extensions v3_ext -extfile csr.parsed.conf -sha256

openssl req -noout -text -in ./server.csr
openssl x509 -noout -text -in ./server.crt

CERT=$(base64 server.crt | tr -d '\n')
KEY=$(base64 server.key | tr -d '\n')
CA=$(base64 ca.crt | tr -d '\n')

jq -n --arg cert "$CERT" --arg key "$KEY" --arg ca "$CA" \
    '{
      "data": {
        "tls.crt": $cert,
        "tls.key": $key,
        "ca.crt": $ca
      }
    }' >patch.json

kubectl patch secret $SECRET_NAME --patch-file patch.json
