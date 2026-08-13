#!/usr/bin/env bash
# Guardrail: the chart's default operator image tag must equal operator-v<appVersion>,
# so a version bump can never ship a stale image tag (drift). Dependency-free
# (grep/sed/awk) so it runs in CI chart-lint and in /release-chart alike.
#   usage: check-image-tag.sh [chart-dir]   (default: the chart this script lives in)
set -euo pipefail

chart_dir="${1:-$(cd "$(dirname "$0")/.." && pwd)}"
chart_yaml="$chart_dir/Chart.yaml"
values_yaml="$chart_dir/values.yaml"
for f in "$chart_yaml" "$values_yaml"; do
  [ -f "$f" ] || { echo "ERROR: $f not found"; exit 1; }
done

# strip CR, trailing inline comment, surrounding whitespace, and one layer of quotes
trim() { printf '%s' "$1" | tr -d '\r' | sed -E 's/[[:space:]]+#.*$//; s/^[[:space:]]*//; s/[[:space:]]*$//; s/^"(.*)"$/\1/; s/^'\''(.*)'\''$/\1/'; }

appver=$(trim "$(grep -E '^appVersion:' "$chart_yaml" | head -n1 | sed -E 's/^appVersion:[[:space:]]*//')")
# top-level image.tag only: enter at `^image:`, then match `tag:` at the DIRECT-child
# indent (the indent of image's first child). A nested key (e.g. image.metadata.tag)
# is deeper, so it never satisfies the check. Stop at the next top-level key.
tag=$(awk '
  /^image:/ {inblock=1; ci=""; next}
  inblock && /^[^[:space:]#]/ {exit}
  inblock && /^[[:space:]]+[^[:space:]#]/ {
    match($0, /^[[:space:]]+/); ind=substr($0, 1, RLENGTH)
    if (ci == "") ci=ind                       # first child sets the direct-child indent
    if ($0 ~ ("^" ci "tag:")) { line=$0; sub("^" ci "tag:[[:space:]]*", "", line); print line; exit }
  }
' "$values_yaml")
tag=$(trim "$tag")

[ -n "$appver" ] || { echo "ERROR: appVersion not found in $chart_yaml"; exit 1; }
[ -n "$tag" ]    || { echo "ERROR: top-level image.tag missing/empty in $values_yaml; must be operator-v$appver"; exit 1; }

want="operator-v${appver}"
if [ "$tag" != "$want" ]; then
  echo "ERROR: chart image.tag ('$tag') must equal operator-v<appVersion> ('$want')."
  echo "Bump values.yaml image.tag and Chart.yaml appVersion together — they must stay in lockstep."
  exit 1
fi
echo "OK: image.tag '$tag' == operator-v<appVersion> ('$appver')."
