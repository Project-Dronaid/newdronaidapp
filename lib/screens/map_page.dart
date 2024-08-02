import 'dart:convert';

import 'package:dronaid_app/firebase/firestore_methods.dart';
import 'package:fl_location/fl_location.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;



class ConfirmDetails extends StatefulWidget {
  const ConfirmDetails({super.key});
  // static const String routeName = "confirm-details";

  @override
  State<ConfirmDetails> createState() => _ConfirmDetailsState();
}

class _ConfirmDetailsState extends State<ConfirmDetails> {
  // LocationData? locationData;
  Set<Marker> markers = {};
  LatLng? confirmDestination;
  double? destinationLatitude;
  double? destinationLongitude;
  String locationAddress = "";
  Location? _location;

  bool _serviceEnabled = false;

  // Future<void> getCurrentLocation() async {
  //   Location location = Location();
  //   await location.getLocation().then((location) => currentLocation = location);
  //
  //   // markers.add(
  //   //   Marker(
  //   //     markerId: const MarkerId("Destination"),
  //   //     position:
  //   //         LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
  //   //   ),
  //   // );
  //   await getAddress(currentLocation!.latitude!, currentLocation!.longitude!);
  //
  //   setState(() {});
  // }

  // https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$apiKey'

  // Future<void> getCurrentLocation() async {
  //   Location location = Location();
  //   PermissionStatus _permissionGranted;
  //
  //   _serviceEnabled = await location.serviceEnabled();
  //   if (!_serviceEnabled) {
  //     _serviceEnabled = await location.requestService();
  //     if (!_serviceEnabled) {
  //       return;
  //     }
  //   }
  //   // print(_serviceEnabled);
  //
  //   _permissionGranted = await location.hasPermission();
  //   if (_permissionGranted == PermissionStatus.denied) {
  //     _permissionGranted = await location.requestPermission();
  //     if (_permissionGranted != PermissionStatus.granted) {
  //       return;
  //     }
  //   }
  //   // print(_permissionGranted);
  //
  //
  //   locationData = await location.getLocation();
  //   print(locationData);
  //
  //
  // }

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
      await getAddress(_location!.latitude, _location!.longitude);
    }
  }

  Future<void> getAddress(double latitude, double longitude) async {
    String key = "AIzaSyC1_U9ZJk98Su3FtNnSpnKeIJpTPEai06M";
    http.Response res = await http.get(Uri.parse(
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=$key"));
    var data = res.body.toString();

    print(data);
    setState(() {
      locationAddress = jsonDecode(data)["results"][0]["formatted_address"];
      print(locationAddress);
      FirestoreMethods().getLatLong(locationAddress);
      confirmDestination =
          LatLng(latitude, longitude);
    });
  }

  @override
  void initState() {
    super.initState();
    getLocation();
  }

  @override
  Widget build(BuildContext context) {
    // final cart = Provider.of<Cart>(context);

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: const Text(
          "Enter Address",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body:
      (_location == null)
          ? const Center(
        child: CircularProgressIndicator(),
      )
      :Stack(
        children: [
          GoogleMap(
            mapType: MapType.hybrid,
            onTap: (LatLng destination) {
              setState(() {
                destinationLongitude = destination.longitude;
                destinationLatitude = destination.latitude;
                confirmDestination = destination;
                getAddress(destination.latitude, destination.longitude);
                markers.clear;
                markers.add(
                  Marker(
                    markerId: const MarkerId("Destination"),
                    position: destination,
                    icon: BitmapDescriptor.defaultMarker,
                  ),
                );
              });
            },
            myLocationEnabled: true,
            initialCameraPosition: CameraPosition(
              target: LatLng(
                _location!.latitude,
                _location!.longitude,
              ),
              zoom: 15,
            ),
            markers: markers,
           ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 260,
              padding: EdgeInsets.symmetric(
                horizontal: 16,
              ),
              decoration: BoxDecoration(
                color: Color.fromRGBO(245, 238, 248, 0.8),
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
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  DecoratedBox(
                    decoration: BoxDecoration(),
                    child: Text(
                      "Delivering at:",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      locationAddress,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white60,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        child: Center(
                          child: ElevatedButton.icon(
                            icon: const Icon(
                              Icons.location_on_outlined,
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
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) => RazorPayClass(
                              //       Amount: (cart.totalAmount).round(),
                              //       destination: confirmDestination,
                              //       address: locationAddress,
                              //     ),
                              //   ),
                              // );
                            },
                            label: const Text(
                              'Confirm Location',
                              style: TextStyle(
                                  fontSize: 18, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}