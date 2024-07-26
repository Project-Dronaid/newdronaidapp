import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class OrderTrackingPage extends StatefulWidget {
  const OrderTrackingPage({super.key});

  @override
  _OrderTrackingPageState createState() => _OrderTrackingPageState();
}

class _OrderTrackingPageState extends State<OrderTrackingPage> {
  bool isMapVisible = true;

  void toggleMapVisibility() {
    setState(() {
      isMapVisible = !isMapVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Track Order',
          style: TextStyle(fontWeight: FontWeight.bold,fontSize: 22),),
        backgroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(0.0), // Add padding here
            child: GoogleMapWidget(onMapTap: toggleMapVisibility),
          ),
          const Positioned(
            top: 20,
            right: 20,
            child: EstimatedTimeWidget(),
          ),
          Positioned(
            bottom: 30,
            left: 20,
            right: 20,
            child: isMapVisible
                ? const OrderDetailsWidget()
                : Container(), // Hide OrderDetailsWidget when map is not visible
          ),
        ],
      ),
    );
  }
}

class GoogleMapWidget extends StatelessWidget {
  final Function onMapTap;

  GoogleMapWidget({super.key, required this.onMapTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onMapTap(),
      child: ClipRRect(
        // borderRadius: BorderRadius.circular(16.0),
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
    );
  }
}

class OrderDetailsWidget extends StatelessWidget {
  const OrderDetailsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Color(0xFFF1E6FF),
        borderRadius: BorderRadius.circular(14.0),
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.black.withOpacity(0.5),
        //     spreadRadius: 10,
        //     blurRadius: 30,
        //     offset: const Offset(0, 3), // Position of shadow
        //   ),
        // ],
      ),
      child:  Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
        
          children: [
            
            const Text(
              'Order Details',
              style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            
            // const SizedBox(height: 6.0,),
            const Divider(
              color: Colors.deepPurple,
            ),
            const Text('Order ID: 123456', 
              style: TextStyle(fontSize: 14.0, color: Colors.black),
            ),
            
            const Text('Product: Blood O+',
              style: TextStyle(fontSize: 14.0, color: Colors.black),
            ),
            const Text('Quantity: 2 litres',
              style: TextStyle(fontSize: 14.0, color: Colors.black
              ),
            ),
            const SizedBox(height: 5,),
            RichText(
              text: const TextSpan(
                text:'Status: ',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.black),
                children: [
                    TextSpan(
                      text: 'Delivered',
                      style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.deepPurple),
                    )
                ]
              ),
              
            ),
            const SizedBox(height: 5,)
          ],
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.black.withOpacity(0.3),
        //     spreadRadius: 1,
        //     blurRadius: 10,
        //     offset: const Offset(0, 3), // Position of shadow
        //   ),
        // ],
      ),
      child: const Column(
        children: [
          Text(
            'Estimated Time',
            style: TextStyle(fontSize: 14.0, color: Colors.grey),
          ),
          SizedBox(height: 4.0),
          Text(
            '5-10 min',
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.deepPurple),
          ),
        ],
      ),
    );
  }
}
