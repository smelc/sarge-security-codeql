#!/usr/bin/bash
#
# Call codeql on the codeql-db directory. Call ./create-codeql-db.sh to create it before.

declare -r SARIF_FILE="codeql.sarif"
declare -r CSV_FILE="codeql.csv"

command -v codeql || { echo "codeql is missing. Please install it."; exit 1; }
command -v sarif || { echo "sarif is missing. Did you enter the poetry shell?"; exit 1; }

[[ -e "codeql-db" ]] || { echo "codeql-db is missing. Create it with: ./create-codeql-db.sh"; exit 1; }

set -eux

codeql database analyze codeql-db --format=sarif-latest --output="$SARIF_FILE"

rm -Rf "$CSV_FILE"

sarif csv "$SARIF_FILE"

set +x

cat "$CSV_FILE"
