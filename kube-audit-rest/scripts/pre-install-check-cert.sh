#!/usr/bin/env sh

set -xeuo pipefail

cd /tmp

kubectl get secrets $SECRET_NAME -o json >secret.json
jq -r '.data["tls.crt"]' secret.json | base64 --decode >tls.crt
jq -r '.data["ca.crt"]' secret.json | base64 --decode >ca.crt
openssl verify -CAfile ca.crt tls.crt
