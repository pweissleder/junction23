import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:junction23/features/authentication/domain/user_model.dart';

Future<UserModel?> signUpUser(
    String email, String password, String username) async {
  try {
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) async {
      await postDetailsToFirestore(
          UserModel(id: value.user!.uid, name: username, email: email),
          value.user!.uid);
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

Future postDetailsToFirestore(UserModel userModel, String uid) async {
  // add user to firestore
  await FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .set(userModel.toJson());
}
