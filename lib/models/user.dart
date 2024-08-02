import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String hospital_name;
  final String email;
  final String address;
  final String phone_no;
  final String uid;


  const User({
    required this.hospital_name,
    required this.email,
    required this.address,
    required this.phone_no,
    required this.uid
  });

  Map<String,dynamic> toJson() => {
    "hospital_name" : hospital_name,
    "email" : email,
    "address" : address,
    "phone_no" : phone_no,
    "uid" : uid,
  };

  static User fromSnap(DocumentSnapshot snap){
    var snapshot = snap.data() as Map<String, dynamic>;

    return User(
      hospital_name: snapshot['hospital_name'],
      email: snapshot['email'],
      address: snapshot['address'],
      phone_no: snapshot['phone_no'],
      uid: snapshot['uid'],
    );
  }
}
