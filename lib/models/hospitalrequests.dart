import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';

class HospitalRequest {
  final String hospitalName;
  final String address;
  final DateTime dateTime;
  final String requestId;
  final String emergencyText;
  final Uint8List? emergencyImage;
  final int priorityLevel;
  final String userId;
  final String? status;

  const HospitalRequest(
      {required this.hospitalName,
      required this.address,
      required this.dateTime,
      required this.requestId,
      required this.userId,
      required this.emergencyText,
      required this.priorityLevel,
      this.emergencyImage,
      this.status});

  Map<String, dynamic> toJson() => {
        'hospitalName': hospitalName,
        'address': address,
        'dateTime': Timestamp.fromDate(dateTime),
        'requestId': requestId,
        'emergencyText': emergencyText,
        'emergencyImage': emergencyImage,
        'priorityLevel': priorityLevel,
        'userId': userId,
        'status': status,
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
      priorityLevel: snapshot['priorityLevel'],
      userId: snapshot['userId'],
      status: snapshot['status'],
    );
  }
}
