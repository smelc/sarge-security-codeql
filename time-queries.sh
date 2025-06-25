#!/usr/bin/env bash
#
# Script to benchmark individual queries

set -eux

declare -r QUERIES_FILE="queries.txt"
rm -Rf "$QUERIES_FILE"

codeql resolve queries "codeql-queries/Sarge.qls" > "$QUERIES_FILE"
while read -r query; do
  echo "Running $query"
  START=$(date +%s.%N)
  codeql database analyze codeql-db --rerun --threat-model=local --format=sarif-latest --output=/dev/null "$query"
  END=$(date +%s.%N)
  DURATION=$(echo "$END - $START" | bc)
  echo "$query took $DURATION seconds"
done < queries.txt
