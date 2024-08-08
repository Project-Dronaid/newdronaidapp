import 'package:dronaid_app/utils/colors.dart';
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
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
    });
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
          
          padding: const EdgeInsets.fromLTRB(10,5,5,5),
          child: CircleAvatar(
            backgroundColor: Colors.white,
            child: IconButton(
            
              onPressed: (){}, icon: Icon(Icons.arrow_back), color: Colors.black,),
          ),
        ),
      ),
              backgroundColor: Colors.transparent,
      
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(0.0), // Add padding here
            child: GoogleMapWidget(onMapTap: toggleMapVisibility),
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
            builder: (BuildContext context, scrollController){
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
                child: const OrderDetailsWidget()),
            );
          } )
        ],
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
        color: Color.fromARGB(255, 236, 237, 240),
        borderRadius: BorderRadius.circular(14.0),
        
      ),
      child:  Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
        
          children: [
          Container(child: OrderTracking(),),
            Divider(
              height: 1,
              color: Color.fromARGB(255, 210, 205, 205)
            ),
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                 Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Arrival estimation', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900),),
                    SizedBox(height: 10,),
                    Text('08:00 PM - 08:12 PM', style: TextStyle(fontSize: 15, color: Color.fromARGB(255, 122, 121, 121)),),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: OutlinedButton(onPressed: (){},child:  Text('23 Min', style: TextStyle(color: Colors.black),)),
                )
              ],
            ),
                        SizedBox(height: 10,),
            Divider(height: 1, color: Color.fromARGB(255, 210, 205, 205)),
                        SizedBox(height: 10,),
            Text('Address', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900),),
                        SizedBox(height: 10,),
            Text('1234 NW Bobcat Lane, St. Robert, MO 65584-5678'),
                        SizedBox(height: 10,),

            Divider(height: 1,color: Color.fromARGB(255, 210, 205, 205)),
                        SizedBox(height: 10,),
            Text('Order Details',style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),),
            Padding(
              padding: const EdgeInsets.fromLTRB(0,10,0,20),
              child: OrderItemsTable(),
            ),
             Divider(height: 1,color: Color.fromARGB(255, 210, 205, 205)),
                        SizedBox(height: 10,),

          ]
        ),
      ),
    );
  }
}
class OrderItemsTable extends StatelessWidget {
  final List<OrderItem> items = [
    OrderItem(name: 'Heart', quantity: 10, weight: 1.2),
    OrderItem(name: 'O+ Blood 5L', quantity: 1, weight: 1.1),
    OrderItem(name: 'Liver', quantity: 1, weight: 1.5),
    OrderItem(name: 'Lungs', quantity: 1, weight: 2.0),
    OrderItem(name: 'XYZ', quantity: 2, weight: 0.8),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
  
      scrollDirection: Axis.horizontal,
      
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30)
        ),
        child: DataTable(
          
          columns: [
            DataColumn(label: Text('Name')),
            DataColumn(label: Text('Quantity')),
            DataColumn(label: Text('Weight (kg)')),
          ],
          rows: items.map((item) {
            return DataRow(cells: [
              DataCell(Text(item.name)),
              DataCell(Text(item.quantity.toString())),
              DataCell(Text(item.weight.toString())),
            ]);
          }).toList(),
        ),
      ),
    );
  }
}

class OrderItem {
  final String name;
  final int quantity;
  final double weight;

  OrderItem({required this.name, required this.quantity, required this.weight});
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
          builder: (context, constraints) => 
          SizedBox(
            height: constraints.maxHeight*0.71,
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
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.black),
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
              label: 'Order\nreceived',
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
              label: 'Enjoy your\nmeal!',
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

  TrackingStep({required this.icon, required this.label, this.isActive = false});

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
            color: Colors.black,
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