#!/usr/bin/bash
#
# Creates the database in the folder codeql-db-GIT_HASH (optionally putting the "-dirty" suffix,
# to indicate that there was a git-tracked modified|staged file)
# And link codeql-db to it, so that codeql-db always points to the latest db that was created,
# while preserving databases of older versions.

command -v codeql || { echo "codeql is missing. Please install it."; exit 1; }

set -eux

TARGET=$(git rev-parse --short HEAD)
DB_TARGET="codeql-db-$TARGET"

[[ $(git diff --quiet) && $(git diff --cached --quiet) ]] || DB_TARGET+="-dirty"

rm codeql-db "$DB_TARGET" -Rf

codeql database create --language=python "$DB_TARGET" --source-root=src

ln -s "$DB_TARGET" codeql-db
