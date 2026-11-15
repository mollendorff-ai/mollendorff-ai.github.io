#!/usr/bin/env bash
# The home page says "More than N formula cases". N is a floor in steps of 500.
# It fails when N is more than Forge really has, or 500 or more below it.
set -euo pipefail
cd "$(dirname "$0")/.."
actual=$(curl -fsSL https://raw.githubusercontent.com/mollendorff-ai/forge/main/validation/gnumeric/README.md \
  | grep -o '[0-9],[0-9][0-9][0-9] formula tests' | head -1 | tr -d ', a-z')
[ -n "$actual" ] || { echo "cannot read the case count from Forge"; exit 1; }
status=0
check() {
  claimed=$(grep -oE "(More than|Plus de) [0-9][^0-9]{0,3}[0-9]{3} (formula cases|cas de formules)" "$1" | head -1 | tr -cd '0-9')
  [ -n "$claimed" ] || { echo "$1: no count found"; status=1; return; }
  if [ "$claimed" -gt "$actual" ] || [ $((actual - claimed)) -ge 500 ]; then
    echo "$1 says more than $claimed; Forge has $actual. Write the nearest 500 below $actual."
    status=1
  else
    echo "$1: more than $claimed, Forge has $actual: ok"
  fi
}
check index.html
check fr/index.html
exit $status
