from flask import Flask
from werkzeug.middleware.proxy_fix import ProxyFix
import sqlite3

app = Flask(__name__)

app.wsgi_app = ProxyFix(
    app.wsgi_app,
    x_for=1,
    x_proto=1,
    x_host=1,
    x_prefix=1
)

DATABASE = "visitors.db"


def increment_counter():
    conn = sqlite3.connect(DATABASE)

    cursor = conn.cursor()

    cursor.execute(
        "UPDATE counter SET visits = visits + 1 WHERE id = 1"
    )

    conn.commit()

    cursor.execute(
        "SELECT visits FROM counter WHERE id = 1"
    )

    visits = cursor.fetchone()[0]

    conn.close()

    return visits


@app.route("/")
def home():

    visits = increment_counter()

    return f"""
     <h1>Viikko 2 Python Web Application</h1>

    <p>
    This application runs on an Ubuntu server using Flask and an Nginx reverse proxy.
    </p>

    <h2>Visitor Count</h2>

    <p>
    Current visitor count: <strong>{visits}</strong>
    </p>

    <h2>Implementation</h2>

    <ul>
        <li>Web server: Nginx</li>
        <li>Application framework: Flask</li>
        <li>Database: SQLite</li>
        <li>The visitor counter is stored in an SQLite database.</li>
        <li>The counter is incremented on every page load.</li>
        <li>The counter value is preserved across application and server restarts.</li>
        <li>The server reboot test was successfully completed and the counter continued from its previous value.</li>
    </ul>

    <h2>Source Code</h2>

    <p>
    GitHub repository link will be added here.
    </p>
    """


if __name__ == "__main__":
    app.run(host="127.0.0.1", port=8000)

