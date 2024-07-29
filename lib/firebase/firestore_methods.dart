
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dronaid_app/models/hospitalrequests.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> uploadRequest(
      String hospitalName,
      Uint8List? file,
      String emergencyText,
      String address,
      int priorityLevel,
      String userId,
      ) async {
    String res = "Error occurred";
    try {

      String requestId = const Uuid().v1();
      HospitalRequest request = HospitalRequest(
        hospitalName: hospitalName,
        address: address,
        emergencyText: emergencyText,
        requestId: requestId,
        dateTime: DateTime.now(),
        emergencyImage: file,
        priorityLevel: priorityLevel,
        userId: userId,
      );

      _firestore.collection('hospitalRequests').doc(requestId).set(request.toJson());
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<void> initializeFlags() async {
    try {
      DocumentReference droneReference = FirebaseFirestore.instance.collection('drone').doc('drone1');

      await droneReference.update({
        'orderFlag': -1,
        'droneFlag': 0,
        'servoFlag': 0,
      });
      print('Flags initialized successfully');
    } catch (e) {
      print('Error uploading flags: $e');
    }
  }

}