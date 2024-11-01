// import 'package:baheej/screens/CenterProfileScreen.dart';
// import 'package:baheej/screens/HomeScreenCenter.dart';
// import 'package:baheej/screens/ServiceFormScreen.dart';
// import 'package:baheej/screens/SignInScreen.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/cupertino.dart'; // Make sure to import the Cupertino library
// import 'package:flutter/material.dart';
// import 'dart:math';

// import 'package:intl/intl.dart';
// import 'package:baheej/screens/Service.dart'; // Import the Service class if it's in a separate file

// class compSerListScreen extends StatefulWidget {
//   final String centerName;

//   compSerListScreen({required this.centerName});

//   @override
//   _compSerListScreenState createState() => _compSerListScreenState();
// }

// class _compSerListScreenState extends State<compSerListScreen> {
//   List<Service> completedServices = [];
//   // CenterProfile? _centerProfile;
//   List<Service> services = []; // Add this line
//   List<Service> filteredServices = []; // Add this line
//   String centerName = '';

//   @override
//   void initState() {
//     super.initState();
//     loadCompletedServices();
//   }

// // Define a function to create a gradient for the progress bar
//   LinearGradient _buildProgressBarGradient() {
//     return LinearGradient(
//       colors: [
//         Colors.pink,
//         Colors.green,
//         Colors.yellow,
//         Colors.orange,
//         Colors.purple,
//         Colors.blue,
//       ],
//       stops: [
//         0.0,
//         0.2,
//         0.4,
//         0.6,
//         0.8,
//         1.0,
//       ],
//     );
//   }

//   //function to create random colors of card
//   final _random = Random();
//   final List<Color> _randomColors = [
//     Color.fromARGB(255, 252, 222, 233),
//     Color.fromARGB(255, 210, 229, 245),
//     Color.fromARGB(255, 251, 242, 212),
//     // Add more colors if needed
//   ];

//   Color _getRandomColor() {
//     return _randomColors[_random.nextInt(_randomColors.length)];
//   }

//   int _totalRatedServices = 0;

//   Future<double> calculateBookingRatio(Service service) async {
//     if (service.capacityValue > 0) {
//       // Fetch the booked services for the logged-in center
//       int bookedServicesCount =
//           await getBookedServicesCount(service.centerName);

//       // Calculate the booking ratio
//       return bookedServicesCount > 0
//           ? bookedServicesCount / service.capacityValue
//           : 0.0;
//     } else {
//       return 0.0; // Handle the case where capacityValue is 0 to avoid division by zero
//     }
//   }

//   void _dummyServiceAddedFunction() {
//     // This function intentionally left blank.
//   }
// // Fetch the number of booked services for the specified center
//   Future<int> getBookedServicesCount(String centerName) async {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user != null) {
//       final userId = user.uid;

//       try {
//         final QuerySnapshot snapshot = await FirebaseFirestore.instance
//             .collection('ServiceBook')
//             .where('centerName', isEqualTo: centerName)
//             .get();

//         return snapshot.size; // Return the count of booked services
//       } catch (e) {
//         print('Error fetching booked services: $e');
//       }
//     }

//     return 0; // Return 0 in case of an error or no booked services
//   }

//   static String formatServiceInfo(Service service) {
//     return """
//       Service Name: ${service.serviceName}
//       Description: ${service.description}
//       Center Name: ${service.centerName}
//       Start Date: ${service.selectedStartDate}
//       End Date: ${service.selectedEndDate}
//       Min Age: ${service.minAge}
//       Max Age: ${service.maxAge}
//       Capacity: ${service.capacityValue}
//       Service Price: ${service.servicePrice}
//       Time Slot: ${service.selectedTimeSlot}
//     """;
//   }

//   Future<void> loadCompletedServices() async {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user != null) {
//       final userId = user.uid;
//       final centerDoc = await FirebaseFirestore.instance
//           .collection('center')
//           .doc(userId)
//           .get();
//       if (centerDoc.exists) {
//         // Now you can use centerDoc.data() to access the data
//         centerName = centerDoc.data()!['username'];
//       }

//       final snapshot = await FirebaseFirestore.instance
//           .collection('center-service')
//           .where('centerName', isEqualTo: widget.centerName)
//           .get();
//       final currentDate = DateTime.now();
//       final List<Service?> loadedServices =
//           await Future.wait(snapshot.docs.map((doc) async {
//         final data = doc.data() as Map<String, dynamic>;
//         DateTime selectedStartDate;
//         DateTime selectedEndDate;

//         if (data['startDate'] is String) {
//           selectedStartDate = DateTime.parse(data['startDate'] as String);
//         } else if (data['startDate'] is Timestamp) {
//           selectedStartDate = (data['startDate'] as Timestamp).toDate();
//         } else {
//           selectedStartDate = DateTime.now();
//         }

//         if (data['endDate'] is String) {
//           selectedEndDate = DateTime.parse(data['endDate'] as String);
//         } else if (data['endDate'] is Timestamp) {
//           selectedEndDate = (data['endDate'] as Timestamp).toDate();
//         } else {
//           selectedEndDate = DateTime.now();
//         }

