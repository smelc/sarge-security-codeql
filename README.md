# sarge-security-codeql

This repository's purpose is to show how to model a Python library using [CodeQL](https://codeql.github.com/). In this repository, we model the [sarge](https://github.com/vsajip/sarge) Python library. We chose sarge because:

1. Sarge is currently not in [CodeQL's list of supported Python libraries](https://github.com/github/codeql/tree/main/python/ql/lib/semmle/python/frameworks).
1. Sarge wraps [subprocess](https://docs.python.org/3/library/subprocess.html) and as such it can create security threats, if used incorrectly.

## Develop CodeQL rules

We recommend installing the [vscode CodeQL extension](https://marketplace.visualstudio.com/items?itemName=GitHub.vscode-codeql) and to develop rules in the [codeql-queries](./codeql-queries) directory. If you have installed `codeql` by unpacking the [codeql-bundle](https://github.com/github/codeql-action/releases) and made the `codeql` binary available in your `PATH`, you should have support for navigating the CodeQL standard library from an editor launched in this repository.

### Run CodeQL like the CI does

To test vulnerabilities found by `codeql` on this codebase, the workflow is the following:

1. Call `./create-codeql-db.sh`. This creates a `codeql-db-GIT_HASH` directory and links the `codeql-db` directory to it.
1. Call `./run-codeql-analysis.sh`. This call `codeql` on the database `codeql-db` and then calls [sarif](https://github.com/microsoft/sarif-tools) to present the results in text format. This is handy to locally test on the CLI (as opposed to launching queries within vscode, which can be flaky).

### Test a single query

You need to create the database with `./create-codeql-db.sh` as above, but then to test
a single query you are currently developing (say [codeql-queries/GetSargeRunSinks.ql](./codeql-queries/GetSargeRunSinks.ql)), do as follows:

```shell
./run-codeql-analysis.sh ./codeql-queries/GetSargeRunSinks.ql
```

When you change your query, unless you've changed the Python code in [app](./app), you don't need to rebuild the database.

## Witness the vulnerabilities

To observe the vulnerabiities, you need to setup this project's Python code, as detailed below.

### Installation

This project uses [poetry](https://python-poetry.org/) for provisioning dependencies and tooling.

We provide a [.envrc](./envrc) file to enter the development shell automatically
(leveraging [direnv](https://direnv.net)). If you don't use that, please refer to poetry's documentation.

### Running the app

Run the Flask app with:

```shell
flask --app src/sarge_security/app.py --debug run
```

The `--debug` flag enables hot reloading of changes.

Depending on the kind of vulnerability, you will observe it in the terminal executing `flask` or in the webpage's content.
