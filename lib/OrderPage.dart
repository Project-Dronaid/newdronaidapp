import 'package:dronaid_app/OrderDetails.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const OrderPage(),
    );
  }
}

class OrderPage extends StatefulWidget {
  const OrderPage({Key? key}) : super(key: key);

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  final List<Map<String, dynamic>> activeOrders = [
    {'name': 'Product A', 'quantity': 3},
    {'name': 'Product B', 'quantity': 2},
    {'name': 'Product C', 'quantity': 5},
    {'name': 'Product D', 'quantity': 1},
    {'name': 'Product E', 'quantity': 4},
  ];

  final List<Map<String, dynamic>> pendingOrders = [
    {'name': 'Product X', 'quantity': 2},
    {'name': 'Product Y', 'quantity': 1},
    {'name': 'Product Z', 'quantity': 3},
    {'name': 'Product W', 'quantity': 4},
    {'name': 'Product V', 'quantity': 5},
  ];
  String index1="", index2="";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,
        title: const Text(
          'My Orders',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(18, 10, 0, 0),
          ),
          // const SizedBox(
          //   height: 10,
          // ),
          DefaultTabController(
            animationDuration: Durations.medium1,
            length: 2,
            child: Expanded(
              child: Column(
                children: [
                  const TabBar(
                    overlayColor: WidgetStatePropertyAll(Colors.transparent),
                    labelStyle: TextStyle(
                      fontSize: 16,
                      color: Color.fromRGBO(25, 118, 210, 1),
                      fontWeight: FontWeight.bold
                    ),
                    indicatorColor:     Color.fromRGBO(25, 118, 210, 1),
                    tabs: [
                      Tab(
                        text: 'Active Orders',
                      ),
                      Tab(text: 'Pending Orders'),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        // Tab 1: Active Orders
                        ListView.builder(
                          itemCount: activeOrders.length,
                          itemBuilder: (context, index) {
                           // index1=activeOrders.length;
                            return buildOrderListItem(
                                activeOrders[index], index);
                          },
                        ),
                        // Tab 2: Pending Orders
                        ListView.builder(
                          itemCount: pendingOrders.length,
                          itemBuilder: (context, index) {
                            //index2=pendingOrders.length;
                            return buildOrderListItem(
                                pendingOrders[index], index);
                          },
                        ),
                      ],
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

  Widget buildOrderListItem(Map<String, dynamic> order, int index) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: GestureDetector(
        onTap: () {

          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const OrderDetails()));
          print('${index + 1} is tapped');
        },
        child: Card(
          color: Color.fromRGBO(25, 118-index*10, 210-index*20, 1),
          elevation: 20,
          child: ListTile(
            title:Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Order ${index + 1}',
                  style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                const Icon(Icons.arrow_forward_ios,
                color: Colors.white,)
              ],
            ),

            subtitle: Column(
              children:[
                const SizedBox(height: 5,),
                Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    '${order['name']}\n${order['name']}\n${order['name']}',
                    overflow: TextOverflow.visible,
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
                const SizedBox(width: 5),
                Text(
                  '   ${order['quantity']}\n   ${order['quantity']}\n   ${order['quantity']}',
                  style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),

                ),
              ],
            ),
                const SizedBox(height: 5,)
          ]
          )
          ),
        ),
      ),
    );
  }
}
