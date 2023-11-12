import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:junction23/features/authentication/domain/user_model.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<UserModel?> signUpUser(String email, String password, String username,
    String age, String height, String weight, String gender) async {
  try {
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) async {
      UserModel userModel = UserModel(
          id: value.user!.uid,
          name: username,
          email: email,
          age: int.parse(age),
          height: double.parse(height),
          weight: double.parse(weight),
          gender: gender,
          coins: 0);
      await fetchDataFromServer(userModel);
    });
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      throw Exception('The password provided is too weak.');
    } else if (e.code == 'email-already-in-use') {
      throw Exception('The account already exists for that email.');
    }
  } catch (e) {
    throw Exception(e);
  }
  return null;
}

Future<void> fetchDataFromServer(UserModel userModel) async {
  final serverUrl = 'http://127.0.0.1:5000'; // Replace with your server's URL

  try {
    final response = await http.post(Uri.parse('$serverUrl/init_user'),
        body: userModel.toJson());

    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, parse the JSON data
      final data = jsonDecode(response.body);
      print('Received data: $data');
    } else {
      // If the server returns an error response, throw an exception
      throw Exception('Failed to load data from the server');
    }
  } catch (error) {
    // Handle any network or server errors
    print('Error: $error');
  }
}
