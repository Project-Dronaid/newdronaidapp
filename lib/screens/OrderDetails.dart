import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dronaid_app/screens/home.dart';
import 'package:dronaid_app/screens/tracking.dart';
import 'package:dronaid_app/utils/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class OrderTrackingPage extends StatefulWidget {
  const OrderTrackingPage({super.key});

  @override
  _OrderTrackingPageState createState() => _OrderTrackingPageState();
}

class _OrderTrackingPageState extends State<OrderTrackingPage> {
  bool isMapVisible = true;
  BitmapDescriptor droneIcon = BitmapDescriptor.defaultMarker;
  Map<String, String?> droneDetails = {};

  @override
  void initState() {
    super.initState();
    _loadDroneDetails();
    WidgetsBinding.instance.addPostFrameCallback((_) {});
  }

  Future<void> _loadDroneDetails() async {
    final details = await fetchDroneDetails();
    setState(() {
      droneDetails = details;
    });
  }

  Future<Map<String, String?>> fetchDroneDetails() async {
    final firestore = FirebaseFirestore.instance;

    try {
      final altitudeDoc = await firestore
          .collection('drone')
          .doc('drone1')
          .collection('status')
          .doc('geo_coordinates')
          .get();

      final speedsDoc = await firestore
          .collection('drone')
          .doc('drone1')
          .collection('status')
          .doc('speeds')
          .get();

      final batteryDoc = await firestore
          .collection('drone')
          .doc('drone1')
          .collection('status')
          .doc('battery')
          .get();

      // Extracting, formatting, and adding units
      final altitude =
          (altitudeDoc.data()?['altitude'] as num?)?.toStringAsFixed(2);
      final groundSpeed =
          (speedsDoc.data()?['ground_speed'] as num?)?.toStringAsFixed(2);
      final airSpeed =
          (speedsDoc.data()?['air_speed'] as num?)?.toStringAsFixed(2);
      final battery = batteryDoc.data()?['level']?.toString();

      return {
        'altitude': altitude != null ? '$altitude m' : 'N/A',
        'groundSpeed': groundSpeed != null ? '$groundSpeed m/s' : 'N/A',
        'airSpeed': airSpeed != null ? '$airSpeed m/s' : 'N/A',
        'battery': battery != null
            ? '$battery%'
            : 'N/A', // Assuming battery level is in percentage
      };
    } catch (e) {
      print('Error fetching drone details: $e');
      return {
        'altitude': 'N/A',
        'groundSpeed': 'N/A',
        'airSpeed': 'N/A',
        'battery': 'N/A',
      };
    }
  }

  void toggleMapVisibility() {
    setState(() {
      isMapVisible = !isMapVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        leading: Padding(
          padding: const EdgeInsets.fromLTRB(10, 5, 5, 5),
          child: CircleAvatar(
            backgroundColor: Colors.white,
            child: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomePage(),
                  ),
                );
              },
              icon: Icon(Icons.arrow_back),
              color: Colors.black,
            ),
          ),
        ),
      ),
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(0.0),
            child: Tracking(),
          ),
          const Positioned(
            top: 30,
            right: 10,
            child: EstimatedTimeWidget(),
          ),
          DraggableScrollableSheet(
              initialChildSize: 0.3,
              minChildSize: 0.3,
              maxChildSize: 0.65,
              builder: (BuildContext context, scrollController) {
                return Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFEEEFF5),
                    borderRadius: BorderRadius.circular(16.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        spreadRadius: 1,
                        blurRadius: 10,
                        offset: const Offset(0, 3), // Position of shadow
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                      controller: scrollController,
                      child: OrderDetailsWidget(
                        droneAltitude: droneDetails['altitude'],
                        droneGspeed: droneDetails['groundSpeed'],
                        droneAspeed: droneDetails['airSpeed'],
                        droneBattery: droneDetails['battery'],
                      )),
                );
              })
        ],
      ),
    );
  }
}

class OrderDetailsWidget extends StatefulWidget {
  final String? droneAltitude;
  final String? droneGspeed;
  final String? droneAspeed;
  final String? droneBattery;

  const OrderDetailsWidget({
    super.key,
    this.droneAltitude,
    this.droneGspeed,
    this.droneAspeed,
    this.droneBattery,
  });

  @override
  State<OrderDetailsWidget> createState() => _OrderDetailsWidgetState();
}

class _OrderDetailsWidgetState extends State<OrderDetailsWidget> {
  String? address;
  String? emergencyText;
  bool isLoading = false;

