#!/usr/bin/env sh

set -xeuo pipefail
# Generates a self signed certificate and then patches the k8s secret &
# validating webhook config with the tls certs and ca bundle
cd /tmp

kubectl get secrets $SECRET_NAME -o yaml
# sleep infinity