//         if (selectedEndDate.isBefore(currentDate)) {
//           // List<String> subscribedUsers = await getSubscribedUsers(doc.id);
//           final participantNo = data['participateNo'] ?? 0;

//           return Service(
//             id: doc.id,
//             serviceName:
//                 data['serviceName'] as String? ?? 'Service Name Missing',
//             description:
//                 data['serviceDesc'] as String? ?? 'Description Missing',
//             centerName: data['centerName'] as String? ?? 'Center Name Missing',
//             selectedStartDate: selectedStartDate,
//             selectedEndDate: selectedEndDate,
//             minAge: data['minAge'] as int? ?? 0,
//             maxAge: data['maxAge'] as int? ?? 0,
//             capacityValue: data['serviceCapacity'] as int? ?? 0,
//             servicePrice: data['servicePrice'] is double
//                 ? data['servicePrice']
//                 : (data['servicePrice'] is int
//                     ? (data['servicePrice'] as int).toDouble()
//                     : 0.0),
//             selectedTimeSlot:
//                 data['selectedTimeSlot'] as String? ?? 'Time Slot Missing',
//             participateNo: participantNo,
//             starsrate: data['starsrate'] as int? ?? 0,
//           );
//         } else {
//           return null;
//         }
//       }));

//       setState(() {
//         services = loadedServices
//             .where((service) => service != null)
//             .cast<Service>()
//             .toList();
//         filteredServices = loadedServices
//             .where((service) => service != null)
//             .cast<Service>()
//             .toList();
//       });
//     }
//   }

//   double calculatePercentageBooked(int capacity, int participants) {
//     if (capacity <= 0) {
//       return 0.0; // Return 0 if capacity is invalid
//     }

//     return (participants / capacity) * 100; // Calculate percentage booked
//   }

