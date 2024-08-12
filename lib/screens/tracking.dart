import 'package:cloud_firestore/cloud_firestore.dart';
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

  Set<Marker> markers = {};
  List<LatLng> route = [];

  // Function to handle address selection, from map to hospital location textfield
  void handleAddressSelection(String address) {
    setState(() {
      selectedAddress = address;
    });

    // Navigate back to FetchedEmergency page with selected address
    Navigator.of(context).pop(selectedAddress);
  }

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
    if (background == true && locationPermission == LocationPermission.whileInUse) {
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
      .collection('location')
      .doc('live_location')
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return (destinationLatitude == null || destinationLongitude == null)
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : StreamBuilder<DocumentSnapshot>(
            stream: _droneStream,
            builder: (BuildContext context, snapshot) {
              List<LatLng> track = [];
              if (snapshot.hasError) {
                return const Text('Something went wrong');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Text("Loading");
              }

              if (snapshot.hasData) {
                final LatLng locationTrack = LatLng((snapshot.data! as dynamic)['latitude'],
                    (snapshot.data! as dynamic)['longitude']);
                final LatLng destination = LatLng(destinationLatitude!, destinationLongitude!);
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
                        polylineId: const PolylineId("Live tracking"), points: track, zIndex: 5),
                  });
            });
  }
}
