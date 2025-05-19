# sarge-security-codeql

This repository's purpose is to show how to model a Python library using [CodeQL](https://codeql.github.com/). In this repository, we model the [sarge](https://github.com/vsajip/sarge) Python library. We chose sarge because:

1. Sarge is currently not in [CodeQL's list of supported Python libraries](https://github.com/github/codeql/tree/main/python/ql/lib/semmle/python/frameworks).
1. Sarge wraps [subprocess](https://docs.python.org/3/library/subprocess.html) and as such it can create security threats, if used incorrectly.

## Develop CodeQL rules

Developing CodeQL rules can feel odd, because you work in two repositories at the same time:

1. In the repository you are testing your rules' behavior (this one)
1. In the [CodeQL repository](https://github.com/github/codeql), because VSCode will provide linking, syntax highlighting, etc. for writing queries.

### Run CodeQL on the CLI

To test vulnerabilities found by `codeql` on this codebase, the workflow is the following:

1. Call `./create-codeql-db.sh`. This creates a `codeql-db-GIT_HASH` directory and links the `codeql-db` directory to it. In your clone of the CodeQL repository, you'll want to add the `codeql-db` folder as a CodeQL database (to test your queries).
1. Call `./run-codeql-analysis.sh`. This call `codeql` on the database `codeql-db` and then calls [sarif](https://github.com/microsoft/sarif-tools) to present the results in text format. This is handy to test on the CLI locally.

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
