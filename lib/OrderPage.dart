import 'package:flutter/material.dart';
import 'package:dronaid_new_app/screens/orderdetails.dart';
import 'package:dronaid_new_app/utils/colors.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({Key? key}) : super(key: key);

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> with TickerProviderStateMixin {
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

  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
          DefaultTabController(
            animationDuration: Duration(milliseconds: 400),
            length: 2,
            child: Expanded(
              child: Column(
                children: [
                  const TabBar(
                    overlayColor: MaterialStatePropertyAll(Colors.transparent),
                    labelStyle: TextStyle(
                      fontSize: 16,
                      color: blueColor,
                      fontWeight: FontWeight.bold,
                    ),
                    indicatorColor: blueColor,
                    tabs: [
                      Tab(
                        text: 'Active Requests',
                      ),
                      Tab(text: 'Pending Requests'),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        // Tab 1: Active Orders
                        ListView.builder(
                          itemCount: activeOrders.length,
                          itemBuilder: (context, index) {
                            final animation = Tween<Offset>(
                              begin: Offset(1, 0),
                              end: Offset(0, 0),
                            ).animate(
                              CurvedAnimation(
                                parent: _controller,
                                curve: Interval(
                                  (1 / activeOrders.length) * index,
                                  1,
                                  curve: Curves.easeOut,
                                ),
                              ),
                            );

                            return buildOrderListItem(
                                activeOrders[index], index, animation);
                          },
                        ),

                        // Tab 2: Pending Orders
                        ListView.builder(
                          itemCount: pendingOrders.length,
                          itemBuilder: (context, index) {
                            final animation = Tween<Offset>(
                              begin: Offset(1, 0),
                              end: Offset(0, 0),
                            ).animate(
                              CurvedAnimation(
                                parent: _controller,
                                curve: Interval(
                                  (1 / pendingOrders.length) * index,
                                  1,
                                  curve: Curves.easeOut,
                                ),
                              ),
                            );

                            return buildOrderListItem(
                                pendingOrders[index], index, animation);
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

  Widget buildOrderListItem(
      Map<String, dynamic> order, int index, Animation<Offset> animation) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 15),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => const OrderDetails()));
        },
        child: SlideTransition(
          position: animation,
          child: Card(
            color: Color.fromRGBO(25, 118 - index * 10, 210 - index * 20, 1),
            elevation: 20,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            child: ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Order ${index + 1}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: primaryColor,
                    size: 14,
                  ),
                ],
              ),
              subtitle: Column(children: [
                const SizedBox(height: 5),
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
                          color: primaryColor,
                        ),
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      '   ${order['quantity']}\n   ${order['quantity']}\n   ${order['quantity']}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
