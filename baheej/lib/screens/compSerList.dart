import 'package:baheej/screens/CenterProfileScreen.dart';
import 'package:baheej/screens/HomeScreenCenter.dart';
import 'package:baheej/screens/ServiceFormScreen.dart';
import 'package:baheej/screens/SignInScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart'; // Make sure to import the Cupertino library

import 'package:intl/intl.dart';
import 'package:baheej/screens/Service.dart'; // Import the Service class if it's in a separate file

class compSerListScreen extends StatefulWidget {
  final String centerName;

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
        title: Text(' Programs Statistics'),
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
              'assets/images/backG.png',
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 160, left: 16, right: 16),
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: services.length,
                    itemBuilder: (context, index) {
                      final service = services[index];
                      // or filteredServices[index]

                      return Card(
                          elevation: 3,
                          margin:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                          color: Color.fromARGB(255, 239, 249, 254),
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
                                    // Row(
                                    //   children: [
                                    //     Text(
                                    //       'Service Price: ',
                                    //       style: TextStyle(
                                    //         fontSize: 16,
                                    //         fontWeight: FontWeight.bold,
                                    //       ),
                                    //     ),
                                    //     Text(
                                    //       '${service.servicePrice.toStringAsFixed(2)}',
                                    //       style: TextStyle(
                                    //         fontSize: 16,
                                    //       ),
                                    //     ),
                                    //   ],
                                    // ),
                                    Divider(),
                                    Row(
                                      children: [
                                        Text(
                                          'Booked Capacity Percentage: ',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          '${calculatePercentageBooked(service.capacityValue, service.participateNo).toStringAsFixed(2)}%',
                                          style: TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'Average Rating: ',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        FutureBuilder<double>(
                                          future: calculateAverageRating(
                                              service.serviceName),
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return CircularProgressIndicator(); // Show loading indicator
                                            } else if (snapshot.hasError) {
                                              return Text(
                                                  'Error'); // Show error message
                                            } else {
                                              return Text(
                                                '${snapshot.data!.toStringAsFixed(2)}',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                ),
                                              );
                                            }
                                          },
                                        ),
                                      ],
                                    ),

                                    TextButton(
                                      onPressed: () {
                                        _showServiceDetails(
                                          service,
                                        ); // Create a method to show details
                                      },
                                      child: Text(
                                        'More Details',
                                        style: TextStyle(
                                          color: Color.fromARGB(255, 0, 0, 0),
                                          fontSize: 16,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    ),
                                  ])));
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        color: Color.fromARGB(255, 245, 198, 239),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(width: 24),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.home),
                  color: Colors.white,
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomeScreenCenter(
                          centerName: centerName,
                        ),
                      ),
                      (route) => false,
                    );
                  },
                ),
                Text(
                  'Home',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            SizedBox(),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 50),
                  child: Text(
                    '        Add Programs',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(width: 25),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.person),
                  color: Colors.white,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CenterProfileViewScreen(),
                      ),
                    );

                    // Handle profile button tap
                  },
                ),
                Text(
                  'Profile',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            SizedBox(width: 32),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromARGB(255, 174, 207, 250),
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  ServiceFormScreen(onServiceAdded: _dummyServiceAddedFunction),
            ),
          );
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
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
