import 'package:dronaid_app/screens/OrderDetails.dart';
import 'package:dronaid_app/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

// class OrderPage extends StatefulWidget {
//   const OrderPage({Key? key}) : super(key: key);
//
//   @override
//   State<OrderPage> createState() => _OrderPageState();
// }
//
// class _OrderPageState extends State<OrderPage> {
//   final List<Map<String, dynamic>> activeOrders = [
//     {'name': 'Product A', 'quantity': 3},
//     {'name': 'Product B', 'quantity': 2},
//     {'name': 'Product C', 'quantity': 5},
//     {'name': 'Product D', 'quantity': 1},
//     {'name': 'Product E', 'quantity': 4},
//   ];
//
//   final List<Map<String, dynamic>> pendingOrders = [
//     {'name': 'Product X', 'quantity': 2},
//     {'name': 'Product Y', 'quantity': 1},
//     {'name': 'Product Z', 'quantity': 3},
//     {'name': 'Product W', 'quantity': 4},
//     {'name': 'Product V', 'quantity': 5},
//   ];
//   String index1="", index2="";
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         surfaceTintColor: Colors.white,
//         backgroundColor: Colors.white,
//         title: const Text(
//           'My Orders',
//           style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
//         ),
//       ),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Padding(
//             padding: EdgeInsets.fromLTRB(18, 10, 0, 0),
//           ),
//           // const SizedBox(
//           //   height: 10,
//           // ),
//           DefaultTabController(
//             animationDuration: Durations.medium1,
//             length: 2,
//             child: Expanded(
//               child: Column(
//                 children: [
//                   const TabBar(
//                     overlayColor: WidgetStatePropertyAll(Colors.transparent),
//                     labelStyle: TextStyle(
//                       fontSize: 16,
//                       color: Color.fromRGBO(25, 118, 210, 1),
//                       fontWeight: FontWeight.bold
//                     ),
//                     indicatorColor:     Color.fromRGBO(25, 118, 210, 1),
//                     tabs: [
//                       Tab(
//                         text: 'Active Orders',
//                       ),
//                       Tab(text: 'Pending Orders'),
//                     ],
//                   ),
//                   const SizedBox(
//                     height: 15,
//                   ),
//                   Expanded(
//                     child: TabBarView(
//                       children: [
//                         // Tab 1: Active Orders
//                         ListView.builder(
//                           itemCount: activeOrders.length,
//                           itemBuilder: (context, index) {
//                            // index1=activeOrders.length;
//                             return buildOrderListItem(
//                                 activeOrders[index], index);
//                           },
//                         ),
//                         // Tab 2: Pending Orders
//                         ListView.builder(
//                           itemCount: pendingOrders.length,
//                           itemBuilder: (context, index) {
//                             //index2=pendingOrders.length;
//                             return buildOrderListItem(
//                                 pendingOrders[index], index);
//                           },
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//
//   }
//
//   Widget buildOrderListItem(Map<String, dynamic> order, int index) {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
//       child: GestureDetector(
//         onTap: () {
//
//           Navigator.push(context,
//               MaterialPageRoute(builder: (context) => const OrderDetails()));
//           print('${index + 1} is tapped');
//         },
//         child: Card(
//           color: Color.fromRGBO(25, 118-index*10, 210-index*20, 1),
//           elevation: 20,
//           child: ListTile(
//             title:Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   'Order ${index + 1}',
//                   style: const TextStyle(
//                       fontSize: 24,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white),
//                 ),
//                 const Icon(Icons.arrow_forward_ios,
//                 color: Colors.white,)
//               ],
//             ),
//
//             subtitle: Column(
//               children:[
//                 const SizedBox(height: 5,),
//                 Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Expanded(
//                   child: Text(
//                     '${order['name']}\n${order['name']}\n${order['name']}',
//                     overflow: TextOverflow.visible,
//                     style: const TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white),
//                   ),
//                 ),
//                 const SizedBox(width: 5),
//                 Text(
//                   '   ${order['quantity']}\n   ${order['quantity']}\n   ${order['quantity']}',
//                   style: const TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white),
//
//                 ),
//               ],
//             ),
//                 const SizedBox(height: 5,)
//           ]
//           )
//           ),
//         ),
//       ),
//     );
//   }
// }

class RequestPage extends StatefulWidget {
  const RequestPage({super.key});

