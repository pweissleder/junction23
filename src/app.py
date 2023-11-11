from flask import Flask, jsonify, request
app = Flask(__name__)


@app.route('/')
def index():
    return "Hello, Flask!"

@app.route('/test-flutter', methods = ['GET', 'POST'])
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


if __name__ == '__main__':
    app.run(debug=True, host="0.0.0.0", port=5000)
