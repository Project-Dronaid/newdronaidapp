


import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fl_location/fl_location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class ConfirmDetails extends StatefulWidget {
  const ConfirmDetails({Key? key}) : super(key: key);

  @override
  State<ConfirmDetails> createState() => _ConfirmDetailsState();
}

class _ConfirmDetailsState extends State<ConfirmDetails> {
  Set<Marker> markers = {};
  LatLng? confirmDestination;
  double? destinationLatitude;
  double? destinationLongitude;
  String locationAddress = "";
  Location? _location;

  bool _serviceEnabled = false;

  Future<bool> _checkAndRequestPermission({bool? background}) async {
    if (!await FlLocation.isLocationServicesEnabled) {
      return false;
    }

    var locationPermission = await FlLocation.checkLocationPermission();
    if (locationPermission == LocationPermission.deniedForever) {
      return false;
    } else if (locationPermission == LocationPermission.denied) {
      locationPermission = await FlLocation.requestLocationPermission();
      if (locationPermission == LocationPermission.denied || locationPermission == LocationPermission.deniedForever) {
        return false;
      }
    }

    if (background == true && locationPermission == LocationPermission.whileInUse) {
      return false;
    }

    return true;
  }

  Future<void> getLocation() async {
    if (await _checkAndRequestPermission()) {
      final Duration timeLimit = const Duration(seconds: 10);
      await FlLocation.getLocation(timeLimit: timeLimit).then((location) {
        _location = location;
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

    setState(() {
      locationAddress = jsonDecode(data)["results"][0]["formatted_address"];
      confirmDestination = LatLng(latitude, longitude);
    });
  }

  @override
  void initState() {
    super.initState();
    getLocation();
  }

  @override
  Widget build(BuildContext context) {
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
      body: (_location == null)
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : Stack(
        children: [
          GoogleMap(
            mapType: MapType.hybrid,
            onTap: (LatLng destination) {
              setState(() {
                destinationLongitude = destination.longitude;
                destinationLatitude = destination.latitude;
                confirmDestination = destination;
                getAddress(destination.latitude, destination.longitude);
                markers.clear();
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
              padding: const EdgeInsets.symmetric(horizontal: 16),
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
                  const Text(
                    "Delivering at:",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    child: Text(locationAddress),
                    decoration: BoxDecoration(
                      color: Colors.white60,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  ElevatedButton.icon(
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
                        borderRadius: BorderRadius.circular(60.0),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context, locationAddress);
                    },
                    label: const Text(
                      'Confirm Location',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}