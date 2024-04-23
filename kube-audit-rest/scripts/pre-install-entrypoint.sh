#!/usr/bin/env sh

# No need to generate cert if the existing cert is valid (openssl verify doesn't
# return any error)

bash /scripts/pre-install-check-cert.sh || bash /scripts/pre-install-cert-gen.sh
