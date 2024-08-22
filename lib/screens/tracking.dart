import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dronaid_app/screens/request_delivered_page.dart';
import 'package:dronaid_app/utils/colors.dart';
import 'package:fl_location/fl_location.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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
  String selectedAddress = '';

  double? droneLatitude;
  double? droneLongitude;
  double? destinationLatitude;
  double? destinationLongitude;
  int? droneFlag;
  int? orderFlag;
  int? servoFlag;

  Set<Marker> markers = {};
  List<LatLng> route = [];

  void handleAddressSelection(String address) {
    setState(() {
      selectedAddress = address;
    });
    Navigator.of(context).pop(selectedAddress);
  }

  Future<bool> _checkAndRequestPermission({bool? background}) async {
    if (!await FlLocation.isLocationServicesEnabled) {
      return false;
    }

    var locationPermission = await FlLocation.checkLocationPermission();
    if (locationPermission == LocationPermission.deniedForever) {
      return false;
    } else if (locationPermission == LocationPermission.denied) {
      locationPermission = await FlLocation.requestLocationPermission();
      if (locationPermission == LocationPermission.denied ||
          locationPermission == LocationPermission.deniedForever) {
        return false;
      }
    }

    if (background == true &&
        locationPermission == LocationPermission.whileInUse) {
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
        setState(() {});
      }
    } catch (e) {
      print("error");
    }
    markers.add(Marker(
      markerId: const MarkerId("Destination"),
      position: LatLng(destinationLatitude!, destinationLongitude!),
    ));
  }

  void addCustomIcon() {
    BitmapDescriptor.asset(
      ImageConfiguration(),
      "assets/drone_small.png",
      width: 32,
      height: 32,
    ).then((icon) => droneIcon = icon);
  }

  @override
  void initState() {
    super.initState();
    fetchDestination();
    addCustomIcon();
  }

  final Stream<DocumentSnapshot> _droneStream = FirebaseFirestore.instance
      .collection('drone')
      .doc('drone1')
      .collection('status')
      .doc('geo_coordinates')
      .snapshots();

  final Stream<DocumentSnapshot> _flagStream =
  FirebaseFirestore.instance.collection('drone').doc('drone1').snapshots();

  @override
  Widget build(BuildContext context) {
    return (destinationLatitude == null || destinationLongitude == null)
        ? const Center(
      child: CircularProgressIndicator(),
    )
        : StreamBuilder<DocumentSnapshot>(
        stream: _flagStream,
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading");
          }

          if (snapshot.hasData) {
            droneFlag = snapshot.data!['droneFlag'];
            orderFlag = snapshot.data!['orderFlag'];
            servoFlag = snapshot.data!['servoFlag'];
          }

          if (droneFlag == 3) {
            Future.microtask(() {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) =>  RequestDeliveredPage(),
                ),
              );
            });
            return Container();
          }

          return droneFlag == 1 || droneFlag == 2
              ? StreamBuilder<DocumentSnapshot>(
              stream: _droneStream,
              builder: (BuildContext context, snapshot) {
                List<LatLng> track = [];
                if (snapshot.hasError) {
                  return const Text('Something went wrong');
                }

                if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Text("Loading");
                }

                if (snapshot.hasData) {
                  final LatLng locationTrack = LatLng(
                      (snapshot.data! as dynamic)['latitude'],
                      (snapshot.data! as dynamic)['longitude']);
                  final LatLng destination = LatLng(
                      destinationLatitude!, destinationLongitude!);
                  track = [locationTrack, destination];
                  markers.add(Marker(
                    markerId: const MarkerId("Drone"),
                    icon: droneIcon,
                    position: locationTrack,
                  ));
                }
                return GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: LatLng(
                        destinationLatitude!,
                        destinationLongitude!,
                      ),
                      zoom: 13,
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
                          zIndex: 5,
                          color: kPrimaryColor),
                    });
              })
              : Container();
        });
  }
}
