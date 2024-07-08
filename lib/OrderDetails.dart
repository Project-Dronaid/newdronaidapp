import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'dart:math' as Math;
import "constants.dart";

class OrderDetails extends StatefulWidget {
  const OrderDetails({super.key});

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {

  final list = orders;
  final LatLng _center = const LatLng(13.3461, 74.7965);
  static const _initialCameraPosition = CameraPosition(
      target: LatLng(13.3461, 74.7965),
      zoom: 13);
  late GoogleMapController _googleMapController;
  Set<Marker> _markers = {};





  @override
  void dispose(){
    _googleMapController.dispose();
    //print('Disposin...');
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          elevation: 5,
          backgroundColor: Colors.white,
          scrolledUnderElevation: 5,
          surfaceTintColor: Colors.white,
          title: const Text(
            'Order Details', style: TextStyle(fontWeight: FontWeight.bold),),
        ),
        body: Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height,
                child: Stack(
                    children:[ GoogleMap(
                      markers: _markers,
                      mapType: MapType.normal,
                      myLocationEnabled: true,
                      initialCameraPosition: _initialCameraPosition,
                      onMapCreated: (GoogleMapController controller){
                        _googleMapController=controller;
                        //adds marker after creating map
                        setState(() {
                          _markers.add(Marker(
                              markerId: MarkerId('1'),
                              position: _center,
                              infoWindow: InfoWindow(
                                  title: 'Source',
                                  snippet: 'details here*'
                              )
                          )
                          );
                        });
                      },
                    ),
                      Positioned(
                        bottom: 210,
                        right: 20,
                        child: FloatingActionButton(
                          shape: CircleBorder(),
                          backgroundColor: Colors.lightBlue,
                          foregroundColor: Colors.white,
                          onPressed: (){
                            _googleMapController.animateCamera(CameraUpdate.newCameraPosition(_initialCameraPosition));
                          },
                          child: const Icon(Icons.center_focus_strong,),),
                      )
                    ]
                ),

              ),
              Positioned(
                bottom: 0,
                child: Container(
                  height: 200,
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30)),
                      color: Colors.white,
                      boxShadow: [BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 3,
                        blurRadius: 10,
                      )
                      ]
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8, 8),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Column(
                            children: [
                              Text('Order No: xx',
                                  style: TextStyle(fontSize: 20)),
                              Text('Order Details here',
                                  style: TextStyle(fontSize: 20)),
                              Text('More Order Details here',
                                  style: TextStyle(fontSize: 20)),
                            ],
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment
                                .spaceEvenly,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: SizedBox(
                                    height: 60,
                                    child: ElevatedButton(
                                      onPressed: () {},
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Color.fromRGBO(
                                            57, 161, 18, 1.0),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius
                                              .circular(50),
                                        ),
                                      ),
                                      child: const Text(
                                        "Confirm Order",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: SizedBox(
                                    height: 60,
                                    child: ElevatedButton(
                                      onPressed: () {},
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius
                                              .circular(50),
                                        ),
                                      ),
                                      child: const Text(
                                        "Cancel",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ]
        )
    );
  }
}
