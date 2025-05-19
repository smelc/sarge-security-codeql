#!/usr/bin/bash
#
# This script runs codeql on the database at "codeql-db"
# That's the most recent created by ./create-codeql-db.sh (if you have been running it
# multiple times), which is usually what you want.

[[ -e "codeql-db" ]] || { echo "codeql-db is missing. Create it with: ./create-codeql-db.sh"; exit 1; }

command -v codeql || { echo "codeql is missing. Please install it."; exit 1; }

codeql database analyze codeql-db python-security-and-quality python-security-experimental --format=sarif-latest --output=codeql.sarif

command -v sarif || { echo "sarif is missing. Please install it. Did you enter the poetry shell?"; exit 1; }
