import 'dart:typed_data';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user.dart' as model;

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot snap =
        await _firestore.collection('users').doc(currentUser.uid).get();

    return model.User.fromSnap(snap);
  }

  Future<String> signUpUser({
    required String email,
    required String password,
    required String address,
    required String hospital_name,
    required String phone_no,
  }) async {
    String res = "Some Error occured";
    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          hospital_name.isNotEmpty ||
          address.isNotEmpty ||
          phone_no.isNotEmpty) {
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        model.User user = model.User(
          hospital_name: hospital_name,
          uid: cred.user!.uid,
          email: email,
          address: address,
          phone_no: phone_no,
        );

        await _firestore
            .collection('users')
            .doc(cred.user!.uid)
            .set(user.toJson());

        res = "Success";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> loginUser(
      {required String email, required String password}) async {
    String res = 'Some error occurred';

    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        UserCredential cred = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        await saveLoginState(cred.user!.uid);
        res = 'Success';
      } else {
        res = 'Please enter all the fields';
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
    
  }
  

Future<void> saveLoginState(String userId) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('userId', userId);  // Save the user ID
  await prefs.setBool('isLoggedIn', true);  // Save login state
}


  Future<void> signOut() async {
    await _auth.signOut();

    await clearLoginState();
  }

  Future<void> clearLoginState() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn');
    await prefs.remove('userId');
  }

}
