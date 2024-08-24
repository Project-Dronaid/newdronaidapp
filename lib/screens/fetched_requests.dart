import 'package:dronaid_app/screens/OrderDetails.dart';
import 'package:dronaid_app/screens/request_confirmed_page.dart';
import 'package:dronaid_app/utils/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class FetchedRequests extends StatefulWidget {
  const FetchedRequests({super.key});

  @override
  State<FetchedRequests> createState() => _FetchedRequestsState();
}

class _FetchedRequestsState extends State<FetchedRequests> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? rid;

  Future<void> _rejectRequest(String requestId) async {
    try {
      final requestDoc =
      _firestore.collection('hospitalRequests').doc(requestId);

      // Fetch the request data
      final requestSnapshot = await requestDoc.get();
      if (requestSnapshot.exists) {
        final requestData = requestSnapshot.data() as Map<String, dynamic>;

        // Add to closedRequests collection
        await _firestore
            .collection('closedRequests')
            .doc(requestId)
            .set(requestData);

        // Delete from hospitalRequests collection
        await requestDoc.delete();
      }
    } catch (e) {
      // Handle any errors
      print('Error rejecting request: $e');
    }
  }

  Future<void> _acceptRequest(String requestId) async {
    try {
      final requestDoc =
      _firestore.collection('hospitalRequests').doc(requestId);

      // Fetch the request data
      final requestSnapshot = await requestDoc.get();
      if (requestSnapshot.exists) {
        final requestData = requestSnapshot.data() as Map<String, dynamic>;

        // Add to closedRequests collection with an updated status
        await _firestore.collection('closedRequests').doc(requestId).set({
          ...requestData,
          'status': 'accepted', // Add status field
        });
        await _firestore.collection('hospitalRequests').doc(requestId).set({
          ...requestData,
          'status': 'accepted', // Add status field
        });

        // Delete from hospitalRequests collection
        // await requestDoc.delete();
        setState(() {
          FirebaseFirestore.instance
              .collection('drone')
              .doc('drone1')
              .update({'orderFlag': 1});
        });
      }
    } catch (e) {
      // Handle any errors
      print('Error accepting request: $e');
    }
  }
  void _deleteRequest(BuildContext context, String requestId){
    showDialog(context: context, builder: (BuildContext context){
      return AlertDialog(
        title: Text('Delete Request'),
        content: Text('Are you sure you want to delete this request?'),
        actions: [
          TextButton(
              onPressed: (){
                Navigator.of(context).pop();

              }, child: Text('Cancel')),
          TextButton(onPressed: ()async{
            try{
              DocumentReference originalDocRef= _firestore.collection('hospitalRequests').doc(requestId);

              //Retrieve the document data
              DocumentSnapshot originalDocSnapshot = await originalDocRef.get();
              if(originalDocSnapshot.exists){
                //get the document data
                Map<String,dynamic> data = originalDocSnapshot.data() as Map<String,dynamic>;

                data['status']='rejected';
                //write the data to the new collection
                DocumentReference newDocRef = _firestore.collection('closedRequests').doc(requestId);
                await newDocRef.set(data);
                await FirebaseFirestore.instance
                    .collection('hospitalRequests') // Collection name
                    .doc(requestId) // Document ID
                    .delete();

                print('Document moves sucessfully!');
              }
              else{
                print('Document does not exist');
              }
            }
            catch(e){
              print('Error moving request: $e');
            }
            Navigator.of(context).pop();
          }, child: Text('Delete'))
        ],
      );
    });

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
              Tab(
                text: 'Active Requests',
              ),
              Tab(
                text: 'Closed Requests',
              )
            ],
          ),
        ),
        body: TabBarView(children: [
          // Active Requests Tab
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                StreamBuilder<QuerySnapshot>(
                  stream: _firestore
                      .collection('hospitalRequests')
                      .orderBy('priorityLevel',
                      descending: true) // Order by priority level
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (!snapshot.hasData) {
                      return Center(child: Text('No Active Requests Found'));
                    }

                    final requests = snapshot.data!.docs;

                    return Column(
                      children: requests.map((doc) {
                        final data = doc.data() as Map<String, dynamic>;
                        final requestId=data['requestId'];
                        final hospitalName = data['hospitalName'] ?? 'Unknown';
                        final Timestamp? timestamp =
                        data['dateTime'] as Timestamp?;
                        final String dateTime = timestamp != null
                            ? DateFormat('hh:mma, dd MMMM')
                            .format(timestamp.toDate())
                            : 'Unknown Date';

                        final emergencyText =
                            data['emergencyText'] ?? 'Unknown';

                        return data['userId'] !=
                            FirebaseAuth.instance.currentUser!.uid &&
                            data['receiverUid'] ==
                                FirebaseAuth.instance.currentUser!.uid
                            ? Container(
                          margin: EdgeInsets.all(15),
                          padding: EdgeInsets.all(10),
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
                                  CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        'https://images.unsplash.com/photo-1596541223130-5d31a73fb6c6?w=800&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTR8fGhvc3BpdGFsJTIwYnVpbGRpbmd8ZW58MHx8MHx8fDA%3D'),
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Text(

                                    hospitalName,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15),
                                  ),
                                  Spacer(),
                                  Text(
                                    dateTime,
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w300),
                                  ),
                                  PopupMenuButton<String>(
                                    color: const Color(0xFFEEEFF5),
                                      icon: Icon(Icons.more_vert),
                                      onSelected: (value ){
                                        if(value == 'delete'){
                                          //handle the fucking delete option
                                          _deleteRequest(context,requestId );
                                        }
                                      },
                                      itemBuilder:(BuildContext context){
                                        return[
                                          PopupMenuItem<String>(
                                              value: 'delete',
                                              child: Text('Delete Request'))
                                        ];
                                      } )
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 46,
                                    right: 10,
                                    bottom: 5,
                                    top: 10),
                                child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(emergencyText)),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Divider(),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceEvenly,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      final requestId =
                                          doc.id; // Get the document ID
                                      _acceptRequest(requestId);
                                      rid = requestId;
                                      print(requestId);
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  RequestConfirmedPage(requestId: requestId,)));
                                    },
                                    child: Center(
                                      child: Container(
                                        width: MediaQuery.of(context)
                                            .size
                                            .width *
                                            0.83,
                                        height: MediaQuery.of(context)
                                            .size
                                            .height *
                                            0.05,
                                        padding: EdgeInsets.all(10),
                                        margin: EdgeInsets.symmetric(
                                            vertical: 10),
                                        decoration: BoxDecoration(
                                            color: kPrimaryColor,
                                            borderRadius:
                                            BorderRadius.circular(
                                                10)),
                                        child: Center(
                                          child: Text(
                                            'Accept Request',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight:
                                                FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        )
                            : Container(
                          width: 0,
                          height: 0,
                        );
                      }).toList(),
                    );
                  },
                ),
              ],
            ),
          ),
          // Closed Requests Tab
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                StreamBuilder<QuerySnapshot>(
                  stream: _firestore
                      .collection('hospitalRequests')
                      .where('status' , isEqualTo: 'ongoing')
                      .snapshots(),

                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (!snapshot.hasData) {
                      return Center(child: Text('No Closed Requests Found'));
                    }

                    final requests = snapshot.data!.docs;

                    return Column(
                      children: requests.map((doc) {
                        final data = doc.data() as Map<String, dynamic>;
                        final hospitalName = data['hospitalName'] ?? 'Unknown';
                        final Timestamp? timestamp =
                        data['dateTime'] as Timestamp?;
                        final String dateTime = timestamp != null
                            ? DateFormat('hh:mma, dd MMMM')
                            .format(timestamp.toDate())
                            : 'Unknown Date';

                        final emergencyText =
                            data['emergencyText'] ?? 'Unknown';
                        final status = data['status'] ?? 'Unknown';
                        
                        return data['userId'] !=
                            FirebaseAuth.instance.currentUser!.uid &&
                            data['receiverUid'] ==
                                FirebaseAuth.instance.currentUser!.uid
                            ?
                        Container(
                          margin: EdgeInsets.all(15),
                          padding: EdgeInsets.all(10),
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
                                  CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        'https://images.unsplash.com/photo-1596541223130-5d31a73fb6c6?w=800&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTR8fGhvc3BpdGFsJTIwYnVpbGRpbmd8ZW58MHx8MHx8fDA%3D'),
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Text(
                                    hospitalName,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15),
                                  ),
                                  Spacer(),
                                  Text(
                                    dateTime,
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w300),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 46, right: 10, bottom: 5, top: 10),
                                child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(emergencyText)),
                              ),
                              Divider(),
                              SizedBox(
                                height: 8,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              OrderTrackingPage()));
                                },
                                child: Center(
                                  child: Container(
                                    width: MediaQuery.of(context)
                                        .size
                                        .width *
                                        0.83,
                                    height: MediaQuery.of(context)
                                        .size
                                        .height *
                                        0.05,
                                    padding: EdgeInsets.all(10),
                                    margin: EdgeInsets.symmetric(
                                        vertical: 10),
                                    decoration: BoxDecoration(
                                        color: kPrimaryColor,
                                        borderRadius:
                                        BorderRadius.circular(
                                            10)),
                                    child: Center(
                                      child: Text(
                                        'Track Order',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight:
                                            FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ): Container(
                          width: 0,
                          height: 0,
                        );

                      }).toList(),
                    );
                  },
                ),
                StreamBuilder<QuerySnapshot>(
                  stream: _firestore
                      .collection('closedRequests')
                      .orderBy('priorityLevel',
                      descending: true) // Order by priority level
                      .snapshots(),

                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (!snapshot.hasData) {
                      return Center(child: Text('No Closed Requests Found'));
                    }

                    final requests = snapshot.data!.docs;

                    return Column(
                      children: requests.map((doc) {
                        final data = doc.data() as Map<String, dynamic>;
                        final hospitalName = data['hospitalName'] ?? 'Unknown';
                        final Timestamp? timestamp =
                        data['dateTime'] as Timestamp?;
                        final String dateTime = timestamp != null
                            ? DateFormat('hh:mma, dd MMMM')
                            .format(timestamp.toDate())
                            : 'Unknown Date';

                        final emergencyText =
                            data['emergencyText'] ?? 'Unknown';
                        final status = data['status'] ?? 'Unknown';

                        return data['userId'] !=
                            FirebaseAuth.instance.currentUser!.uid &&
                            data['receiverUid'] ==
                                FirebaseAuth.instance.currentUser!.uid
                            ?
                        Container(
                          margin: EdgeInsets.all(15),
                          padding: EdgeInsets.all(10),
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
                                  CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        'https://images.unsplash.com/photo-1596541223130-5d31a73fb6c6?w=800&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTR8fGhvc3BpdGFsJTIwYnVpbGRpbmd8ZW58MHx8MHx8fDA%3D'),
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Text(
                                    hospitalName,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15),
                                  ),
                                  Spacer(),
                                  Text(
                                    dateTime,
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w300),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 46, right: 10, bottom: 5, top: 10),
                                child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(emergencyText)),
                              ),
                              Divider(),
                              SizedBox(
                                height: 8,
                              ),
                              Text(
                                status == 'accepted'
                                    ? 'Request was accepted'
                                    : 'Request was rejected',
                                style: TextStyle(
                                  color: status == 'accepted'
                                      ? Colors.green
                                      : Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ): Container(
                          width: 0,
                          height: 0,
                        );

                      }).toList(),
                    );
                  },
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}