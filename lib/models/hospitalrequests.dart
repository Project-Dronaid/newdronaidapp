import 'package:cloud_firestore/cloud_firestore.dart';

class HospitalRequest {
  final String hospitalName;
  final String address;
  final DateTime dateTime;
  final String requestId;
  final String emergencyText;
  final String? emergencyImage;

  const HospitalRequest({
    required this.hospitalName,
    required this.address,
    required this.dateTime,
    required this.requestId,
    required this.emergencyText,
    this.emergencyImage,
  });


  Map<String, dynamic> toJson() => {
    'hospitalName': hospitalName,
    'address': address,
    'dateTime': Timestamp.fromDate(dateTime),
    'requestId': requestId,
    'emergencyText': emergencyText,
    'emergencyImage': emergencyImage,
  };


  static HospitalRequest fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return HospitalRequest(
      hospitalName: snapshot['hospitalName'],
      address: snapshot['address'],
      dateTime: (snapshot['dateTime'] as Timestamp).toDate(),
      requestId: snapshot['requestId'],
      emergencyText: snapshot['emergencyText'],
      emergencyImage: snapshot['emergencyImage'],
    );
  }
}