//   Future<void> _handleLogout() async {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Are You Sure?'),
//           content: Text('Do you want to log out?'),
//           actions: <Widget>[
//             TextButton(
//               child: Text('No'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//             TextButton(
//               child: Text('Yes'),
//               onPressed: () async {
//                 Navigator.of(context).pop();
//                 try {
//                   await FirebaseAuth.instance.signOut();
//                   showLogoutSuccessDialog();
//                 } catch (e) {
//                   print("Error signing out: $e");
//                 }
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   Future<void> loadServices() async {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user != null) {
//       final userId = user.uid;

//       // Fetch user center data
//       final centerDoc = await FirebaseFirestore.instance
//           .collection('center')
//           .doc(userId)
//           .get();
//       if (centerDoc.exists) {
//         // Now you can use centerDoc.data() to access the data
//         centerName = centerDoc.data()!['username'];
//       }

//       final snapshot = await FirebaseFirestore.instance
//           .collection('center-service')
//           .where('centerName', isEqualTo: widget.centerName)
//           .get();
//       final currentDate = DateTime.now(); // Get the current date
//       final List<Service> loadedServices = snapshot.docs
//           .map((doc) {
//             final data = doc.data() as Map<String, dynamic>;
//             DateTime selectedStartDate;
//             DateTime selectedEndDate;

//             // Check if the 'startDate' and 'endDate' are stored as strings or timestamps
//             if (data['startDate'] is String) {
//               selectedStartDate = DateTime.parse(data['startDate'] as String);
//             } else if (data['startDate'] is Timestamp) {
//               selectedStartDate = (data['startDate'] as Timestamp).toDate();
//             } else {
//               selectedStartDate = DateTime.now();
//             }

//             if (data['endDate'] is String) {
//               selectedEndDate = DateTime.parse(data['endDate'] as String);
//             } else if (data['endDate'] is Timestamp) {
//               selectedEndDate = (data['endDate'] as Timestamp).toDate();
//             } else {
//               selectedEndDate = DateTime.now();
//             }
//             final participantNo = data['participateNo'] ?? 0;

//             // Check if the start date is today or earlier
//             if (!selectedStartDate.isBefore(currentDate)) {
//               return Service(
//                 id: doc.id,
//                 serviceName:
//                     data['serviceName'] as String? ?? 'Service Name Missing',
//                 description:
//                     data['serviceDesc'] as String? ?? 'Description Missing',
//                 centerName:
//                     data['centerName'] as String? ?? 'Center Name Missing',
//                 selectedStartDate: selectedStartDate,
//                 selectedEndDate: selectedEndDate,
//                 minAge: data['minAge'] as int? ?? 0,
//                 maxAge: data['maxAge'] as int? ?? 0,
//                 capacityValue: data['serviceCapacity'] as int? ?? 0,
//                 servicePrice: data['servicePrice'] is double
//                     ? data['servicePrice']
//                     : (data['servicePrice'] is int
//                         ? (data['servicePrice'] as int).toDouble()
//                         : 0.0),
//                 selectedTimeSlot:
//                     data['selectedTimeSlot'] as String? ?? 'Time Slot Missing',
//                 participateNo: participantNo,
//                 starsrate: data['starsrate'] as int? ?? 0,
//               );
//             } else {
//               // Return null for services with start dates in the past or today
//               return null;
//             }
//           })
//           .where((service) => service != null) // Filter out null values
//           .cast<Service>() // Cast the list to Service
//           .toList();

//       setState(() {
//         services = loadedServices;
//         filteredServices = loadedServices;
//       });
//     }
//   }

//   void reloadServices() async {
//     await loadServices();
//   }

//   void showLogoutSuccessDialog() {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Logout Successful'),
//           content: Text('You have successfully logged out.'),
//           actions: <Widget>[
//             TextButton(
//               child: Text('OK'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 navigateToSignInScreen();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void navigateToSignInScreen() {
//     Navigator.pushAndRemoveUntil(
//       context,
//       MaterialPageRoute(builder: (context) => SignInScreen()),
//       (route) => false, // Remove all routes in the stack
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       extendBodyBehindAppBar: true,
//       appBar: AppBar(
//         title: Text(
//           'Programs Statistics',
//           style: TextStyle(
//             fontFamily: '5yearsoldfont', // Use the defined font family
//             fontSize: 25, // Adjust the font size as needed
//             fontWeight: FontWeight.bold, // Replace with your font family name
//           ),
//           // textAlign: TextAlign.center, // Align the text's content in the center
//         ),
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         actions: [
//           IconButton(
//             icon: Icon(Icons.logout),
//             onPressed: () {
//               _handleLogout();
//             },
//           ),
//         ],
//       ),
//       body: Stack(
//         children: [
//           Positioned.fill(
//             child: Image.asset(
//               'assets/images/stat.png',
//               fit: BoxFit.cover,
//             ),
//           ),
//           Padding(
//             padding: EdgeInsets.only(top: 100, left: 16, right: 16),
//             child: Column(
//               children: [
//                 Expanded(
//                   child: ListView.builder(
//                     itemCount: services.length,
//                     itemBuilder: (context, index) {
//                       final service = services[index];
//                       return Card(
//                         elevation: 3,
//                         margin: EdgeInsets.symmetric(
//                           vertical: 8,
//                           horizontal: 16,
//                         ),
//                         color: _getRandomColor(),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                         child: Padding(
//                           padding: const EdgeInsets.all(16),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Row(
//                                 children: [
//                                   Text(
//                                     'Program Name: ',
//                                     style: TextStyle(
//                                       fontSize: 16,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                   Text(
//                                     service.serviceName,
//                                     style: TextStyle(
//                                       fontSize: 16,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               Divider(),
//                               Row(
//                                 children: [
//                                   Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       Row(
//                                         children: [
//                                           Text(
//                                             'Booked Capacity Percentage: ',
//                                             style: TextStyle(
//                                               fontSize: 15,
//                                               fontWeight: FontWeight.bold,
//                                             ),
//                                           ),
//                                           SizedBox(width: 8),
//                                           Text(
//                                             '(${service.participateNo} / ${service.capacityValue})',
//                                             style: TextStyle(
//                                               fontSize: 16,
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                       Row(
//                                         children: [
//                                           Text(
//                                             '${calculatePercentageBooked(service.capacityValue, service.participateNo).toStringAsFixed(2)}%',
//                                             style: TextStyle(
//                                               fontSize: 16,
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                       SizedBox(height: 8),
//                                       Container(
//                                         width:
//                                             MediaQuery.of(context).size.width *
//                                                 0.7,
//                                         height: 8,
//                                         decoration: BoxDecoration(
//                                           color: Colors.grey[300],
//                                           borderRadius:
//                                               BorderRadius.circular(4.0),
//                                         ),
//                                         child: ClipRRect(
//                                           borderRadius:
//                                               BorderRadius.circular(4.0),
//                                           child: LinearProgressIndicator(
//                                             value: calculatePercentageBooked(
//                                                   service.capacityValue,
//                                                   service.participateNo,
//                                                 ) /
//                                                 100.0,
//                                             backgroundColor: Colors.grey[300],
//                                             valueColor:
//                                                 AlwaysStoppedAnimation<Color>(
//                                               _buildProgressBarGradient()
//                                                   .colors
//                                                   .last,
//                                             ),
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                               Row(
//                                 children: [
//                                   Text(
//                                     'Average Rating: ',
//                                     style: TextStyle(
//                                       fontSize: 15,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                   FutureBuilder<double>(
//                                     future: calculateAverageRating(
//                                         service.serviceName),
//                                     builder: (context, snapshot) {
//                                       if (snapshot.connectionState ==
//                                           ConnectionState.waiting) {
//                                         return CircularProgressIndicator();
//                                       } else if (snapshot.hasError) {
//                                         return Text('Error');
//                                       } else {
//                                         double averageRating = snapshot.data!;

//                                         return FutureBuilder<int>(
//                                           future: calculateTotalRatedServices(
//                                               service.serviceName),
//                                           builder: (context,
//                                               totalRatedServicesSnapshot) {
//                                             if (totalRatedServicesSnapshot
//                                                     .connectionState ==
//                                                 ConnectionState.waiting) {
//                                               return CircularProgressIndicator();
//                                             } else if (totalRatedServicesSnapshot
//                                                 .hasError) {
//                                               return Text('Error');
//                                             } else {
//                                               int totalRatedServices =
//                                                   totalRatedServicesSnapshot
//                                                       .data!;

//                                               return Row(
//                                                 children: [
//                                                   Text(
//                                                     '($totalRatedServices)',
//                                                     style: TextStyle(
//                                                       fontSize: 16,
//                                                     ),
//                                                   ),
//                                                   SizedBox(width: 5),
//                                                   Text(
//                                                     '${averageRating.toStringAsFixed(2)}',
//                                                     style: TextStyle(
//                                                       fontSize: 16,
//                                                     ),
//                                                   ),
//                                                   SizedBox(width: 5),
//                                                   Icon(
//                                                     Icons.star,
//                                                     color: Colors.amber,
//                                                     size: 20,
//                                                   ),
//                                                 ],
//                                               );
//                                             }
//                                           },
//                                         );
//                                       }
//                                     },
//                                   ),
//                                 ],
//                               ),

//                               // Add an Align widget to position the button to the bottom right
//                               Align(
//                                 alignment: Alignment.bottomRight,
//                                 child: ElevatedButton(
//                                   onPressed: () {
//                                     _showServiceDetails(service);
//                                   },
//                                   style: ElevatedButton.styleFrom(
//                                     primary: Color.fromARGB(255, 59, 138, 207),
//                                     textStyle: TextStyle(
//                                       fontSize: 16,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                     // padding: EdgeInsets.symmetric(
//                                     //   horizontal: 20,
//                                     //   vertical: 12,
//                                     // ),
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(33.0),
//                                     ),
//                                     backgroundColor:
//                                         Color.fromARGB(255, 59, 138, 207),
//                                     minimumSize: Size(10, 30),
//                                   ),
//                                   child: Text(
//                                     'View Details',
//                                     style: TextStyle(
//                                       color: Colors.white,
//                                       fontSize: 16,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//       bottomNavigationBar: BottomAppBar(
//         color: Color.fromARGB(255, 255, 255, 255),
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16.0),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               _buildIconButtonWithLabel(
//                 Icons.query_stats,
//                 'Statistics',
//                 Color.fromARGB(255, 210, 229, 245),
//                 () {
//                   ////
//                 },
//               ),
//               _buildIconButtonWithLabel(
//                 Icons.home,
//                 'Home',
//                 Color.fromARGB(255, 249, 194, 212),
//                 () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) =>
//                           HomeScreenCenter(centerName: centerName),
//                     ),
//                   );
//                 },
//               ),
//               _buildIconButtonWithLabel(
//                 Icons.add,
//                 'Add Program',
//                 Color.fromARGB(255, 249, 194, 212),
//                 () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) =>
//                           ServiceFormScreen(onServiceAdded: reloadServices),
//                     ),
//                   );
//                 },
//               ),
//               _buildIconButtonWithLabel(
//                 Icons.person,
//                 'Profile',
//                 Color.fromARGB(255, 249, 194, 212),
//                 () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => CenterProfileViewScreen(),
//                     ),
//                   );
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//     );
//   }

//   Widget _buildIconButtonWithLabel(
//     IconData iconData,
//     String label,
//     Color iconColor,
//     VoidCallback onPressed,
//   ) {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         IconButton(
//           icon: Icon(
//             iconData,
//             size: 35,
//           ),
//           color: iconColor,
//           onPressed: onPressed,
//         ),
//         Text(
//           label,
//           style: TextStyle(
//             fontSize: 14,
//             color: Colors.black,
//           ),
//         ),
//       ],
//     );
//   }

// // Outside the build method, create the method to show detailed information in a pop-up
//   void _showServiceDetails(Service service) {
//     showCupertinoModalPopup(
//       context: context,
//       builder: (BuildContext context) {
//         return Container(
//           decoration: BoxDecoration(
//             // color: const Color.fromARGB(255, 234, 212, 219),
//             color: Color.fromARGB(255, 239, 249, 254),

//             borderRadius: BorderRadius.vertical(
//                 top: Radius.circular(20.0)), // Customize the shape here
//           ),
//           child: CupertinoActionSheet(
//             title: Text(
//               'Program Details',
//               style: TextStyle(fontSize: 16.0, color: Colors.black),
//             ),
//             message: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Program Description: ${service.description}',
//                   style: TextStyle(fontSize: 16.0, color: Colors.black),
//                 ),
//                 Text(
//                   'Program price: ${service.servicePrice}',
//                   style: TextStyle(fontSize: 16.0, color: Colors.black),
//                 ),

//                 Text(
//                   'Start Date: ${DateFormat('MM/dd/yyyy').format(service.selectedStartDate)}',
//                   style: TextStyle(fontSize: 16.0, color: Colors.black),
//                 ),
//                 Text(
//                   'End Date: ${DateFormat('MM/dd/yyyy').format(service.selectedEndDate)}',
//                   style: TextStyle(fontSize: 16.0, color: Colors.black),
//                 ),
//                 Text(
//                   'Program Capacity: ${service.capacityValue}',
//                   style: TextStyle(fontSize: 16.0, color: Colors.black),
//                 ),

//                 // Include other details you want to display here
//               ],
//             ),
//             actions: [
//               CupertinoActionSheetAction(
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//                 child: Text(
//                   'Close',
//                   style: TextStyle(
//                     color: Colors
//                         .black, // Change text color for the 'Close' button
//                   ),
//                 ),
//               )
//             ],
//           ),
//         );
//       },
//     );
//   }
// }

// Widget _buildIconButtonWithLabel(
//   IconData iconData,
//   String label,
//   Color iconColor,
//   VoidCallback onPressed,
// ) {
//   return Column(
//     mainAxisSize: MainAxisSize.min,
//     children: [
//       IconButton(
//         icon: Icon(
//           iconData,
//           size: 35,
//         ),
//         color: iconColor,
//         onPressed: onPressed,
//       ),
//       Text(
//         label,
//         style: TextStyle(
//           fontSize: 14,
//           color: Colors.black,
//         ),
//       ),
//     ],
//   );
// }

// Future<double> calculateAverageRating(String serviceName) async {
//   try {
//     final QuerySnapshot snapshot = await FirebaseFirestore.instance
//         .collection('ServiceBook')
//         .where('serviceName', isEqualTo: serviceName)
//         .get();

//     if (snapshot.docs.isEmpty) {
//       return 0.0;
//     }

//     int sumOfStars = 0;
//     int totalServices = 0;

//     snapshot.docs.forEach((doc) {
//       final data = doc.data()
//           as Map<String, dynamic>?; // Cast to Map<String, dynamic> or null
//       final starsRate = data?['starsrate']; // Use null-aware access

//       if (starsRate != null && starsRate is int) {
//         sumOfStars += starsRate;
//         totalServices++;
//       }
//     });

//     return totalServices > 0 ? sumOfStars / totalServices.toDouble() : 0.0;
//   } catch (e) {
//     print('Error calculating average rating: $e');
//     return 0.0;
//   }
// }

// Future<int> calculateTotalRatedServices(String serviceName) async {
//   try {
//     final QuerySnapshot snapshot = await FirebaseFirestore.instance
//         .collection('ServiceBook')
//         .where('serviceName', isEqualTo: serviceName)
//         .get();

//     if (snapshot.docs.isEmpty) {
//       return 0;
//     }

//     int totalServices = 0;

//     snapshot.docs.forEach((doc) {
//       final data = doc.data() as Map<String, dynamic>?;

//       final starsRate = data?['starsrate'];

//       if (starsRate != null && starsRate is int) {
//         totalServices++;
//       }
//     });

//     return totalServices;
//   } catch (e) {
//     print('Error calculating total services: $e');
//     return 0;
//   }
// }

//------

import 'package:baheej/screens/CenterProfileScreen.dart';
import 'package:baheej/screens/HomeScreenCenter.dart';
import 'package:baheej/screens/ServiceFormScreen.dart';
import 'package:baheej/screens/SignInScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart'; // Make sure to import the Cupertino library
import 'package:flutter/material.dart';
import 'dart:math';

import 'package:intl/intl.dart';
import 'package:baheej/screens/Service.dart'; // Import the Service class if it's in a separate file

class compSerListScreen extends StatefulWidget {
  //final String centerName;
  //compSerListScreen({required this.centerName});

  final String? centerName;

  compSerListScreen({required this.centerName});

  @override
  _compSerListScreenState createState() => _compSerListScreenState();
}

class _compSerListScreenState extends State<compSerListScreen> {
  List<Service> completedServices = [];
  // CenterProfile? _centerProfile;
  List<Service> services = []; // Add this line
  List<Service> filteredServices = []; // Add this line
  String centerName = '';

  @override
  void initState() {
    super.initState();
    loadCompletedServices();
  }

// Define a function to create a gradient for the progress bar
  LinearGradient _buildProgressBarGradient() {
    return LinearGradient(
      colors: [
        Colors.pink,
        Colors.green,
        Colors.yellow,
        Colors.orange,
        Colors.purple,
        Colors.blue,
      ],
      stops: [
        0.0,
        0.2,
        0.4,
        0.6,
        0.8,
        1.0,
      ],
    );
  }

  //function to create random colors of card
  final _random = Random();
  final List<Color> _randomColors = [
    Color.fromARGB(255, 252, 222, 233),
    Color.fromARGB(255, 210, 229, 245),
    Color.fromARGB(255, 251, 242, 212),
    // Add more colors if needed
  ];

  Color _getRandomColor() {
    return _randomColors[_random.nextInt(_randomColors.length)];
  }

  int _totalRatedServices = 0;

  Future<double> calculateBookingRatio(Service service) async {
    if (service.capacityValue > 0) {
      // Fetch the booked services for the logged-in center
      int bookedServicesCount =
          await getBookedServicesCount(service.centerName);

      // Calculate the booking ratio
      return bookedServicesCount > 0
          ? bookedServicesCount / service.capacityValue
          : 0.0;
    } else {
      return 0.0; // Handle the case where capacityValue is 0 to avoid division by zero
    }
  }

  void _dummyServiceAddedFunction() {
    // This function intentionally left blank.
  }
// Fetch the number of booked services for the specified center
  Future<int> getBookedServicesCount(String centerName) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userId = user.uid;

      try {
        final QuerySnapshot snapshot = await FirebaseFirestore.instance
            .collection('ServiceBook')
            .where('centerName', isEqualTo: centerName)
            .get();

        return snapshot.size; // Return the count of booked services
      } catch (e) {
        print('Error fetching booked services: $e');
      }
    }

    return 0; // Return 0 in case of an error or no booked services
  }

  static String formatServiceInfo(Service service) {
    return """
      Service Name: ${service.serviceName}
      Description: ${service.description}
      Center Name: ${service.centerName}
      Start Date: ${service.selectedStartDate}
      End Date: ${service.selectedEndDate}
      Min Age: ${service.minAge}
      Max Age: ${service.maxAge}
      Capacity: ${service.capacityValue}
      Service Price: ${service.servicePrice}
      Time Slot: ${service.selectedTimeSlot}
    """;
  }

  Future<void> loadCompletedServices() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userId = user.uid;
      final centerDoc = await FirebaseFirestore.instance
          .collection('center')
          .doc(userId)
          .get();
      if (centerDoc.exists) {
        // Now you can use centerDoc.data() to access the data
        centerName = centerDoc.data()!['username'];
      }

      final snapshot = await FirebaseFirestore.instance
          .collection('center-service')
          .where('centerName', isEqualTo: widget.centerName)
          .get();
      final currentDate = DateTime.now();
      final List<Service?> loadedServices =
          await Future.wait(snapshot.docs.map((doc) async {
        final data = doc.data() as Map<String, dynamic>;
        DateTime selectedStartDate;
        DateTime selectedEndDate;

        if (data['startDate'] is String) {
          selectedStartDate = DateTime.parse(data['startDate'] as String);
        } else if (data['startDate'] is Timestamp) {
          selectedStartDate = (data['startDate'] as Timestamp).toDate();
        } else {
          selectedStartDate = DateTime.now();
        }

        if (data['endDate'] is String) {
          selectedEndDate = DateTime.parse(data['endDate'] as String);
        } else if (data['endDate'] is Timestamp) {
          selectedEndDate = (data['endDate'] as Timestamp).toDate();
        } else {
          selectedEndDate = DateTime.now();
        }

        if (selectedEndDate.isBefore(currentDate)) {
          // List<String> subscribedUsers = await getSubscribedUsers(doc.id);
          final participantNo = data['participateNo'] ?? 0;

          return Service(
            id: doc.id,
            serviceName:
                data['serviceName'] as String? ?? 'Service Name Missing',
            description:
                data['serviceDesc'] as String? ?? 'Description Missing',
            centerName: data['centerName'] as String? ?? 'Center Name Missing',
            selectedStartDate: selectedStartDate,
            selectedEndDate: selectedEndDate,
            minAge: data['minAge'] as int? ?? 0,
            maxAge: data['maxAge'] as int? ?? 0,
            capacityValue: data['serviceCapacity'] as int? ?? 0,
            servicePrice: data['servicePrice'] is double
                ? data['servicePrice']
                : (data['servicePrice'] is int
                    ? (data['servicePrice'] as int).toDouble()
                    : 0.0),
            selectedTimeSlot:
                data['selectedTimeSlot'] as String? ?? 'Time Slot Missing',
            participateNo: participantNo,
            starsrate: data['starsrate'] as int? ?? 0,
          );
        } else {
          return null;
        }
      }));

      setState(() {
        services = loadedServices
            .where((service) => service != null)
            .cast<Service>()
            .toList();
        filteredServices = loadedServices
            .where((service) => service != null)
            .cast<Service>()
            .toList();
      });
    }
  }

  double calculatePercentageBooked(int capacity, int participants) {
    if (capacity <= 0) {
      return 0.0; // Return 0 if capacity is invalid
    }

    return (participants / capacity) * 100; // Calculate percentage booked
  }

  Future<void> _handleLogout() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Are You Sure?'),
          content: Text('Do you want to log out?'),
          actions: <Widget>[
            TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Yes'),
              onPressed: () async {
                Navigator.of(context).pop();
                try {
                  await FirebaseAuth.instance.signOut();
                  showLogoutSuccessDialog();
                } catch (e) {
                  print("Error signing out: $e");
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> loadServices() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userId = user.uid;

      // Fetch user center data
      final centerDoc = await FirebaseFirestore.instance
          .collection('center')
          .doc(userId)
          .get();
      if (centerDoc.exists) {
        // Now you can use centerDoc.data() to access the data
        centerName = centerDoc.data()!['username'];
      }

      final snapshot = await FirebaseFirestore.instance
          .collection('center-service')
          .where('centerName', isEqualTo: widget.centerName)
          .get();
      final currentDate = DateTime.now(); // Get the current date
      final List<Service> loadedServices = snapshot.docs
          .map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            DateTime selectedStartDate;
            DateTime selectedEndDate;

            // Check if the 'startDate' and 'endDate' are stored as strings or timestamps
            if (data['startDate'] is String) {
              selectedStartDate = DateTime.parse(data['startDate'] as String);
            } else if (data['startDate'] is Timestamp) {
              selectedStartDate = (data['startDate'] as Timestamp).toDate();
            } else {
              selectedStartDate = DateTime.now();
            }

            if (data['endDate'] is String) {
              selectedEndDate = DateTime.parse(data['endDate'] as String);
            } else if (data['endDate'] is Timestamp) {
              selectedEndDate = (data['endDate'] as Timestamp).toDate();
            } else {
              selectedEndDate = DateTime.now();
            }
            final participantNo = data['participateNo'] ?? 0;

            // Check if the start date is today or earlier
            if (!selectedStartDate.isBefore(currentDate)) {
              return Service(
                id: doc.id,
                serviceName:
                    data['serviceName'] as String? ?? 'Service Name Missing',
                description:
                    data['serviceDesc'] as String? ?? 'Description Missing',
                centerName:
                    data['centerName'] as String? ?? 'Center Name Missing',
                selectedStartDate: selectedStartDate,
                selectedEndDate: selectedEndDate,
                minAge: data['minAge'] as int? ?? 0,
                maxAge: data['maxAge'] as int? ?? 0,
                capacityValue: data['serviceCapacity'] as int? ?? 0,
                servicePrice: data['servicePrice'] is double
                    ? data['servicePrice']
                    : (data['servicePrice'] is int
                        ? (data['servicePrice'] as int).toDouble()
                        : 0.0),
                selectedTimeSlot:
                    data['selectedTimeSlot'] as String? ?? 'Time Slot Missing',
                participateNo: participantNo,
                starsrate: data['starsrate'] as int? ?? 0,
              );
            } else {
              // Return null for services with start dates in the past or today
              return null;
            }
          })
          .where((service) => service != null) // Filter out null values
          .cast<Service>() // Cast the list to Service
          .toList();

      setState(() {
        services = loadedServices;
        filteredServices = loadedServices;
      });
    }
  }

  void reloadServices() async {
    await loadServices();
  }

  void showLogoutSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Logout Successful'),
          content: Text('You have successfully logged out.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                navigateToSignInScreen();
              },
            ),
          ],
        );
      },
    );
  }

  void navigateToSignInScreen() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => SignInScreen()),
      (route) => false, // Remove all routes in the stack
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          'Programs Statistics',
          style: TextStyle(
            fontFamily: '5yearsoldfont', // Use the defined font family
            fontSize: 25, // Adjust the font size as needed
            fontWeight: FontWeight.bold, // Replace with your font family name
          ),
          // textAlign: TextAlign.center, // Align the text's content in the center
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              _handleLogout();
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/stat.png',
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 100, left: 16, right: 16),
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: services.length,
                    itemBuilder: (context, index) {
                      final service = services[index];
                      return Card(
                        elevation: 3,
                        margin: EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 16,
                        ),
                        color: _getRandomColor(),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Program Name: ',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    service.serviceName,
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                              Divider(),
                              Row(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            'Booked Capacity Percentage: ',
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(width: 8),
                                          Text(
                                            '(${service.participateNo} / ${service.capacityValue})',
                                            style: TextStyle(
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            '${calculatePercentageBooked(service.capacityValue, service.participateNo).toStringAsFixed(2)}%',
                                            style: TextStyle(
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 8),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.7,
                                        height: 8,
                                        decoration: BoxDecoration(
                                          color: Colors.grey[300],
                                          borderRadius:
                                              BorderRadius.circular(4.0),
                                        ),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(4.0),
                                          child: LinearProgressIndicator(
                                            value: calculatePercentageBooked(
                                                  service.capacityValue,
                                                  service.participateNo,
                                                ) /
                                                100.0,
                                            backgroundColor: Colors.grey[300],
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                              _buildProgressBarGradient()
                                                  .colors
                                                  .last,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    'Average Rating: ',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  FutureBuilder<double>(
                                    future: calculateAverageRating(
                                        service.serviceName),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return CircularProgressIndicator();
                                      } else if (snapshot.hasError) {
                                        return Text('Error');
                                      } else {
                                        double averageRating = snapshot.data!;

                                        return FutureBuilder<int>(
                                          future: calculateTotalRatedServices(
                                              service.serviceName),
                                          builder: (context,
                                              totalRatedServicesSnapshot) {
                                            if (totalRatedServicesSnapshot
                                                    .connectionState ==
                                                ConnectionState.waiting) {
                                              return CircularProgressIndicator();
                                            } else if (totalRatedServicesSnapshot
                                                .hasError) {
                                              return Text('Error');
                                            } else {
                                              int totalRatedServices =
                                                  totalRatedServicesSnapshot
                                                      .data!;

                                              return Row(
                                                children: [
                                                  Text(
                                                    '($totalRatedServices)',
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                  SizedBox(width: 5),
                                                  Text(
                                                    '${averageRating.toStringAsFixed(2)}',
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                  SizedBox(width: 5),
                                                  Icon(
                                                    Icons.star,
                                                    color: Colors.amber,
                                                    size: 20,
                                                  ),
                                                ],
                                              );
                                            }
                                          },
                                        );
                                      }
                                    },
                                  ),
                                ],
                              ),

                              // Add an Align widget to position the button to the bottom right
                              Align(
                                alignment: Alignment.bottomRight,
                                child: ElevatedButton(
                                  onPressed: () {
                                    _showServiceDetails(service);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary: Color.fromARGB(255, 59, 138, 207),
                                    textStyle: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    // padding: EdgeInsets.symmetric(
                                    //   horizontal: 20,
                                    //   vertical: 12,
                                    // ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(33.0),
                                    ),
                                    backgroundColor:
                                        Color.fromARGB(255, 59, 138, 207),
                                    minimumSize: Size(10, 30),
                                  ),
                                  child: Text(
                                    'View Details',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Color.fromARGB(255, 255, 255, 255),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildIconButtonWithLabel(
                Icons.query_stats,
                'Statistics',
                Color.fromARGB(255, 210, 229, 245),
                () {
                  ////
                },
              ),
              _buildIconButtonWithLabel(
                Icons.home,
                'Home',
                Color.fromARGB(255, 249, 194, 212),
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          HomeScreenCenter(centerName: centerName),
                    ),
                  );
                },
              ),
              _buildIconButtonWithLabel(
                Icons.add,
                'Add Program',
                Color.fromARGB(255, 249, 194, 212),
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ServiceFormScreen(onServiceAdded: reloadServices),
                    ),
                  );
                },
              ),
              _buildIconButtonWithLabel(
                Icons.person,
                'Profile',
                Color.fromARGB(255, 249, 194, 212),
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CenterProfileViewScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildIconButtonWithLabel(
    IconData iconData,
    String label,
    Color iconColor,
    VoidCallback onPressed,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(
            iconData,
            size: 35,
          ),
          color: iconColor,
          onPressed: onPressed,
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

// Outside the build method, create the method to show detailed information in a pop-up
  void _showServiceDetails(Service service) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            // color: const Color.fromARGB(255, 234, 212, 219),
            color: Color.fromARGB(255, 239, 249, 254),

            borderRadius: BorderRadius.vertical(
                top: Radius.circular(20.0)), // Customize the shape here
          ),
          child: CupertinoActionSheet(
            title: Text(
              'Program Details',
              style: TextStyle(fontSize: 16.0, color: Colors.black),
            ),
            message: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Program Description: ${service.description}',
                  style: TextStyle(fontSize: 16.0, color: Colors.black),
                ),
                Text(
                  'Program price: ${service.servicePrice}',
                  style: TextStyle(fontSize: 16.0, color: Colors.black),
                ),

                Text(
                  'Start Date: ${DateFormat('MM/dd/yyyy').format(service.selectedStartDate)}',
                  style: TextStyle(fontSize: 16.0, color: Colors.black),
                ),
                Text(
                  'End Date: ${DateFormat('MM/dd/yyyy').format(service.selectedEndDate)}',
                  style: TextStyle(fontSize: 16.0, color: Colors.black),
                ),
                Text(
                  'Program Capacity: ${service.capacityValue}',
                  style: TextStyle(fontSize: 16.0, color: Colors.black),
                ),

                // Include other details you want to display here
              ],
            ),
            actions: [
              CupertinoActionSheetAction(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Close',
                  style: TextStyle(
                    color: Colors
                        .black, // Change text color for the 'Close' button
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}

Widget _buildIconButtonWithLabel(
  IconData iconData,
  String label,
  Color iconColor,
  VoidCallback onPressed,
) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      IconButton(
        icon: Icon(
          iconData,
          size: 35,
        ),
        color: iconColor,
        onPressed: onPressed,
      ),
      Text(
        label,
        style: TextStyle(
          fontSize: 14,
          color: Colors.black,
        ),
      ),
    ],
  );
}

