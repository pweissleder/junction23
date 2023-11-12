from flask import Flask
import subprocess
from main import run_game

app = Flask(__name__)


@app.route('/run-script')
def run_script():
    run_game()


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