  @override
  State<RequestPage> createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFFEEEFF5),
        appBar: AppBar(
          backgroundColor: const Color(0xFFEEEFF5),
          title: const Text(
            'Requests',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          bottom: const TabBar(
            tabs: [
              Tab(
                text: 'Active Requests',
              ),
              Tab(
                text: 'Closed Requests',
              )
            ],
          ),
        ),
        body: TabBarView(children: [
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.all(15),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.transparent,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(
                                'https://images.unsplash.com/photo-1596541223130-5d31a73fb6c6?w=800&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTR8fGhvc3BpdGFsJTIwYnVpbGRpbmd8ZW58MHx8MHx8fDA%3D'),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            'KMC Hospital',
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 15),
                          ),
                          Spacer(),
                          Text(
                            '11:55pm, 12th April',
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w300),
                          ),
                          IconButton(
                              onPressed: () {}, icon: Icon(Icons.more_vert)),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 46, right: 10, bottom: 10),
                        child: Text(
                            "Emergency Request. O+ blood is required. Patient details- 50 years, Male "),
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 40,
                          ),
                          Container(
                            margin: EdgeInsets.only(right: 10),
                            width: 90,
                            height: 90,
                            child: Image.network(
                              'https://images.unsplash.com/photo-1596541223130-5d31a73fb6c6?w=800&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTR8fGhvc3BpdGFsJTIwYnVpbGRpbmd8ZW58MHx8MHx8fDA%3D',
                              fit: BoxFit.fill,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(right: 10),
                            width: 90,
                            height: 90,
                            child: Image.network(
                              'https://images.unsplash.com/photo-1596541223130-5d31a73fb6c6?w=800&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTR8fGhvc3BpdGFsJTIwYnVpbGRpbmd8ZW58MHx8MHx8fDA%3D',
                              fit: BoxFit.fill,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(right: 10),
                            width: 90,
                            height: 90,
                            child: Image.network(
                              'https://images.unsplash.com/photo-1596541223130-5d31a73fb6c6?w=800&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTR8fGhvc3BpdGFsJTIwYnVpbGRpbmd8ZW58MHx8MHx8fDA%3D',
                              fit: BoxFit.fill,
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            padding: EdgeInsets.all(10),
                            margin: EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(20)),
                            child: Text(
                              'Accept Request',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          SizedBox(
                            width: 30,
                          ),
                          Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(20)),
                            child: Text(
                              'Reject Request',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(15),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.transparent,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(
                                'https://images.unsplash.com/photo-1596541223130-5d31a73fb6c6?w=800&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTR8fGhvc3BpdGFsJTIwYnVpbGRpbmd8ZW58MHx8MHx8fDA%3D'),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            'KMC Hospital',
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 15),
                          ),
                          Spacer(),
                          Text(
                            '11:55pm, 12th April',
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w300),
                          ),
                          IconButton(
                              onPressed: () {}, icon: Icon(Icons.more_vert)),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 46, right: 10, bottom: 10),
                        child: Text(
                            "Emergency Request. O+ blood is required. Patient details- 50 years, Male "),
                      ),
                      // Row(
                      //   children: [
                      //     SizedBox(width: 40,),
                      //     Container(
                      //       margin: EdgeInsets.only(right:10),
                      //       width: 90,
                      //       height: 90,
                      //       child: Image.network(
                      //         'https://images.unsplash.com/photo-1596541223130-5d31a73fb6c6?w=800&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTR8fGhvc3BpdGFsJTIwYnVpbGRpbmd8ZW58MHx8MHx8fDA%3D',
                      //         fit: BoxFit.fill,),
                      //     ),
                      //     Container(
                      //       margin: EdgeInsets.only(right:10),
                      //       width: 90,
                      //       height: 90,
                      //       child: Image.network(
                      //         'https://images.unsplash.com/photo-1596541223130-5d31a73fb6c6?w=800&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTR8fGhvc3BpdGFsJTIwYnVpbGRpbmd8ZW58MHx8MHx8fDA%3D',
                      //         fit: BoxFit.fill,),
                      //     ),
                      //     Container(
                      //       margin: EdgeInsets.only(right:10),
                      //       width: 90,
                      //       height: 90,
                      //       child: Image.network(
                      //         'https://images.unsplash.com/photo-1596541223130-5d31a73fb6c6?w=800&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTR8fGhvc3BpdGFsJTIwYnVpbGRpbmd8ZW58MHx8MHx8fDA%3D',
                      //         fit: BoxFit.fill,),
                      //     )
                      //   ],
                      // ),
                      SizedBox(
                        height: 5,
                      ),
                      Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            padding: EdgeInsets.all(10),
                            margin: EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(20)),
                            child: Text(
                              'Accept Request',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          SizedBox(
                            width: 30,
                          ),
                          Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(20)),
                            child: Text(
                              'Reject Request',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(15),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.transparent,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(
                                'https://images.unsplash.com/photo-1596541223130-5d31a73fb6c6?w=800&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTR8fGhvc3BpdGFsJTIwYnVpbGRpbmd8ZW58MHx8MHx8fDA%3D'),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            'KMC Hospital',
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 15),
                          ),
                          Spacer(),
                          Text(
                            '11:55pm, 12th April',
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w300),
                          ),
                          IconButton(
                              onPressed: () {}, icon: Icon(Icons.more_vert)),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 46, right: 10, bottom: 10),
                        child: Text(
                            "Emergency Request. O+ blood is required. Patient details- 50 years, Male "),
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 40,
                          ),
                          Container(
                            margin: EdgeInsets.only(right: 10),
                            width: 90,
                            height: 90,
                            child: Image.network(
                              'https://images.unsplash.com/photo-1596541223130-5d31a73fb6c6?w=800&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTR8fGhvc3BpdGFsJTIwYnVpbGRpbmd8ZW58MHx8MHx8fDA%3D',
                              fit: BoxFit.fill,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(right: 10),
                            width: 90,
                            height: 90,
                            child: Image.network(
                              'https://images.unsplash.com/photo-1596541223130-5d31a73fb6c6?w=800&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTR8fGhvc3BpdGFsJTIwYnVpbGRpbmd8ZW58MHx8MHx8fDA%3D',
                              fit: BoxFit.fill,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(right: 10),
                            width: 90,
                            height: 90,
                            child: Image.network(
                              'https://images.unsplash.com/photo-1596541223130-5d31a73fb6c6?w=800&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTR8fGhvc3BpdGFsJTIwYnVpbGRpbmd8ZW58MHx8MHx8fDA%3D',
                              fit: BoxFit.fill,
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            padding: EdgeInsets.all(10),
                            margin: EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(20)),
                            child: Text(
                              'Accept Request',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          SizedBox(
                            width: 30,
                          ),
                          Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(20)),
                            child: Text(
                              'Reject Request',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.all(15),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.transparent,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(
                                'https://images.unsplash.com/photo-1596541223130-5d31a73fb6c6?w=800&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTR8fGhvc3BpdGFsJTIwYnVpbGRpbmd8ZW58MHx8MHx8fDA%3D'),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            'KMC Hospital',
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 15),
                          ),
                          Spacer(),
                          Text(
                            '11:55pm, 12th April',
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w300),
                          ),
                          IconButton(
                              onPressed: () {}, icon: Icon(Icons.more_vert)),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 46, right: 10, bottom: 10),
                        child: Text(
                            "Emergency Request. O+ blood is required. Patient details- 50 years, Male "),
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 40,
                          ),
                          Container(
                            margin: EdgeInsets.only(right: 10),
                            width: 90,
                            height: 90,
                            child: Image.network(
                              'https://images.unsplash.com/photo-1596541223130-5d31a73fb6c6?w=800&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTR8fGhvc3BpdGFsJTIwYnVpbGRpbmd8ZW58MHx8MHx8fDA%3D',
                              fit: BoxFit.fill,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(right: 10),
                            width: 90,
                            height: 90,
                            child: Image.network(
                              'https://images.unsplash.com/photo-1596541223130-5d31a73fb6c6?w=800&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTR8fGhvc3BpdGFsJTIwYnVpbGRpbmd8ZW58MHx8MHx8fDA%3D',
                              fit: BoxFit.fill,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(right: 10),
                            width: 90,
                            height: 90,
                            child: Image.network(
                              'https://images.unsplash.com/photo-1596541223130-5d31a73fb6c6?w=800&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTR8fGhvc3BpdGFsJTIwYnVpbGRpbmd8ZW58MHx8MHx8fDA%3D',
                              fit: BoxFit.fill,
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Divider(),
                      Text(
                        'Request was closed',
                        style: TextStyle(fontWeight: FontWeight.w200),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(15),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.lightGreenAccent,
                        spreadRadius: 2,
                        blurRadius: 3,
                      )
                    ],
                    border: Border.all(
                      color: Colors.transparent,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(
                                'https://images.unsplash.com/photo-1596541223130-5d31a73fb6c6?w=800&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTR8fGhvc3BpdGFsJTIwYnVpbGRpbmd8ZW58MHx8MHx8fDA%3D'),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            'KMC Hospital',
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 15),
                          ),
                          Spacer(),
                          Text(
                            '11:55pm, 12th April',
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w300),
                          ),
                          IconButton(
                              onPressed: () {}, icon: Icon(Icons.more_vert)),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 46, right: 10, bottom: 10),
                        child: Text(
                            "Emergency Request. O+ blood is required. Patient details- 50 years, Male "),
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 40,
                          ),
                          Container(
                            margin: EdgeInsets.only(right: 10),
                            width: 90,
                            height: 90,
                            child: Image.network(
                              'https://images.unsplash.com/photo-1596541223130-5d31a73fb6c6?w=800&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTR8fGhvc3BpdGFsJTIwYnVpbGRpbmd8ZW58MHx8MHx8fDA%3D',
                              fit: BoxFit.fill,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(right: 10),
                            width: 90,
                            height: 90,
                            child: Image.network(
                              'https://images.unsplash.com/photo-1596541223130-5d31a73fb6c6?w=800&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTR8fGhvc3BpdGFsJTIwYnVpbGRpbmd8ZW58MHx8MHx8fDA%3D',
                              fit: BoxFit.fill,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(right: 10),
                            width: 90,
                            height: 90,
                            child: Image.network(
                              'https://images.unsplash.com/photo-1596541223130-5d31a73fb6c6?w=800&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTR8fGhvc3BpdGFsJTIwYnVpbGRpbmd8ZW58MHx8MHx8fDA%3D',
                              fit: BoxFit.fill,
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.check,
                            color: Colors.green,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            'Request was accepted',
                            style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