Future<double> calculateAverageRating(String serviceName) async {
  try {
    final QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('ServiceBook')
        .where('serviceName', isEqualTo: serviceName)
        .get();

    if (snapshot.docs.isEmpty) {
      return 0.0;
    }

    int sumOfStars = 0;
    int totalServices = 0;

    snapshot.docs.forEach((doc) {
      final data = doc.data()
          as Map<String, dynamic>?; // Cast to Map<String, dynamic> or null
      final starsRate = data?['starsrate']; // Use null-aware access

      if (starsRate != null && starsRate is int) {
        sumOfStars += starsRate;
        totalServices++;
      }
    });

    return totalServices > 0 ? sumOfStars / totalServices.toDouble() : 0.0;
  } catch (e) {
    print('Error calculating average rating: $e');
    return 0.0;
  }
}

Future<int> calculateTotalRatedServices(String serviceName) async {
  try {
    final QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('ServiceBook')
        .where('serviceName', isEqualTo: serviceName)
        .get();

    if (snapshot.docs.isEmpty) {
      return 0;
    }

    int totalServices = 0;

    snapshot.docs.forEach((doc) {
      final data = doc.data() as Map<String, dynamic>?;

      final starsRate = data?['starsrate'];

      if (starsRate != null && starsRate is int) {
        totalServices++;
      }
    });

    return totalServices;
  } catch (e) {
    print('Error calculating total services: $e');
    return 0;
  }
}
