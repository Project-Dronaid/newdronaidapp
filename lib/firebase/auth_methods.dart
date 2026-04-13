import 'dart:typed_data';

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

  Future<String> signUpUser(
      {required String email,
      required String password,
      required String address,
      required String emailresult,
      required String hospital_name,
      required String phone_no,
      String? deliveryAddress}) async {
    String res = "Some Error occured";
    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          hospital_name.isNotEmpty ||
          emailresult.isNotEmpty ||
          address.isNotEmpty ||
          phone_no.isNotEmpty) {
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        model.User user = model.User(
            hospital_name: hospital_name,
            uid: cred.user!.uid,
            email: email,
            emailresult: emailresult,
            address: address,
            phone_no: phone_no,
            deliveryAddress: deliveryAddress);

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
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = 'Success';
      } else {
        res = 'Please enter all the fields';
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
