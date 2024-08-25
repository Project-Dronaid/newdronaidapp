import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dronaid_app/screens/FrequentlyAskedQ.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../utils/colors.dart';
import 'RequestHistory.dart';
import 'login/login.dart';

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
  User? currentUser; // Store the current user here

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      currentUser = FirebaseAuth.instance.currentUser; // Set currentUser here
      if (currentUser != null) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser!.uid)
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
        const SnackBar(
          content: Text('Failed to load profile data. Please try again.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            children: <Widget>[
              // Hospital Logo Section
              Image.asset(
                'assets/launcher_icon.png',
                height: 100,
                width: 100,
              ),

              const SizedBox(height: 16),

              // Hospital Name Section
              Text(
                hospitalName ?? 'Loading...',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: kPrimaryColor,
                ),
              ),

              const SizedBox(height: 24),

              // Hospital Information Card
              _buildInfoCard(
                icon: Icons.info_outline,
                title: 'Hospital Information',
                content: Column(
                  children: [
                    _buildInfoRow(
                        icon: Icons.location_on,
                        text: hospitalAddress ?? 'Loading...'),
                    const SizedBox(height: 8),
                    _buildInfoRow(
                        icon: Icons.phone,
                        text: hospitalNumber ?? 'Loading...'),
                    const SizedBox(height: 8),
                    _buildInfoRow(
                        icon: Icons.email, text: hospitalEmail ?? 'Loading...'),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Request History Card
              _buildInfoCard(
                icon: Icons.history,
                title: 'Request History',
                content: const Text(
                  'Tap to view request history',
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
                onTap: () {
                  if (currentUser != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RequestHistoryPage(),
                      ),
                    );
                  }
                },
              ),

              const SizedBox(height: 24),

              // FAQs Card
              _buildInfoCard(
                icon: Icons.help_outline,
                title: 'FAQs',
                content: const Text(
                  'Frequently Asked Questions',
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
                onTap: () {
                  if (currentUser != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FrequentlyAskedQ(),
                      ),
                    );
                  }
                },
              ),

              const SizedBox(height: 48),

              // Sign Out Button
              ElevatedButton.icon(
                onPressed: () async {
                  try {
                    await FirebaseAuth.instance.signOut();
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => LoginScreen()));
                  } catch (e) {
                    print('Error signing out: $e');
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Failed to sign out. Please try again.'),
                      ),
                    );
                  }
                },
                icon: const Icon(Icons.logout, color: Colors.white),
                label: const Text(
                  'Sign Out',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryColor,
                  minimumSize: const Size(200, 50),
                  elevation: 5,
                  side: const BorderSide(color: kPrimaryColor, width: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required Widget content,
    VoidCallback? onTap, // Add this parameter
  }) {
    return GestureDetector(
      onTap: onTap, // Use the onTap parameter
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 4,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, color: kPrimaryColor, size: 28),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: kPrimaryColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              content,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow({required IconData icon, required String text}) {
    return Row(
      children: [
        Icon(icon, color: kPrimaryColor),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }
}
