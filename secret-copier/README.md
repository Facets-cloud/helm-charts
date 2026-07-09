# secret-copier

Replicates labelled secrets from the `default` namespace into every other active
namespace, and keeps them in sync. Built for fanning out image **pull secrets**
(docker registry credentials) so pods in any namespace can pull images.

It runs [flant/shell-operator](https://github.com/flant/shell-operator) with the
hooks stored in a ConfigMap (`templates/hook-configmap.yaml`, sourced from
`.Values.Config` in `values.yaml`).

## What it does

A secret in `default` is replicated to all other namespaces when it carries the
label:

```
secret-copier: yes
```

Four hooks drive the sync:

| Hook | Trigger | Action |
|------|---------|--------|
| `add_or_update_secret` | labelled secret in `default` Added/Modified | copy to every other active namespace |
| `create_namespace` | any namespace Added | copy all labelled `default` secrets into it |
| `schedule_sync_secret` | cron `0 3 * * *` | reconcile all labelled secrets into all namespaces |
| `delete_secret` | labelled secret in `default` Deleted | **no-op** (targets are intentionally left in place) |

## Type-aware copy (why this is not a plain `kubectl apply`)

A Secret's `.type` is **immutable**. Docker pull secrets exist in two type
variants that hold the same credentials in different shapes:

| type | data key | payload |
|------|----------|---------|
| `kubernetes.io/dockercfg` (older kubectl) | `.dockercfg` | `{ "<registry>": {...} }` |
| `kubernetes.io/dockerconfigjson` (newer kubectl) | `.dockerconfigjson` | `{ "auths": { "<registry>": {...} } }` |

When a source secret's type differs from an existing target's type, a naive
`kubectl apply` fails on the immutable-field conflict and the copy silently
breaks — which caused a production pull-secret outage.

The copier therefore resolves each target case explicitly, and **never deletes**
a target (delete+recreate would open a window with no pull secret):

1. **Target missing** → create it (carries the source type).
2. **Same type** → `apply` (only `.data` changes).
   - Target `immutable: true` → skip + warn.
3. **Type mismatch**, `dockercfg ↔ dockerconfigjson` → **patch `.data` only**:
   convert the payload into the target type's key/shape, drop the stale key,
   leave `.type` untouched.
   - Target `immutable: true` → skip + warn (cannot patch).
   - Any other (non-convertible) type mismatch → skip + warn.

Only `dockercfg ↔ dockerconfigjson` is convertible — those two encode the same
data. All other type mismatches are skipped, never guessed.

## Observability

Every action logs a `secret-copier:` line to the shell-operator pod's stdout:

```
kubectl -n <release-namespace> logs deploy/<release-name>
```

- `created <ns>/<name> (type=...)`
- `updated <ns>/<name> (type=...)`
- `converted <ns>/<name> data (<src> -> target type <dst>; type preserved, data patched)`
- `SKIP <ns>/<name> ...` (immutable / non-convertible / empty payload) — on stderr
- `ERROR failed to patch <ns>/<name> ...` — on stderr

## Install

```
helm install secret-copier ./secret-copier --namespace <ns> --create-namespace
```

Then label a pull secret in `default` to start replication:

```
kubectl -n default label secret <name> secret-copier=yes
```

## Upgrade

The shell-operator Deployment is annotated with a checksum of the hook
ConfigMap, so editing hooks in `values.yaml` and running `helm upgrade` rolls
the operator automatically:

```
helm upgrade secret-copier ./secret-copier --namespace <ns>
```

## Note

This chart is a homegrown equivalent of maintained cross-namespace secret
replicators such as [emberstack/kubernetes-reflector](https://github.com/emberstack/kubernetes-reflector)
and [kubed](https://github.com/kubeops/kubed). Consider them if you want an
off-the-shelf, patch-based replicator instead of maintaining these hooks.
