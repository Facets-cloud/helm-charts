#!/usr/bin/env sh

set -xeuo pipefail

# In case the secret/tls certificate is modified, restart the deployment so the
# webhook server is using the latest certificate. Uses a checksum annotation to
# determine if a restart is needed
# ==================================

cd /tmp

ANNOTATION="post-install-checksum"

kubectl get secrets $SECRET_NAME -o json >secret.json

CHECKSUM=$(jq -r .data secret.json | sha256sum | cut -f1 -d " ")
ANNOTATION_CHECKSUM=$(jq -r --arg ANNOTATION "$ANNOTATION" '.metadata.annotations[$ANNOTATION]' secret.json)

if [ "$CHECKSUM" == "$ANNOTATION_CHECKSUM" ]; then
    echo "secret matches checksum, no restart needed"
    exit 0
fi

kubectl rollout restart deployment $DEPLOYMENT_NAME

jq -n --arg ANNOTATION "$ANNOTATION" --arg CHECKSUM "$CHECKSUM" '.metadata.annotations[$ANNOTATION]=$CHECKSUM' >patch.json
kubectl patch secret $SECRET_NAME --patch-file patch.json
