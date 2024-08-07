import 'package:cloud_firestore/cloud_firestore.dart';
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
  TextEditingController _emergencyController = TextEditingController();
  int selectedPriority = 0;
  String hospitalAddress = 'Loading...';
  String hospitalName = 'Loading...';
  bool _isEditing = false;
  TextEditingController _locationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
  }

  Future<void> _fetchUserDetails() async {
    try {
      // Get the current user
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final userId = user.uid;

        // Fetch user document from Firestore
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
      // FirestoreMethods().getLatLong(hospitalAddress);
    } catch (e) {
      print('Error fetching user details: $e');
      setState(() {
        hospitalAddress = 'Error fetching address';
        hospitalName = 'Error fetching hospital name';
      });
    }
  }

  Future<void> _submitRequest() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        if(_emergencyController.text.isNotEmpty){
          if(selectedPriority == 0){
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Please select priority')),
            );
            return;
          }

          final userId = user.uid;
          final requestId =
              FirebaseFirestore.instance.collection('hospitalRequests').doc().id;
          final dateTime = DateTime.now();

          await FirebaseFirestore.instance
              .collection('hospitalRequests')
              .doc(requestId)
              .set({
            'address': hospitalAddress,
            'emergencyText': _emergencyController.text,
            'emergencyImage':
            '', // Assuming no image is attached; handle this accordingly
            'hospitalName': hospitalName,
            'priorityLevel': selectedPriority,
            'dateTime': dateTime,
            'requestId': requestId,
            'userId': userId,
            'status': 'pending',
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Request submitted successfully!')),
          );

          // Optionally, clear the input fields or navigate to another screen
          _emergencyController.clear();
          setState(() {
            selectedPriority = 0;
            FirebaseFirestore.instance
                .collection('drone')
                .doc('drone1')
                .update({'orderFlag': 0});
          });
        }else{
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
    return Scaffold(
      backgroundColor: const Color(0xFFEEEFF5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFEEEFF5),
        leading: const Icon(Icons.menu),
        title: const Text(
          'Home',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 1,
            margin: EdgeInsets.all(18),
            padding: EdgeInsets.only(top: 10, left: 18, right: 10, bottom: 18),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(15)),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Hospital Location:',
                      style: TextStyle(
                          fontSize: 17,
                          color: kPrimaryColor,
                          fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          // _isEditing = !_isEditing;
                          // FirestoreMethods().getLatLong(_locationController.text);
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => ConfirmDetails() ));
                        });
                      },
                      icon: Icon(
                        _isEditing ? Icons.check :Icons.edit_outlined,
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
                    border: InputBorder.none
                  ),
                )
                    : Text(
                  _locationController.text,
                  style: TextStyle(fontSize: 15),
                ),
                // Text(
                //   _locationController.text,
                //   style: TextStyle(
                //     fontSize: 15,
                //   ),
                // ),
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
          const SizedBox(
            height: 10,
          ),
          Container(
            margin: EdgeInsets.all(18),
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15), color: Colors.white),
            child: TextField(
              maxLines: 4,
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
            height: MediaQuery.of(context).size.height*0.01,
          ),
          Text(
            'Select Priority Level:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          SizedBox(
            height: 30,
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
                      border: Border.all(color: kPrimaryColor, width: 2)),
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
                    border: Border.all(color: kPrimaryColor, width: 2),
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
                      border: Border.all(color: kPrimaryColor, width: 2)),
                ),
              )
            ],
          ),
          SizedBox(
            height: 15,
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
          Spacer(),
          GestureDetector(
            onTap: _submitRequest,
            child: Container(
              margin: EdgeInsets.only(left: 18, right: 18, bottom: 20,),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                  color: kPrimaryColor,
                  borderRadius: BorderRadius.circular(10)),
              child: const Center(
                  child: Text(
                'Submit Request',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              )),
            ),
          )
        ],
      ),
    );
  }
}
