#!/usr/bin/env sh

# Run CA injector and then rollout restart.
#
# Both scripts wont update (inject ca or rollout restart) if nothing has changed

bash /scripts/post-install-ca-injector.sh
bash /scripts/post-install-rollout-restart.sh
