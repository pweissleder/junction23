from flask import Flask, jsonify, request

from src.models.avatar import Avatar

app = Flask(__name__)


@app.route('/')
def index():
    return "Hello, Flask!"


@app.route('/test-flutter', methods=['GET', 'POST'])
def test_flutter():
    """
    ONLY FOR CONNECTION TESTING
    """
    if request.method == "POST":
        print("Flutter has successfully sent POST data")
        data = request.json
        return jsonify({"message": "Data received from Flutter", "data": data})
    elif request.method == 'GET':
        print('Flutter has sent a GET request')
        # You can perform actions for GET requests here if needed
        return jsonify({"message": "GET request received from Flutter"})


@app.route('/api/init_user', methods=['POST'])
def init_user():
    """
    Initialize the current user and write to firebase
    """

    avatar = Avatar(request.form.get('name'))

    # TODO: Write user to firebase

@app.route('/api/chall_completed', methods=['POST'])
def complete_chall():
    """
    LOAD CURRENT USER
    """


if __name__ == '__main__':
    app.run(debug=True, host="0.0.0.0", port=5000)
