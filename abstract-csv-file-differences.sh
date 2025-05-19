#!/usr/bin/env bash
#
# Modifies a CSV file produced by CodeQL to abstract differences in this file witnessed between a local setup
# and the CI's setup. Ideally those differences should be eliminated by harmonizing the two setups, but for
# this demo repo I chose a quick and dirty fix that consists of rewriting the obtained file. The differences
# are minor (severities sometimes differ and root directory of paths of files differ too).

[[ -n "$1" ]] || { echo "This script expects one argument: the CSV file that must be rewritten"; exit 1; }

set -eux

declare -r TMP_FILE="$1.out"
rm -Rf "$TMP_FILE"

# Remove the severity column, because I observed that severities - of vulnerabilities - reported locally
# and in CI are different.
csvcut -C 2 "$1" > "$TMP_FILE"
mv "$TMP_FILE" "$1"

# Remove the src/ prefix that appears in the "Location" column (in e.g. 'src/sarge_security/app.py'),
# because this prefix appears in CI, but not locally
sed 's/,src\//,/g' "$1" > "$TMP_FILE"
mv "$TMP_FILE" "$1"
