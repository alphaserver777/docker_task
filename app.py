from flask import Flask

app = Flask(__name__)

@app.route("/")
def index():
    return "Hello from Docker in Yandex Cloud!"

@app.route("/health")
def health():
    return "OK"

if __name__ == "__main__":
    # Важно слушать на 0.0.0.0 и конкретном порту, чтобы Docker мог пробросить порт
    app.run(host="0.0.0.0", port=8000)

