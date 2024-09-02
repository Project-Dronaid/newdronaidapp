import 'package:cloud_firestore/cloud_firestore.dart';

class User {
    final String emailresult;

  final String hospital_name;
  final String email;
  final String address;
  final String phone_no;
  final String uid;
  final String? deliveryAddress;
  final List<String>? tokens;  // Add the tokens field

  const User({
    required this.hospital_name,
          required this.emailresult,

    required this.email,
    required this.address,
    required this.phone_no,
    required this.uid,
    this.deliveryAddress,
    this.tokens,  // Initialize the tokens field
  });

  // Convert the User object to JSON
  Map<String, dynamic> toJson() => {
        "hospital_name": hospital_name,
        "email": email,
        "address": address,
        "phone_no": phone_no,
        "uid": uid,
                "emailresult": emailresult,

        "deliveryAddress": deliveryAddress,
        "tokens": tokens,  // Add tokens to the JSON map
      };

  // Convert a Firestore snapshot to a User object
  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return User(
      hospital_name: snapshot['hospital_name'],
      email: snapshot['email'],
      address: snapshot['address'],
              emailresult: snapshot['emailresult'],
      phone_no: snapshot['phone_no'],
      uid: snapshot['uid'],
      deliveryAddress: snapshot['deliveryAddress'],
      tokens: List<String>.from(snapshot['tokens'] ?? []),  // Parse tokens from snapshot
    );
  }
}
