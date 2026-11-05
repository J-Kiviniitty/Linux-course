from flask import Flask
from werkzeug.middleware.proxy_fix import ProxyFix

app = Flask(__name__)

# One Nginx proxy in front
app.wsgi_app = ProxyFix(
    app.wsgi_app,
    x_for=1,
    x_proto=1,
    x_host=1,
    x_prefix=1
)

@app.route("/")
def home():
    return """
    <h1>Viikko 2 Flask Application</h1>
    <p>Reverse proxy works!</p>
    """

if __name__ == "__main__":
    app.run(host="127.0.0.1", port=8000)
