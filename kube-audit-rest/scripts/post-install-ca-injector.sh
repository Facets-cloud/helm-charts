#!/usr/bin/env sh

set -xeuo pipefail

# Injects the CA certificate from the secret to the validating webhook
# configuration
# ===================================

cd /tmp

CA_BUNDLE=$(kubectl get secrets $SECRET_NAME -o jsonpath='{.data.ca\.crt}')

INSTALLED_BUNDLE=$(kubectl get validatingwebhookconfigurations kube-audit-rest -o jsonpath='{.webhooks[?(@.name=="kube-audit-rest.kube-audit-rest.svc.cluster.local")].clientConfig.caBundle}')

if [ "$CA_BUNDLE" == "$INSTALLED_BUNDLE" ]; then
    echo "CA bundle is up to date"
    exit 0
fi
WEBHOOK_URL="$WEBHOOK_NAME.$RELEASE_NAMESPACE.svc.cluster.local"
jq -n --arg caBundle "$CA_BUNDLE" --arg webhookName "$WEBHOOK_URL" \
    '{
        "webhooks": [
          {
            "name": $webhookName,
            "clientConfig": {
              "caBundle": $caBundle
            }
          }
        ]
    }' >patch.json
cat patch.json
kubectl patch validatingwebhookconfigurations $WEBHOOK_NAME --patch-file patch.json
