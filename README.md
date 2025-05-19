## Run codeql on the CLI

To test what vulnerabilities are found by `codeql` on this codebase, the workflow is the following:

1. Call `./create-codeql-db.sh`. This creates a `codeql-db-GIT_HASH` directory and links the `codeql-db` directory to it.
1. Call `./run-codeql-analysis.sh`. This call `codeql` on the database `codeql-db` and then calls [sarif](https://github.com/microsoft/sarif-tools) to present the results in text format.

## Installation

This project uses [poetry](https://python-poetry.org/) for provisioning dependencies and tooling.

We provide a [.envrc](./envrc) file to enter the development shell automatically
(leveraging [direnv](https://direnv.net)). If you don't use that, please refer to poetry's documentation.

## Running the app

Run the Flask app with:

```shell
flask --app src/sarge_security/app.py --debug run
```

The `--debug` flag enables hot reloading of changes.
