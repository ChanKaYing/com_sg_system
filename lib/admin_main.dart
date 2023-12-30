import 'dart:async';

import 'package:com_sg_system/camera_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:com_sg_system/admin_payment.dart';
import 'package:com_sg_system/admin_useraccount.dart';

import 'package:com_sg_system/admin_notification.dart';
import 'package:com_sg_system/facility.dart';
import 'package:com_sg_system/user_familydetail.dart';
import 'package:com_sg_system/login_page.dart';
import 'package:com_sg_system/user_pubspace.dart';
import 'package:com_sg_system/admin_register.dart';
import 'package:com_sg_system/admin_profile.dart';
import 'package:com_sg_system/user_notification.dart';
import 'package:com_sg_system/admin_profile.dart';
import 'package:flutter/material.dart';

import 'admin_familydetail.dart';
import 'admin_profile.dart';
import 'user_appoint_car.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Admin Main Page',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}

class AdminMainPage extends StatelessWidget {

  String adminName;
  AdminMainPage({required this.adminName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome, $adminName'), // Display the admin's name in the app bar
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginApp()),
              );
            },
          ),
        ],
      ),

      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('images/harphome.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    color: Colors.grey.withOpacity(0.5), // Colored background bar
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 85),// Adjust padding as needed
                    child: Text(
                      'Navigation',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            ListTile(
              title: Text('Notification'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AdminNotificationPage(adminName: adminName), // Pass the admin's name here
                  ),
                );
              },
            ),
            ListTile(
              title: Text('Pre-Register'),
              onTap: () {
                //             Navigator.push(
                //              context,
                //              MaterialPageRoute(builder: (context) => UserAppointmentPage()),
                //            );
              },
            ),
            ListTile(
              title: Text('Facility'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FacilityPage()),
                );
              },
            ),
            ListTile(
              title: Text('Public Space'),
              onTap: () {
    //            Navigator.push(
    //              context,
    //              MaterialPageRoute(builder: (context) => PubSpaceAppointmentPage(adminName: adminName)),
    //            );
              },
            ),
            ListTile(
              title: Text('Payment Detail'),
              onTap: () {
                //      Navigator.push(
                //        context,
                //        MaterialPageRoute(builder: (context) => AdminPayment()),
                //      );
              },
            ),
            ListTile(
              title: Text('Card'),
              onTap: () {
                ////////////////////////////////////////////////////////////////////////////////////no item
              },
            ),
            ListTile(
              title: Text('Family Detail'),
              onTap: () {
                //       Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //           builder: (context) => AdminFamilyPage(uid:adminName),
                //        ),
                //      );
              },
            ),
            ListTile(
              title: Text('Visitor Data'),
              onTap: () {
                ////////////////////////////////////////////////////////////////////////////////////no item
              },
            ),
            ListTile(
              title: Text('Users Account'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UsersAccountPage()),
                );
              },
            ),

            Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Colors.grey,
                    width: 1.0,
                  ),
                ),
              ),
              child: ListTile(
                title: Text(
                  'Profile',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black, // Customize the color as needed
                  ),
                  textAlign: TextAlign.center,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AdminProfilePage(adminName: adminName,)),
                  );
                },
              ),
            ),

          ],
        ),
      ),


      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CardWidget(),

            SizedBox(height: 8),

            Text(
              'Notification',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              color: Colors.grey[200], // Notification bar background color
              child: Column(
                children: [
                  Text(
                    'Payment Detail: Your community maintenance fee is due, please pay it before September 1st',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14),
                  ),
                  SizedBox(height: 10), // Adding some spacing between the two Text widgets
                  TextButton(
                    onPressed: () {
                      // Navigate to another page here
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AdminNotificationPage(adminName: adminName), // Pass the admin's name here
                        ),
                      );
                    },
                    child: Text('Click for more'),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),

            Text(
              'Pre-Register',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            ImageButtonsRow1(),
            SizedBox(height: 20),

            Text(
              'About Resident',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            ImageButtonsRow2(uid:adminName, adminName: '',),
            SizedBox(height: 8),

            ImageButtonsRow3(),
            SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}



class CardWidget extends StatefulWidget {
  @override
  _CardWidgetState createState() => _CardWidgetState();
}

class _CardWidgetState extends State<CardWidget> {
  int _currentIndex = 0;

  List<String> _imagePaths = [
    "images/pool1.png",
    "images/house.png",
    "images/apartment.jpg",
    "images/malaysiaday.jpg",
  ];

  final double _fixedImageWidth = 250;

  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 3), _swapImage);
  }

  void _swapImage(Timer timer) {
    setState(() {
      _currentIndex = (_currentIndex + 1) % _imagePaths.length;
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: EdgeInsets.all(8),
        child:Container(
          width: 300, // Set the fixed width for the card
          height: 270, // Set the fixed height for the card

          child:Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Community Security System',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Image.asset(
                        _imagePaths[_currentIndex], // Use the current image path
                        width: _fixedImageWidth, // Use the fixed image width
                        height: _fixedImageWidth * (3 / 4), // Calculate height based on original aspect ratio

                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
    );
  }
}

class ImageButtonsRow1 extends StatelessWidget {

 // String adminName;
 // ImageButtonsRow1({required this.adminName, required String uid});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ImageButtonWithText(
          image: AssetImage("images/preregister.png"),
          text: "Pre-Register",
          width: 90,
          height: 90,
          onPressed: () {
            //        Navigator.push(
            //           context,
            //         MaterialPageRoute(builder: (context) => UserAppointmentPage()),
            //       );
          },
        ),
        ImageButtonWithText(
          image: AssetImage("images/facility.png"),
          text: "Facility",
          width: 80,
          height: 90,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => FacilityPage()),
            );
          },
        ),
        ImageButtonWithText(
          image: AssetImage("images/publicspace.png"),
          text: "Public Space",
          width: 95,
          height: 95,
          onPressed: () {
    //        Navigator.push(
    //          context,
    //          MaterialPageRoute(builder: (context) => PubSpaceAppointmentPage(adminName: adminName)),
    //        );
          },
        ),
      ],
    );
  }
}

