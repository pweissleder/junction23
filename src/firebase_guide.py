# pip install firebase-admin
# documentation https://firebase.google.com/docs/firestore/manage-data/add-data?hl=en
import os.path

import firebase_admin
from firebase_admin import credentials, firestore

cred = credentials.Certificate(os.path.join("C:/Users/breuer-l/Desktop/geheim/junction23-f7df7-firebase-adminsdk-c9vm7-257e9698f3.json"))

app = firebase_admin.initialize_app(cred)
database = firestore.client()

user_data = database.collection("users").document("zVymLJqktXglsdCK1DOt4miTPDO2")
