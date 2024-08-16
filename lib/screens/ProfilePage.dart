import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dronaid_app/screens/login/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import '../utils/colors.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? hospitalName;
  String? hospitalAddress;
  String? hospitalNumber;
  String? hospitalEmail;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users') // Assuming your collection is named 'users'
            .doc(user.uid)
            .get();

        setState(() {
          hospitalName = userDoc.get('hospital_name');
          hospitalAddress = userDoc.get('address');
          hospitalEmail = userDoc.get('email');
          hospitalNumber = userDoc.get('phone_no');
        });
      }
    } catch (e) {
      print('Error fetching user data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load profile data. Please try again.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      Center(
                        child: Material(
                          elevation: 10,
                          shape: CircleBorder(),
                          child: CircleAvatar(
                            radius: 40,
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),
              Text(
                hospitalName ??
                    'Loading...', // Display 'hospitalName' or a placeholder
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 24),
              Column(
                children: [
                  Card(
                    color: Colors.white,
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.local_hospital,
                                  color: Colors.blue, size: 28),
                              SizedBox(width: 8),
                              Text(
                                'Hospital Information',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Icon(Icons.location_on, color: Colors.grey[600]),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  hospitalAddress ?? 'Loading...',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[800],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(Icons.phone, color: Colors.grey[600]),
                              const SizedBox(width: 12),
                              Text(
                                hospitalNumber ?? 'Loading...',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[800],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(Icons.email, color: Colors.grey[600]),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  hospitalEmail ?? 'Loading...',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[800],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          const SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 48),
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        try {
                          await FirebaseAuth.instance.signOut();
                          // After signing out, navigate to the login screen
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginScreen()));
                        } catch (e) {
                          print('Error signing out: $e');
                          // Optionally, show an error message to the user
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content:
                                  Text('Failed to sign out. Please try again.'),
                            ),
                          );
                        }
                      },
                      icon: const Icon(
                        Icons.logout,
                        color: kPrimaryColor, // Red icon color to match the sign-out action
                      ),
                      label: const Text(
                        'Sign Out',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: kPrimaryColor, // Matching text color
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(
                            200, 40), // Adjusted size for better balance
                        backgroundColor: Colors.white, // White background
                        elevation:
                            5, // Maintain elevation for the raised effect
                        side: const BorderSide(
                            color: kPrimaryColor, width: 2), // Red border
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(14), // Rounded corners
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 24), // Increased padding
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
