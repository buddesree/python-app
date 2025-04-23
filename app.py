from flask import Flask
import os

app = Flask(__name__)

@app.route("/")
def hello():
    msg = os.getenv("MESSAGE", "Hello, Kubernetes!")
    return f"<h1>{msg}</h1>"

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
