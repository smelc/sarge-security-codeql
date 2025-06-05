#!/usr/bin/bash
#
# Call codeql on the codeql-db directory. Call ./create-codeql-db.sh to create it before.
#
# If you wish to have this script overwrite or create the .github/codeql/golden.csv file,
# set the environment variable RECREATE_GOLDEN_FILE to 1.

declare -r SARIF_FILE="codeql.sarif"
declare -r CSV_FILE="codeql.csv"
declare -r GOLDEN_CSV_FILE=".github/codeql/golden.csv"

command -v codeql || { echo "codeql is missing. Please install it."; exit 1; }
command -v sarif || { echo "sarif is missing. Did you enter the poetry shell?"; exit 1; }

[[ -e "codeql-db" ]] || { echo "codeql-db is missing. Create it with: ./create-codeql-db.sh"; exit 1; }

set -eux

codeql database analyze codeql-db --format=sarif-latest --output="$SARIF_FILE"

rm -Rf "$CSV_FILE"

sarif csv "$SARIF_FILE"

set +u

if [[ "$RECREATE_GOLDEN_FILE" == "1" ]]
then
  mkdir -p "$(dirname "$GOLDEN_CSV_FILE")"
  cp "$CSV_FILE" "$GOLDEN_CSV_FILE"
  ./abstract-csv-file-differences.sh "$GOLDEN_CSV_FILE"
  cat "$GOLDEN_CSV_FILE"
else
  cat "$CSV_FILE"
fi

