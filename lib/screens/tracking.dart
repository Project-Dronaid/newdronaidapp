import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_location/fl_location.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:location/location.dart';
import 'package:provider/provider.dart';

class Tracking extends StatefulWidget {
  const Tracking({super.key});

  @override
  State<Tracking> createState() => _TrackingState();
}

class _TrackingState extends State<Tracking> {
  GoogleMapController? _controller;
  BitmapDescriptor droneIcon = BitmapDescriptor.defaultMarker;
  Map? droneLiveLocation;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String? status;
  int? statusCode;

  double? droneLatitude;
  double? droneLongitude;
  double destinationLatitude = 0.0;
  double destinationLongitude = 0.0;

  Set<Marker> markers = {};
  List<LatLng> route = [];

  Future<bool> _checkAndRequestPermission({bool? background}) async {
    if (!await FlLocation.isLocationServicesEnabled) {
      // Location services is disabled.
      return false;
    }

    var locationPermission = await FlLocation.checkLocationPermission();
    if (locationPermission == LocationPermission.deniedForever) {
      // Location permission has been permanently denied.
      return false;
    } else if (locationPermission == LocationPermission.denied) {
      // Ask the user for location permission.
      locationPermission = await FlLocation.requestLocationPermission();
      if (locationPermission == LocationPermission.denied ||
          locationPermission == LocationPermission.deniedForever) {
        // Location permission has been denied.
        return false;
      }
    }

    // Location permission must always be granted (LocationPermission.always)
    // to collect location data in the background.
    if (background == true &&
        locationPermission == LocationPermission.whileInUse) {
      // Location permission must always be granted to collect location in the background.
      return false;
    }

    return true;
  }

  Location? _location;
  Future<void> getLocation() async {
    if (await _checkAndRequestPermission()) {
      final Duration timeLimit = const Duration(seconds: 10);
      await FlLocation.getLocation(timeLimit: timeLimit).then((location) {
        print('location: ${location.toJson().toString()}');
        _location = location;
        print(_location);
      }).onError((error, _) {
        print('error: ${error.toString()}');
      });
    }
    setState(() {});
  }



  Future<void> fetchDestination() async {
    try {
      DocumentSnapshot droneSnapshot = await firestore
          .collection('drone')
          .doc('drone1')
          .collection('location')
          .doc('destination')
          .get();
      if (droneSnapshot.exists) {
        final droneData = droneSnapshot.data() as Map<String, dynamic>;
        destinationLatitude = droneData['latitude'];
        destinationLongitude = droneData['longitude'];
      }
    } catch (e) {
      print("error");
    }
    markers.add(Marker(
      markerId: const MarkerId("Destination"),
      position: LatLng(destinationLatitude, destinationLongitude),
    ));
  }


  @override
  void initState() {

    super.initState();
    fetchDestination();
  }

  final Stream<DocumentSnapshot> _droneStream = FirebaseFirestore.instance
      .collection('drone')
      .doc('drone1')
      .collection('location')
      .doc('live_location')
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: const Text(
          "Delivery Status",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: (destinationLatitude == null || destinationLongitude == null)
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Stack(
              children: [
                StreamBuilder<DocumentSnapshot>(
                    stream: _droneStream,
                    builder: (BuildContext context, snapshot) {
                      final LatLng locationTrack = LatLng(
                          (snapshot.data!as dynamic)['latitude'],
                          (snapshot.data! as dynamic)['longitude']);
                      final LatLng destination =
                          LatLng(destinationLatitude, destinationLongitude);
                      List<LatLng> track = [locationTrack, destination];
                      // print(_droneStream);
                      if (snapshot.hasError) {
                        return const Text('Something went wrong');
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Text("Loading");
                      }
                      return GoogleMap(
                          initialCameraPosition: CameraPosition(
                            target: LatLng(
                              destinationLatitude,
                              destinationLongitude,
                            ),
                            zoom: 5,
                          ),
                          zoomControlsEnabled: false,
                          mapType: MapType.normal,
                          onMapCreated: (controller) {
                            setState(() {
                              _controller = controller;
                            });
                          },
                          markers: markers,
                          polylines: {
                            Polyline(
                                polylineId: const PolylineId("Live tracking"),
                                points: track,
                                zIndex: 5),
                          });
                    }),
                Positioned(
                  bottom: 0.0,
                  left: 0.0,
                  right: 0.0,
                  child: Container(
                    height: 250,
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.0),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          offset: Offset(0.0, 2.0),
                          blurRadius: 4.0,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'anything',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                ),
                              ),
                              InkWell(
                                highlightColor: Colors.redAccent,
                                onTap: () => {},
                                child: Container(
                                    padding: EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4.0),
                                      color: Colors.red,
                                    ),
                                    child: Text(
                                      "Cancel",
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    )),
                              ),

                              // Text('Delivery Status: $status'),
                              // SizedBox(height: 8.0),
                            ],
                          ),
                        ),

                        Container(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    // width: double.infinity,
                                    padding: const EdgeInsets.all(8),
                                    child: const Text(
                                      "ORDER TYPE:",
                                      style: TextStyle(fontSize: 15.0),
                                    ),
                                  ),
                                  Container(
                                    // width: double.infinity,
                                    // padding: const EdgeInsets.all(4),
                                    child: const Text(
                                      "Medicines",
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              Row(
                                children: [
                                  Container(
                                    // width: double.infinity,
                                    padding: const EdgeInsets.all(8),
                                    child: const Text(
                                      "DESTINATION ADDRESS:",
                                      style: TextStyle(fontSize: 15.0),
                                    ),
                                  ),
                                  Container(
                                    width: 150,
                                    child: Text(
                                      'address',
                                      // overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        overflow: TextOverflow.ellipsis,
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(16),
                          child: Center(
                            child: ElevatedButton.icon(
                              icon: const Icon(
                                Icons.phone_in_talk_sharp,
                                size: 20.0,
                                color: Colors.white,
                              ),
                              style: ElevatedButton.styleFrom(
                                  minimumSize: const Size(330, 60),
                                  elevation: 4,
                                  backgroundColor: const Color(0xFF8689C6),
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(60.0))),
                              onPressed: () {
                                debugPrint('pushed');
                              },
                              label: const Text(
                                'Call Support',
                                style: TextStyle(
                                    fontSize: 18, color: Colors.white),
                              ),
                            ),
                          ),
                        ),

                        // SizedBox(height: 8.0),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
