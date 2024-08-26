import 'package:dronaid_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RequestHistoryPage extends StatefulWidget {
  const RequestHistoryPage({super.key});

  @override
  State<RequestHistoryPage> createState() => _RequestHistoryPageState();
}

class _RequestHistoryPageState extends State<RequestHistoryPage> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;

  String? hospitalName;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchHospitalName();
  }

  Future<void> _fetchHospitalName() async {
    final User? user = _auth.currentUser;
    if (user != null) {
      try {
        final DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(user.uid).get();

        setState(() {
          hospitalName = userDoc['hospitalName'];
          isLoading = false;
        });
      } catch (e) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFFEEEFF5),
        appBar: AppBar(
          backgroundColor: const Color(0xFFEEEFF5),
          title: const Text(
            'Requests',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Requests Sent'),
              Tab(text: 'Requests Received'),
            ],
          ),
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : TabBarView(
                children: [
                  _buildRequestList(active: true),
                  _buildRequestList(active: false),
                ],
              ),
      ),
    );
  }

  Widget _buildRequestList({required bool active}) {
    return SingleChildScrollView(
      child: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('closedRequests').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                active
                    ? 'No Requests Sent Found'
                    : 'No Requests Received Found',
              ),
            );
          }

          final String currentUserId = _auth.currentUser?.uid ?? '';
          final requests = snapshot.data!.docs.where((doc) {
            final data = doc.data() as Map<String, dynamic>;
            final matches = active
                ? data['userId'] == currentUserId
                : data['receiverUid'] == currentUserId;
            print("Document ID: ${doc.id}, matches: $matches, data: $data");
            return matches;
          }).toList();

          if (requests.isEmpty) {
            return Center(
              child: Text(
                active
                    ? 'No Requests Sent Found'
                    : 'No Requests Received Found',
              ),
            );
          }

          return Column(
            children: requests.map((doc) {
              final data = doc.data() as Map<String, dynamic>;
              final hospitalName = data['hospitalName'] ?? 'Unknown';
              final Timestamp? timestamp = data['dateTime'] as Timestamp?;
              final String dateTime = timestamp != null
                  ? DateFormat('hh:mma, dd MMMM').format(timestamp.toDate())
                  : 'Unknown Date';
              final emergencyText = data['emergencyText'] ?? 'Unknown';
              final status = data['status'] ?? 'Unknown';
              final receiverUid = data['receiverUid'] ?? '';

              return FutureBuilder<DocumentSnapshot>(
                future: _firestore.collection('users').doc(receiverUid).get(),
                builder: (context, userSnapshot) {
                  if (userSnapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final String receiverHospitalName =
                      userSnapshot.data?.get('hospital_name') ?? 'Unknown';

                  return InkWell(
                    onTap: () {
                      // Handle tap event if necessary
                    },
                    child: Container(
                      margin: const EdgeInsets.all(15),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: Colors.transparent,
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const CircleAvatar(
                                backgroundImage: NetworkImage(
                                    'https://images.unsplash.com/photo-1596541223130-5d31a73fb6c6?w=800&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTR8fGhvc3BpdGFsJTIwYnVpbGRpbmd8ZW58MHx8MHx8fDA%3D'),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                hospitalName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                dateTime,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 46, right: 10, bottom: 5, top: 10),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(emergencyText),
                            ),
                          ),
                          const SizedBox(height: 5),
                          const Divider(),
                          Text(
                            active
                                ? 'Sent to $receiverHospitalName'
                                : status == 'completed'
                                    ? 'Request was completed'
                                    : 'Request was rejected',
                            style: TextStyle(
                              color: active
                                  ? kPrimaryColor
                                  : status == 'completed'
                                      ? Colors.green
                                      : Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
