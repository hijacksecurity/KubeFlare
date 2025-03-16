from flask import Flask
import os
import socket
import getpass
from src import __version__

def main():
    app = Flask(__name__)

    # Load configuration based on ENV
    env = os.getenv('FLASK_ENV', 'DEV')

    if env == 'DEV':
        app.config.from_object('config.dev_config.DevConfig')
    elif env == 'TEST':
        app.config.from_object('config.test_config.TestConfig')
    elif env == 'PROD':
        app.config.from_object('config.prod_config.ProdConfig')
    else:
        app.config.from_object('config.config.Config')  # default/fallback

    # Override version from __init__.py
    app.config['VERSION'] = __version__

    @app.route('/')
    def home():
        version = app.config['VERSION']
        environment = app.config['ENV']
        hostname = socket.gethostname()
        user = getpass.getuser()

        return (
            f"<h2>Kubeflare Flask App 🚀</h2>"
            f"<ul>"
            f"<li><strong>Version:</strong> {version}</li>"
            f"<li><strong>Environment:</strong> {environment}</li>"
            f"<li><strong>Host:</strong> {hostname}</li>"
            f"<li><strong>User:</strong> {user}</li>"
            f"</ul>"
        )

    return app

if __name__ == '__main__':
    application = main()
    application.run(host='0.0.0.0', port=5000, debug=application.config['DEBUG'])
