import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:com_sg_system/admin_appoint_car.dart';
import 'package:com_sg_system/admin_appoint_facility.dart';
import 'package:com_sg_system/admin_appoint_pubspace.dart';
import 'package:com_sg_system/camera_in.dart';
import 'package:com_sg_system/emergency_detail.dart';
import 'package:com_sg_system/visitor_data.dart';
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
  bool isguard=false;
  AdminMainPage({required this.adminName});

  Future<void> isGuard() async{
    if(adminName=="guard"){
      isguard=true;
    }
    else{
      isguard=false;
    }
  }

  @override
  Widget build(BuildContext context) {
    isGuard();
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
                             Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => AdminDisplayAppointments()),
                            );
              },
            ),
            ListTile(
              title: Text('Facility'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AdminAppointFacility()),
                );
              },
            ),

            //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
            ListTile(
              title: Text('Public Space'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AdminAppointPubSpace()),
                );
              },
            ),
            ListTile(
              title: Text('Payment Detail'),
              onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AdminPaymentPage()),
                      );
              },
            ),


            ListTile(
              title: Text('Visitor Data'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => VisitorData()),
                );
                },
            ),
            ListTile(
              title: Text('Users Account'),
              onTap: () {
                print("ISGUARD? = ${isguard}");
                !isguard?
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UsersAccountPage()),
                )
                    :ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('You are not allowed to access'),
                  ),
                );
              },
            ),
          ],
        ),
      ),


      body: SingleChildScrollView(

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CardWidget(adminName: adminName,),
/*
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

 */

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

            ImageButtonsRow3(uid:adminName, adminName: adminName,),

            SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}



class CardWidget extends StatefulWidget {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final String adminName;

  CardWidget({required this.adminName});

  @override
  _CardWidgetState createState() => _CardWidgetState(adminName: adminName);
}

class _CardWidgetState extends State<CardWidget> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  int _currentIndex = 0;
  String notiText="";
  List<String> notiList=['Welcome Back'];//////////////////////////////////////////////////////////////////////////////bug
  int _notiIndex = 0;

  final String adminName;

  _CardWidgetState({required this.adminName});

  List<String> _imagePaths = [
    "images/pool1.png",
    "images/house.png",
    "images/apartment.jpg",
    "images/malaysiaday.jpg",
  ];

  final double _fixedImageWidth = 250;

  late Timer _timer;
  late Timer _timer2;
  late Timer _timer3;
  late Timer _timer4;
  late Timer _timer5;


  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 3), _swapImage);
    _timer2 = Timer.periodic(Duration(seconds: 5), getNotiList);
    _timer3 = Timer.periodic(Duration(seconds: 2), changeNotiText);
    _timer4 = Timer.periodic(Duration(seconds: 60), refreshCarRegister);
    _timer5= Timer.periodic(Duration(seconds: 2), _emergency);
  }

  void _swapImage(Timer timer) {
    setState(() {
      _currentIndex = (_currentIndex + 1) % _imagePaths.length;
    });
  }

  Future<void> _emergency(Timer t) async {
    QuerySnapshot querySnapshot = await _firestore.collection('emergency').get();
    if(querySnapshot.docs.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('EMERGENCY'),
            action: SnackBarAction(
              label: 'Check More',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EmergencyDetail()),
                );
              },
            )
        ),
      );
    }

  }

  Future<void> getNotiList(Timer t) async {
    QuerySnapshot querySnapshot = await _firestore.collection("notifications").get();
    for(var doc in querySnapshot.docs){
      notiList.add(doc['title']+": "+doc['details']);
    }
  }

  Future<void> changeNotiText(Timer t) async{
    _notiIndex++;
    if(notiList.length!=0){
      print("KEKE");
      print(notiList.length);
      notiText = notiList[_notiIndex % notiList.length];
    }
    else{
      notiText = "Welcome Back";
    }
    print("PPIPI");
    print(_notiIndex);
  }

  Future<void> refreshCarRegister(Timer t) async{
    QuerySnapshot querySnapshot = await _firestore.collection('carregister').get();
    for(var doc in querySnapshot.docs){
      var estimateCheckin = doc['checkindate']+" "+doc['checkintime'];
      print(estimateCheckin);
      if(DateTime.now().isAfter(DateTime.parse(estimateCheckin).add(Duration(minutes: 30)))){
        print("DELETE CARREG OF ${doc.id}");
        await FirebaseFirestore.instance
            .collection('carregister')
            .doc(doc.id)
            .delete();
      }
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    _timer2.cancel();
    _timer3.cancel();
    _timer4.cancel();
    _timer5.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: EdgeInsets.all(8),
        child:Container(
          width: 300, // Set the fixed width for the card
          height: 500, // Set the fixed height for the card

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
                      SizedBox(height: 10),
                      Expanded(child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                            height: 200,
                            color: Colors.grey[200], // Notification bar background color
                            child: Column(
                              children: [
                                Text("Notification",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                                ),
                                Text(notiText,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 15),
                                ),
                                SizedBox(height: 10),
                                Spacer(),// Adding some spacing between the two Text widgets
                                TextButton(
                                  onPressed: () {
                                    // Navigate to another page here
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => AdminNotificationPage(adminName: adminName)),
                                    );
                                  },
                                  child: Text('Click for more'),
                                ),
                              ],
                            ),
                          )
                        ],
                      )),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
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
                    Navigator.push(
                       context,
                     MaterialPageRoute(builder: (context) => AdminDisplayAppointments()),
                   );
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
              MaterialPageRoute(builder: (context) => AdminAppointFacility()),
            );
          },
        ),
        ImageButtonWithText(
          image: AssetImage("images/publicspace.png"),
          text: "Public Space",
          width: 90,
          height: 90,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AdminAppointPubSpace()),
            );
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
          image: AssetImage("images/visitor.png"),
          text: "Visitor",
          width: 80,
          height: 80,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => VisitorData()),
            );
          },
        ),

      ],
    );
  }
}

class ImageButtonsRow3 extends StatelessWidget {

  String adminName;
  ImageButtonsRow3({required this.adminName, required String uid});

  bool isguard=false;


  Future<void> isGuard() async{
    if(adminName=="guard"){
      isguard=true;
    }
    else{
      isguard=false;
    }
  }

  @override
  Widget build(BuildContext context) {
    isGuard();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ImageButtonWithText(
          image: AssetImage("images/register.png"),
          text: "Users Account",
          width: 80,
          height: 80,
          onPressed: () {
            print("ISGUARD? = ${isguard}");
            print("ADMINNAME? = ${adminName}");
            !isguard?
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => UsersAccountPage()),
            )
                :ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('You are not allowed to access'),
              ),
            );
          },
        ),


        ImageButtonWithText(
          image: AssetImage("images/camera.jpg"),
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