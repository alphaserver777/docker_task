import os
from flask import Flask

app = Flask(__name__)

ENV = os.getenv("APP_ENV", "production")

@app.route("/")
def index():
    return f"Hello from Docker! ENV={ENV}"

@app.route("/health")
def health():
    return "OK"

if __name__ == "__main__":
    debug = ENV == "development"
    app.run(host="0.0.0.0", port=8000, debug=debug)
