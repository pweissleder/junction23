from flask import Flask, jsonify, request

app = Flask(__name__)


@app.route('/')
def index():
    return "Hello, Flask!"


if __name__ == '__main__':
    app.run(debug=True)
