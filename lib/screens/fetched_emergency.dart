import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dronaid_app/firebase/notification_service.dart';

import 'package:dronaid_app/firebase/firestore_methods.dart';
import 'package:dronaid_app/screens/map_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:dronaid_app/utils/colors.dart';

class FetchedEmergency extends StatefulWidget {
  const FetchedEmergency({super.key});

  @override
  State<FetchedEmergency> createState() => _FetchedEmergencyState();
}

class _FetchedEmergencyState extends State<FetchedEmergency> {


  FirebaseMessaging _firebaseMessaging= FirebaseMessaging.instance;
  String? _token;

  NotificationService notificationService=NotificationService();


Future<String> loadServiceAccountJson() async {
  return await rootBundle.loadString('assets/keys/key.json');
}

Future<String> getAccessToken() async {
  // Load the service account JSON file
  String serviceAccountJson = await loadServiceAccountJson();
  
  // Parse the credentials and create an Auth client
  final accountCredentials = ServiceAccountCredentials.fromJson(serviceAccountJson);
  final scopes = ['https://www.googleapis.com/auth/firebase.messaging'];

  final authClient = await clientViaServiceAccount(accountCredentials, scopes);
  final accessToken = authClient.credentials.accessToken;

  return accessToken.data;
}

Future<void> sendNotification(String targetToken) async {
  // Get the access token
  String accessToken = await getAccessToken();
  
  // Define the FCM endpoint URL
  final url = Uri.parse('https://fcm.googleapis.com/v1/projects/dronaidapp-ce56e/messages:send');

  // Construct the notification payload
  final Map<String, dynamic> notification = {
    'message': {
      'token': targetToken,
      'notification': {
        'title': 'New Request',
        'body': 'You have received a request!',
      },
    },
  };

  // Send the notification
  final response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    },
    body: jsonEncode(notification),
  );
  
  // Handle the response
  if (response.statusCode == 200) {
    print('Notification sent successfully');
  } else {
    print('Failed to send notification');
    print('Status code: ${response.statusCode}');
    print('Response body: ${response.body}');
  }
}
 
 TextEditingController _emergencyController = TextEditingController();
  int selectedPriority = 0;
  String hospitalAddress = 'Loading...';
  String hospitalName = 'Loading...';
  bool _isEditing = false;
  TextEditingController _locationController = TextEditingController();
  String? selectedHospital;
  String senderToken='';
  List<String> hospitalNames = [];
  

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
        _fetchHospitalNames();
        _getToken();
  }

  void _getToken() async {
  User? user = FirebaseAuth.instance.currentUser;
  final userId = user?.uid;
  String? _token = await FirebaseMessaging.instance.getToken();

if (_token != null && userId != null) {
  // Set the token value directly
  await FirebaseFirestore.instance.collection('users').doc(userId).set({
    'token': _token // Store the single token value
  }, SetOptions(merge: true)); // Use merge: true to avoid overwriting other fields

  print('Token set in Firebase');
  print(_token);
}
}

   Future<void> _fetchUserDetails() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final userId = user.uid;
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .get();
        if (userDoc.exists) {
          setState(() {
            hospitalAddress =
                userDoc.data()?['address'] ?? 'No address available';
            _locationController.text =
                userDoc.data()?['address'] ?? 'No address available';
            hospitalName =
                userDoc.data()?['hospital_name'] ?? 'Unknown Hospital';
          });
        }
      } else {
        setState(() {
          hospitalAddress = 'User not logged in';
          hospitalName = 'Unknown Hospital';
        });
      }
    } catch (e) {
      print('Error fetching user details: $e');
      setState(() {
        hospitalAddress = 'Error fetching address';
        hospitalName = 'Error fetching hospital name';
      });
    }
  }

  Future<void> _fetchHospitalNames() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('users').get();

      List<String> hospitals = snapshot.docs
          .map((doc) => doc.data()['hospital_name'] as String)
          .where((name) => name != hospitalName)
          .toList();

      setState(() {
        hospitalNames = hospitals;
      });
    } catch (e) {
      print('Error fetching hospital names: $e');
    }
  }
   Future<void> _submitRequest() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        if (_emergencyController.text.isNotEmpty) {
          if (selectedPriority == 0) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Please select priority')),
            );
            return;
          }

          if (selectedHospital == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Please select the hospital')),
            );
            return;
          }

          final userId = user.uid;
          final requestId = FirebaseFirestore.instance
              .collection('hospitalRequests')
              .doc()
              .id;
          final dateTime = DateTime.now();

          // Fetch the userId of the selected hospital
          String? receiverUid;
          final querySnapshot = await FirebaseFirestore.instance
              .collection('users')
              .where('hospital_name', isEqualTo: selectedHospital)
              .get();

          if (querySnapshot.docs.isNotEmpty) {
            receiverUid = querySnapshot.docs.last
                .get('uid');
               senderToken= querySnapshot.docs.last.get('token');
                print(senderToken);
                if(senderToken==''){
                  print('no device associated');
                }else{
                await sendNotification(senderToken);
                }

          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Selected hospital not found')),
            );
            return;
          }
          final currentHospital = await FirebaseFirestore.instance
              .collection('users')
              .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
              .get();

          // Submit the request with the receiverUid included
          await FirebaseFirestore.instance
              .collection('hospitalRequests')
              .doc(requestId)
              .set({
            'address': hospitalAddress,
            'emergencyText': _emergencyController.text,
            'emergencyImage': '',
            'hospitalName': currentHospital.docs.last.get('hospital_name'),
            'priorityLevel': selectedPriority,
            'dateTime': dateTime,
            'requestId': requestId,
            'receiverUid': receiverUid, // Include receiverUid here
            'userId': userId,
            'status': 'pending',
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Request submitted successfully!')),
          );

          _emergencyController.clear();
          setState(() {
            selectedPriority = 0;
            FirebaseFirestore.instance
                .collection('drone')
                .doc('drone1')
                .update({'orderFlag': 0});
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Enter Emergency text')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User not logged in')),
        );
      }

    } catch (e) {
      print('Error submitting request: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error submitting request')),
      );
    }
  }

  void selectPriority(int index) {
    setState(() {
      selectedPriority = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: const Color(0xFFEEEFF5),
          // leading: const Icon(Icons.menu),
          title: const Text(
            'Home',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: IntrinsicHeight(
                    child: Column(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 1,
                          margin: EdgeInsets.all(18),
                          padding: EdgeInsets.only(
                              top: 10, left: 18, right: 10, bottom: 18),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15)),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Hospital Location:',
                                    style: TextStyle(
                                        fontSize: 17,
                                        color: kPrimaryColor,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  IconButton(
                                    onPressed: () async {
                                      final selectedAddress =
                                          await Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ConfirmDetails(),
                                        ),
                                      );

                                      if (selectedAddress != null) {
                                        setState(() {
                                          hospitalAddress = selectedAddress;
                                          _locationController.text =
                                              selectedAddress;
                                        });
                                      }
                                    },
                                    icon: Icon(
                                      _isEditing
                                          ? Icons.check
                                          : Icons.edit_outlined,
                                      size: 17,
                                      color: kPrimaryColor,
                                    ),
                                  )
                                ],
                              ),
                              _isEditing
                                  ? TextField(
                                      controller: _locationController,
                                      style: TextStyle(fontSize: 15),
                                      decoration: InputDecoration(
                                          border: InputBorder.none),
                                    )
                                  : Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        _locationController.text,
                                        style: TextStyle(fontSize: 15),
                                      ),
                                    ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Column(
                          children: [
                            Text(
                              'Emergency Help',
                              style: TextStyle(
                                  fontSize: 38,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF1D1D1D)),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              'Needed?',
                              style: TextStyle(
                                  fontSize: 38,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF1D1D1D)),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              'Enter Emergency details:',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.005,
                        ),
                        Container(
                          margin: EdgeInsets.all(18),
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.white),
                          child: TextField(
                            maxLines: 3,
                            controller: _emergencyController,
                            decoration: InputDecoration(
                              hintText: 'Example: O+ Blood needed',
                              contentPadding: EdgeInsets.all(10),
                              border: InputBorder.none,
                              suffixIcon: IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.photo_library_outlined),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.005,
                        ),
                        Text(
                          'Select Priority Level:',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            GestureDetector(
                              onTap: () => selectPriority(1),
                              child: Container(
                                height: 50,
                                width: 50,
                                child: Center(
                                    child: Text(
                                  '1',
                                  style: TextStyle(fontSize: 20),
                                )),
                                decoration: BoxDecoration(
                                    color: selectedPriority == 1
                                        ? Color(0xFFC3B1E1)
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(25),
                                    border: Border.all(
                                        color: kPrimaryColor, width: 2)),
                              ),
                            ),
                            GestureDetector(
                              onTap: () => selectPriority(2),
                              child: Container(
                                height: 50,
                                width: 50,
                                child: Center(
                                    child: Text(
                                  '2',
                                  style: TextStyle(fontSize: 20),
                                )),
                                decoration: BoxDecoration(
                                  color: selectedPriority == 2
                                      ? Color(0xFFC3B1E1)
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(25),
                                  border: Border.all(
                                      color: kPrimaryColor, width: 2),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () => selectPriority(3),
                              child: Container(
                                height: 50,
                                width: 50,
                                child: Center(
                                    child: Text(
                                  '3',
                                  style: TextStyle(fontSize: 20),
                                )),
                                decoration: BoxDecoration(
                                  color: selectedPriority == 3
                                      ? Color(0xFFC3B1E1)
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(25),
                                  border: Border.all(
                                      color: kPrimaryColor, width: 2),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: kPrimaryColor,
                              size: 20,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              'Higher the Priority Level, higher the actual priority',
                              style: TextStyle(fontWeight: FontWeight.w300),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.005,
                        ),
                        Container(
                          margin: EdgeInsets.all(18),
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.white),
                          child: DropdownButtonHideUnderline(
                            // Hide the underline
                            child: DropdownButton<String>(
                              dropdownColor: Colors.white,
                              value: selectedHospital,
                              hint: Center(child: Text('Select a hospital')),
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedHospital = newValue;
                                });
                              },
                              items: hospitalNames.map((String hospital) {
                                return DropdownMenuItem<String>(
                                  value: hospital,
                                  child: Center(
                                    child: Text(
                                      hospital,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                );
                              }).toList(),
                              isExpanded: true,
                              alignment: Alignment.center,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.005,
                        ),
                        GestureDetector(
                          onTap:  () async{
                            print(senderToken);
              
                            await _submitRequest();
                          },
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.065,
                            width: MediaQuery.of(context).size.width * 0.93,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: kPrimaryColor,
                            ),
                            child: Center(
                              child: Text(
                                'Submit Request',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}



 