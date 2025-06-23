from typing import Any
from flask import Flask, request

import sarge

app = Flask(__name__)

@app.route("/")
def root():
    return """
To test the vulnerabilities, do the following:

<ul>
<li><code>curl -X POST http://localhost:5000/eval -d "key=print(request)"</code></li>
<li><code>curl -X POST http://localhost:5000/sarge -d "key=ls"</code></li>
</ul>
"""

@app.route("/eval", methods=["POST"])
def user_to_eval():
    """This function shows a vulnerability: it forwards user input (through a POST request)
       to python's eval function. This vulnerability is caught by CodeQL's default set of rules."""
    print("/eval handler")
    if request.method == "POST":
        received = request.form.get("key")
        if received is None:
            return "Please provide data at \"key\""
        print(f"Received: {str(received)}")
        eval(received) # Unsafe, don't do that!
        return "Called eval"
    else:
        return "Method not allowed"

@app.route("/sarge", methods=["POST"])
def user_to_sarge_run():
    """This function shows a vulnerability: it forwards user input (through a POST request)
       to sarge.run. This vulnerability is caught thanks to our custom CodeQL rule."""
    print("/sarge handler")
    if request.method == "POST":
        received = request.form.get("key")
        if received is None:
            return "Please provide data at \"key\""
        print(f"Received: {str(received)}")
        sarge.run(received) # Unsafe, don't do that!
        return "Called sarge"
    else:
        return "Method not allowed"

def input_to_sarge_run():
    """This function shows a vulnerability: it forwards user input (via input())
       to sarge.run. Having sarge.run flagged as a sink doesn't suffice to catch
       this vulnerability, because CodeQL doesn't consider input() as a tainting source
       (explained here: https://github.com/github/codeql/issues/14347#issuecomment-1742901643).
       This is visible if you execute the query GetRemoveFlowSource.ql

       So to flag this function as vulnerable, we need to declare that input is a tainting source,
       as visible in SargeLib.qll
    """
    received = input("Enter command to run: ")
    sarge.run(received) # Unsafe, don't do that!
    print("Called sarge")

def input_to_sarge_run_input():
    """This function shows a vulnerability: it forwards user input (via input())
       to sarge.run (using the 'input' keyword).
    """
    received = input("Enter file to read: ")
    with open(received, "r") as file_handle:
        sarge.run("cat", input=file_handle) # Unsafe, don't do that!
        print("Called sarge")

class PostData:

    def __init__(self, key: Any):
        self.key = key

@app.route("/object", methods=["POST"])
def user_to_sarge_run_via_object():
    """This function shows a vulnerability: it forwards user input (through a POST request)
       to sarge.run. This vulnerability is caught thanks to our custom CodeQL rule."""
    print("/sarge object handler")
    if request.method == "POST":
        received = request.form.get("key")
        if received is None:
            return "Please provide data at \"key\""
        d = PostData(received)
        sarge.run(d.key) # Unsafe, don't do that!
        return "Called sarge"
    else:
        return "Method not allowed"

def my_sanitizer(_input: str) -> str:
    # We need to use "_input", otherwise CodeQL would not consider this function
    # as breaking tainting.
    return _input[0:0]

@app.route("/object_safe", methods=["POST"])
def user_to_sarge_run_via_object_sanitized():
    """This function shows how to avoid the previous vulnerability,
       by using a custom sanitizer function that breaks the tainted data's propagation.
       See how 'isBarrier' is defined in SargeLib.qll."""
    print("/sarge object handler")
    if request.method == "POST":
        received = request.form.get("key")
        if received is None:
            return "Please provide data at \"key\""
        d = PostData(received)
        to_sarge = my_sanitizer(d.key) # Sanitize input, to avoid vulnerability
        sarge.run(to_sarge)
        return "Called sarge"
    else:
        return "Method not allowed"