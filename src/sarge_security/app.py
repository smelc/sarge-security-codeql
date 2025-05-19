from flask import Flask, request

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
