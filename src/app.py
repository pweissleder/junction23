import json

from firebase_admin import firestore
from flask import Flask, jsonify, request
from src.models.avatar import Avatar
import firebase_admin
import os
from firebase_admin import credentials
from firebase_admin import firestore

from src.models.cosmetic import Cosmetic
from src.models.sensor import Sensor
from src.models.skill import GeneralSkill

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
    data = json.loads(request.data)
    user_id = data.get('user_id')
    username = data.get('username')

    name = data.get('name')
    age = data.get('age')
    height = data.get('height')
    weight = data.get('weight')
    gender = data.get('gender')

    avatar = Avatar(user_id, username, name, height, age, weight, gender)
    avatar.init_challenges()
    avatar_data = json.loads(avatar.to_json())



    current_directory = os.getcwd()
    service_account_key_path = os.path.join(current_directory, 'config', 'serviceAccountKey.json')

    # Initialize Firebase Admin SDK with the dynamically determined path
    cred = credentials.Certificate(service_account_key_path)
    firebase_admin.initialize_app(cred)

    # Initialize Firestore database
    db = firestore.client()

    # Create or update the user document in Firestore
    user_ref = db.collection('users').document(user_id)
    user_ref.set(avatar_data)
    for c in avatar.challenges:
        db.collection("users").document("iHe7WMOWY3YEiA4qAubXJKOCx6O2").collection("challenges").document(c.assoc_skill).set(c.to_json())
    "iHe7MWOMY3YEiA4qAubXJKOCx602"
    # Close Firebase Admin SDK
    firebase_admin.delete_app(firebase_admin.get_app())

    return "SUCCESS"

    ## Shop
@app.route('/api/shop/buy', methods=['POST'])
def shop_buy():
    if request.method == "POST":

        current_directory = os.getcwd()
        service_account_key_path = os.path.join(current_directory, 'config', 'serviceAccountKey.json')

        # Initialize Firebase Admin SDK with the dynamically determined path
        cred = credentials.Certificate(service_account_key_path)
        firebase_admin.initialize_app(cred)
       

        print("Flutter has successfully sent POST data on the buy endpoint")
        data = json.loads(request.data)
        user_id = data.get('user_id')
        cosmetic_id = data.get('cosmetic_id')
        # Initialize Firestore database
        db = firestore.client()

        # Create or update the user document in Firestore
        user_ref = db.collection('users').document(user_id)

        try:
            doc = user_ref.get()
            if doc.exists:
                # Document data is stored in the to_dict() method
                data = doc.to_dict()
                inventory = dict(data.get('inventory'))

                if cosmetic := inventory.get(cosmetic_id):
                    cosmetic['bought'] = True
                    inventory[cosmetic_id] = cosmetic
                    data['inventory'] = inventory
                    user_ref.update(data)
                else:
                    print(f"Cosmetic {cosmetic_id} does not exist.")
            else:
                print(f"Document {user_id} does not exist.")
        except Exception as e:
            print(f"An error occurred: {e}")


        firebase_admin.delete_app(firebase_admin.get_app())
        return jsonify({"message": "Ok"})


@app.route('/api/inventory/equip', methods=['POST'])
def equip_cosmetic():
    if request.method == "POST":

        current_directory = os.getcwd()
        service_account_key_path = os.path.join(current_directory, 'config', 'serviceAccountKey.json')

        # Initialize Firebase Admin SDK with the dynamically determined path
        cred = credentials.Certificate(service_account_key_path)
        firebase_admin.initialize_app(cred)

        print("Flutter has successfully sent POST data on the buy endpoint")
        data = json.loads(request.data)
        user_id = data.get('user_id')
        cosmetic_id = data.get('cosmetic_id')
        # Initialize Firestore database
        db = firestore.client()

        # Create or update the user document in Firestore
        user_ref = db.collection('users').document(user_id)

        try:
            doc = user_ref.get()
            if doc.exists:
                # Document data is stored in the to_dict() method
                data = doc.to_dict()
                inventory = dict(data.get('inventory'))

                if cosmetic := inventory.get(cosmetic_id):
                    cosmetic['equipped'] = True
                    inventory[cosmetic_id] = cosmetic
                    data['inventory'] = inventory
                    user_ref.update(data)
                else:
                    print(f"Cosmetic {cosmetic_id} does not exist.")
            else:
                print(f"Document {user_id} does not exist.")
        except Exception as e:
            print(f"An error occurred: {e}")

        firebase_admin.delete_app(firebase_admin.get_app())
        return jsonify({"message": "Ok"})


@app.route('/api/inventory/strip', methods=['POST'])
def strip_cosmetic():
    if request.method == "POST":

        current_directory = os.getcwd()
        service_account_key_path = os.path.join(current_directory, 'config', 'serviceAccountKey.json')

        # Initialize Firebase Admin SDK with the dynamically determined path
        cred = credentials.Certificate(service_account_key_path)
        firebase_admin.initialize_app(cred)

        print("Flutter has successfully sent POST data on the buy endpoint")
        data = json.loads(request.data)
        user_id = data.get('user_id')
        cosmetic_id = data.get('cosmetic_id')
        # Initialize Firestore database
        db = firestore.client()

        # Create or update the user document in Firestore
        user_ref = db.collection('users').document(user_id)

        try:
            doc = user_ref.get()
            if doc.exists:
                # Document data is stored in the to_dict() method
                data = doc.to_dict()
                inventory = dict(data.get('inventory'))

                if cosmetic := inventory.get(cosmetic_id):
                    cosmetic['equipped'] = False
                    inventory[cosmetic_id] = cosmetic
                    data['inventory'] = inventory
                    user_ref.update(data)
                else:
                    print(f"Cosmetic {cosmetic_id} does not exist.")
            else:
                print(f"Document {user_id} does not exist.")
        except Exception as e:
            print(f"An error occurred: {e}")

        firebase_admin.delete_app(firebase_admin.get_app())
        return jsonify({"message": "Ok"})


@app.route('/api/update_sensor', methods=['POST'])
def update_sensor():
    if request.method == "POST":

        current_directory = os.getcwd()
        service_account_key_path = os.path.join(current_directory, 'config', 'serviceAccountKey.json')

        # Initialize Firebase Admin SDK with the dynamically determined path
        cred = credentials.Certificate(service_account_key_path)
        firebase_admin.initialize_app(cred)

        print("Flutter has successfully sent POST data on the buy endpoint")
        data = json.loads(request.data)
        user_id = data.get('user_id')
        skill = data.get('skill')
        value = data.get('value')


        # Initialize Firestore database
        db = firestore.client()

        # Create or update the user document in Firestore
        user_ref = db.collection('users').document(user_id)

        try:
            doc = user_ref.get()
            if doc.exists:
                # Document data is stored in the to_dict() method
                data = doc.to_dict()
                skills = dict(data.get('skills'))

                if new_skill := skills.get(skill):
                    sensor = new_skill['assoc_sensor']
                    sensor['value'] = value
                    new_skill['assoc_sensor'] = sensor
                    skills[skill] = new_skill
                    data['skills'] = skills
                    user_ref.update(data)
                else:
                    print(f"Sensor or {skill} does not exist.")
            else:
                print(f"Document {user_id} does not exist.")
        except Exception as e:
            print(f"An error occurred: {e}")

        firebase_admin.delete_app(firebase_admin.get_app())
        return jsonify({"message": "Ok"})




if __name__ == '__main__':
    app.run(debug=True, host="0.0.0.0", port=5000)
