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

# The install line given to an AI is the one Forge's README gives, and the
# script it runs is there
readme=$(curl -fsSL https://raw.githubusercontent.com/mollendorff-ai/forge/main/README.md)
line=$(printf '%s\n' "$readme" | grep -o 'curl -fsSL https://raw.githubusercontent.com/mollendorff-ai/forge/main/install.sh | sh -s -- --examples' | head -1 || true)
if [ -z "$line" ]; then
  echo "Forge's README gives no install.sh line"
  status=1
else
  curl -fsSL -o /dev/null https://raw.githubusercontent.com/mollendorff-ai/forge/main/install.sh \
    || { echo "install.sh is not on Forge's main branch"; status=1; }
  for f in index.html fr/index.html llms.txt; do
    if grep -qF "$line" "$f"; then echo "$f: install line ok"; else echo "$f: install line differs from Forge's README"; status=1; fi
  done
fi

# Every page of Forge's docs the home page links to is on Forge's main branch
for page in $(grep -ohE 'github.com/mollendorff-ai/forge/blob/main/docs/[A-Z]+\.md' index.html fr/index.html llms.txt | sort -u); do
  path=${page#github.com/mollendorff-ai/forge/blob/main/}
  if curl -fsSL -o /dev/null "https://raw.githubusercontent.com/mollendorff-ai/forge/main/$path"; then
    echo "$path: on Forge's main branch: ok"
  else
    echo "$path is linked from the home page but is not on Forge's main branch"; status=1
  fi
done
exit $status
