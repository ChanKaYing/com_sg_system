import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:com_sg_system/admin_main.dart';
import 'package:com_sg_system/admin_payment.dart';
import 'package:com_sg_system/facility.dart';
import 'package:com_sg_system/user_facility.dart';
import 'package:com_sg_system/user_familydetail.dart';
import 'package:com_sg_system/login_page.dart';
import 'package:com_sg_system/user_payment.dart';
import 'package:com_sg_system/user_profile.dart';
import 'package:com_sg_system/user_notification.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:com_sg_system/user_pubspace.dart';

import 'user_appoint_car.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Main Page',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}

class UserMainPage extends StatelessWidget {

  int uid;
  UserMainPage({required this.uid});
  String notiText = "";
  late Timer _timer;
  //uid: uid?.toString() ?? ''


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome, $uid'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Navigator.pop(
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
                  MaterialPageRoute(builder: (context) => UserNotificationPage()),
                );
              },
            ),
            ListTile(
              title: Text('Pre-Register'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UserAppointmentPage(uid: uid?.toString() ?? '')),
                );
              },
            ),
            ListTile(
              title: Text('Facility'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FacilityAppointmentPage(uid: uid?.toString() ?? '')),
                );
              },
            ),
            ListTile(
              title: Text('Public Space'),
              onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => PubSpaceAppointmentPage(uid: uid?.toString() ?? ''),),
                        );
              },
            ),
            ListTile(
              title: Text('Payment Detail'),
              onTap: () {
                print(uid); // Make sure uid is defined
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PaymentDetailsPage(uid: uid?.toString() ?? ''),
                  ),
                );
              },
            ),

            ListTile(
              title: Text('Family Detail'),
              onTap: () {
                print(uid); // Make sure uid is defined
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FamilyDetailPage(uid: uid?.toString() ?? ''), // Convert int? to String
                  ),
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
                    MaterialPageRoute(builder: (context) => UserProfilePage(uid: uid?.toString() ?? '')),
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
                  Text(notiText,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14),
                  ),
                  SizedBox(height: 10), // Adding some spacing between the two Text widgets
                  TextButton(
                    onPressed: () {
                      // Navigate to another page here
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => UserNotificationPage()),
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
            ImageButtonsRow1(uid: uid),

            SizedBox(height: 20),

            Text(
              'About Resident',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            ImageButtonsRow2(uid: uid),
            SizedBox(height: 8),
          ],
        ),
      ),


      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        child: Icon(Icons.sos_outlined, color: Colors.white,),
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context){
              return AlertDialog(
                title: Text('Emergency Button'),
                content: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        IconButton(
                          icon: Icon(Icons.local_fire_department, size: 70,),
                          onPressed: () {
                            ////////////////////////////////////////////////////////////////
                            Navigator.of(context).pop();
                            _emergency(uid.toString(),'Fire');
                          },
                        ),
                        SizedBox(width: 70,),
                        IconButton(
                          icon: Icon(Icons.pool_rounded,size: 70,),
                          onPressed: () {
                            ////////////////////////////////////////////////////////////////
                            Navigator.of(context).pop();
                            _emergency(uid.toString(),'Drowning');
                          },
                        ),
                        SizedBox(height: 16.0),
                      ]),

                      SizedBox(height: 70,),

                      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        IconButton(
                          icon: Icon(Icons.local_fire_department,  size: 70,),
                          onPressed: () {
                            ////////////////////////////////////////////////////////////////
                            Navigator.of(context).pop();
                            _emergency(uid.toString(),'Thief');
                          },
                        ),
                        SizedBox(width: 70,),
                        IconButton(
                          icon: Icon(Icons.help_rounded,  size: 70,),
                          onPressed: () {
                            ////////////////////////////////////////////////////////////////
                            Navigator.of(context).pop();
                            _emergency(uid.toString(),'Other');
                          },
                        ),
                        SizedBox(height: 30.0),

                      ]),

                    ],
                  ),
                ),
              );
            },
          );
        },
      ),

    );
  }

  void _emergency(String ID, String type) {
    FirebaseFirestore.instance
        .collection('emergency')
        .add({
      'ID':ID,
      'emergencyType': type,
    });

  }


}


class CardWidget extends StatefulWidget {
  @override
  _CardWidgetState createState() => _CardWidgetState();
}

class _CardWidgetState extends State<CardWidget> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  int _currentIndex = 0;
  String notiText="";
  List<String> notiList=['Welcome Back'];//////////////////////////////////////////////////////////////////////////////bug
  int _notiIndex = 0;

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

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 3), _swapImage);
    _timer2 = Timer.periodic(Duration(seconds: 5), getNotiList);
    _timer3 = Timer.periodic(Duration(seconds: 2), changeNotiText);
    _timer4 = Timer.periodic(Duration(seconds: 60), refreshCarRegister);
  }

  void _swapImage(Timer timer) {
    setState(() {
      _currentIndex = (_currentIndex + 1) % _imagePaths.length;
    });
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
                                      MaterialPageRoute(builder: (context) => UserNotificationPage()),
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
        )////////////
    );
  }
}

class ImageButtonsRow1 extends StatelessWidget {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  int uid;
  bool paid=false;
  ImageButtonsRow1({required this.uid});

  Future<void> isPaid() async{
    QuerySnapshot querySnapshot = await _firestore.collection('users').get();
    for(var doc in querySnapshot.docs){
      if(doc.id== uid.toString() && doc['member']=="1"){
        paid=true;
        print("True");
        break;
      }
      else{
        print("False");
        paid=false;
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    isPaid();
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
              MaterialPageRoute(builder: (context) => UserAppointmentPage(uid: uid?.toString() ?? '')),
            );
          },
        ),
        ImageButtonWithText(
          image: AssetImage("images/facility.png"),
          text: "Facility",
          width: 80,
          height: 90,
          onPressed: () {
            print("Paid= ${paid}");
            paid?
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => FacilityAppointmentPage(uid: uid?.toString() ?? '')),
            )
                :ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('You are not allowed to make appointment. You are not member'),
              ),
            );
          },
        ),
        ImageButtonWithText(
          image: AssetImage("images/publicspace.png"),
          text: "Public Space",
          width: 90,
          height: 90,
          onPressed: () {
            print("Paid= ${paid}");
            paid?
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PubSpaceAppointmentPage(uid: uid?.toString() ?? '')),
                  )
            :ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('You are not allowed to make appointment. You are not member'),
            ),
            );
          },
        ),
      ],
    );
  }
}

class ImageButtonsRow2 extends StatelessWidget {

  int uid;
  ImageButtonsRow2({required this.uid});

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
              MaterialPageRoute(builder: (context) => UserPaymentDetailsPage(uid: uid?.toString() ?? '')),
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
                builder: (context) => FamilyDetailPage(uid: uid?.toString() ?? ''), // Convert int? to String
              ),
            );
          },
        ),
        SizedBox(height: 16,)


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