  Future<void> requestDetails() async {
    setState(() {
      isLoading = true;
    });
    QuerySnapshot snap = await FirebaseFirestore.instance
        .collection('hospitalRequests')
        .where('receiverUid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where('status', isEqualTo: 'accepted')
        .get();

    DocumentSnapshot doc = snap.docs.first;
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    address = data['address'];
    emergencyText = data['emergencyText'];
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    requestDetails();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading == true
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 236, 237, 240),
              borderRadius: BorderRadius.circular(14.0),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: OrderTracking(),
                    ),
                    Divider(
                        height: 1, color: Color.fromARGB(255, 210, 205, 205)),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Arrival estimation',
                              style: TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.w900),
                            ),
                            SizedBox(height: 10),
                            Text(
                              '08:00 PM - 08:12 PM',
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Color.fromARGB(255, 122, 121, 121)),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: OutlinedButton(
                              onPressed: () {},
                              child: Text(
                                '23 Min',
                                style: TextStyle(color: Colors.black),
                              )),
                        )
                      ],
                    ),
                    SizedBox(height: 10),
                    Divider(
                        height: 1, color: Color.fromARGB(255, 210, 205, 205)),
                    SizedBox(height: 10),
                    Text(
                      'Address',
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
                    ),
                    SizedBox(height: 10),
                    Text(address!),
                    SizedBox(height: 10),
                    Divider(
                        height: 1, color: Color.fromARGB(255, 210, 205, 205)),
                    SizedBox(height: 10),
                    Text(
                      'Request Details',
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
                    ),
                    SizedBox(height: 10),
                    Text(emergencyText!), // fetch emergency controller
                    SizedBox(height: 10),
                    Divider(
                        height: 1, color: Color.fromARGB(255, 210, 205, 205)),
                    SizedBox(height: 10),
                    Text(
                      'Drone Details',
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 20),
                      child: OrderItemsTable(
                        droneAltitude: widget.droneAltitude,
                        droneGspeed: widget.droneGspeed,
                        droneAspeed: widget.droneAspeed,
                        droneBattery: widget.droneBattery,
                      ),
                    ),
                    Divider(
                        height: 1, color: Color.fromARGB(255, 210, 205, 205)),
                    SizedBox(height: 10),
                  ]),
            ),
          );
  }
}

class OrderItemsTable extends StatelessWidget {
  final String? droneAltitude;
  final String? droneGspeed;
  final String? droneAspeed;
  final String? droneBattery;

  const OrderItemsTable({
    super.key,
    this.droneAltitude,
    this.droneGspeed,
    this.droneAspeed,
    this.droneBattery,
  });

  @override
  Widget build(BuildContext context) {
    final List<OrderItem> items = [
      OrderItem(name: 'Altitude', details: droneAltitude ?? 'N/A'),
      OrderItem(name: 'Ground Speed', details: droneGspeed ?? 'N/A'),
      OrderItem(name: 'Air Speed', details: droneAspeed ?? 'N/A'),
      OrderItem(name: 'Battery', details: droneBattery ?? 'N/A'),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.89,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          // boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 10.0)]
        ),
        child: DataTable(
          columnSpacing: MediaQuery.of(context).size.width * 0.35,
          columns: [
            DataColumn(label: Text('Drone1')),
            DataColumn(label: Text('Details')),
          ],
          rows: items.map((item) {
            return DataRow(cells: [
              DataCell(Text(item.name)),
              DataCell(Text(item.details)),
            ]);
          }).toList(),
        ),
      ),
    );
  }
}

class OrderItem {
  final String name;
  final String details;

  OrderItem({required this.name, required this.details});
}

class GoogleMapWidget extends StatelessWidget {
  final Function onMapTap;

  GoogleMapWidget({super.key, required this.onMapTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onMapTap(),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(0.0),
        child: LayoutBuilder(
          builder: (context, constraints) => SizedBox(
            height: constraints.maxHeight * 0.71,
            child: GoogleMap(
              initialCameraPosition: const CameraPosition(
                target: LatLng(13.3524, 74.7868), // Example coordinates
                zoom: 10.0,
              ),
              markers: {
                const Marker(
                  markerId: MarkerId('deliveryLocation'),
                  position: LatLng(13.3524, 74.7868),
                ),
              },
              mapType: MapType.normal, // or MapType.satellite
              myLocationEnabled: true,
            ),
          ),
        ),
      ),
    );
  }
}

class EstimatedTimeWidget extends StatelessWidget {
  const EstimatedTimeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 236, 237, 240),
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 3), // Position of shadow
          ),
        ],
      ),
      child: const Column(
        children: [
          Text(
            'Estimated Time',
            style: TextStyle(fontSize: 13.0, color: Colors.grey),
          ),
          Text(
            '5-10 min',
            style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.black),
          ),
        ],
      ),
    );
  }
}

class OrderTracking extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TrackingStep(
              icon: Icons.shopping_bag,
              label: 'Request\nReceived',
              isActive: true,
            ),
            Expanded(
              child: Container(
                height: 1.0,
                color: Colors.grey,
              ),
            ),
            TrackingStep(
              icon: Icons.local_shipping,
              label: 'Delivery',
              isActive: false,
            ),
            Expanded(
              child: Container(
                height: 1.0,
                color: Colors.grey,
              ),
            ),
            TrackingStep(
              icon: Icons.emoji_emotions,
              label: 'Request\nDelivered',
              isActive: false,
            ),
          ],
        ),
      ],
    );
  }
}

class TrackingStep extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;

  TrackingStep(
      {required this.icon, required this.label, this.isActive = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              CircleAvatar(
                radius: 10,
                backgroundColor: Colors.white,
                child: Container(), // Empty container to ensure alignment
              ),
              CircleAvatar(
                radius: 5,
                backgroundColor: isActive ? Colors.red : Colors.grey,
              ),
            ],
          ),
          SizedBox(height: 10),
          Icon(
            icon,
            color: kPrimaryColor,
            size: 25,
          ),
          SizedBox(height: 5),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