class ImageButtonsRow2 extends StatelessWidget {

  String adminName;
  ImageButtonsRow2({required this.adminName, required String uid});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ImageButtonWithText(
          image: AssetImage("images/payment.png"),
          text: "Payment",
          width: 80,
          height: 80,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AdminPaymentPage()),
            );
          },
        ),
        ImageButtonWithText(
          image: AssetImage("images/card.png"),
          text: "Card",
          width: 80,
          height: 80,
          onPressed: () {
            ///////////////////////////////////////////////////////////////////////////////no item
          },
        ),
        ImageButtonWithText(
          image: AssetImage("images/family.png"),
          text: "Family Detail",
          width: 80,
          height: 80,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AdminFamilyPage(),
              ),
            );
          },
        ),
      ],
    );
  }
}

class ImageButtonsRow3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ImageButtonWithText(
          image: AssetImage("images/register.png"),
          text: "Users Account",
          width: 80,
          height: 80,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => UsersAccountPage()),
            );
          },
        ),
        ImageButtonWithText(
          image: AssetImage("images/visitor.png"),
          text: "Visitor",
          width: 80,
          height: 80,
          onPressed: () {
            ///////////////////////////////////////////////////////////////////////////////no item
          },
        ),

        ImageButtonWithText(
          image: AssetImage("images/visitor.png"),
          text: "Camera",
          width: 80,
          height: 80,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CamPage()),
            );
          },
        ),
      ],
    );
  }
}

class ImageButtonWithText extends StatelessWidget {
  final ImageProvider image;
  final String text;
  final double width;
  final double height;
  final VoidCallback onPressed;

  const ImageButtonWithText({
    required this.image,
    required this.text,
    required this.width,
    required this.height,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onPressed,
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Image(image: image, width: width, height: height),
          ),
        ),
        Text(
          text,
          style: TextStyle(fontSize: 14),
        ),
      ],
    );
  }
}