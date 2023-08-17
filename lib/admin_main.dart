import 'package:com_sg_system/Appointment.dart';
import 'package:com_sg_system/admin_notification.dart';
import 'package:com_sg_system/register_page.dart';
import 'package:flutter/material.dart';

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
      home: AdminMainPage(),
    );
  }
}

class AdminMainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Main Page'),
      ),
      drawer: Drawer( // Add a Drawer
        child: ListView(
          children: [
            DrawerHeader(
              child: Text('Navigation'), // Customize your drawer header
            ),
            ListTile(
              title: Text('Main Page'),
              onTap: () {
                // Navigate to screen
              },
            ),
            ListTile(
              title: Text('Notification'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NotificationPage()),
                );
                // Navigate to screen
              },
            ),
            ListTile(
              title: Text('Pre-Register'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AppointmentPage()),
                );
                // Navigate to screen
              },
            ),
            ListTile(
              title: Text('Facility'),
              onTap: () {
                // Navigate to screen
              },
            ),
            ListTile(
              title: Text('Public Space'),
              onTap: () {
                // Navigate to screen
              },
            ),
            ListTile(
              title: Text('Payment Detail'),
              onTap: () {
                // Navigate to screen
              },
            ),
            ListTile(
              title: Text('Card'),
              onTap: () {
                // Navigate to screen
              },
            ),
            ListTile(
              title: Text('Family Detail'),
              onTap: () {
                // Navigate to screen
              },
            ),

            ListTile(
              title: Text('Register'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterPage()),
                );
                // Navigate to screen
              },
            ),
            ListTile(
              title: Text('Visitor Data'),
              onTap: () {
                // Navigate to screen
              },
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
                    'Notification: Your community maintenance fee is due, please pay it before September 1st',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14),
                  ),
                  SizedBox(height: 10), // Adding some spacing between the two Text widgets
                  Text(
                    'Click for more',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black54),
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
            ImageButtonsRow2(),
            SizedBox(height: 8),

            Text(
              'For Admin Only',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            ImageButtonsRow3(),
            SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}



class CardWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Community or Apartment Name',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Image.asset(
                    "images/pool.png", // Replace with your image path
                    width: 250, // Adjust the width as needed
                    height: 250, // Adjust the height as needed
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ImageButtonsRow1 extends StatelessWidget {
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
            // Handle pre-register button click
            // You can add your logic here
          },
        ),
        ImageButtonWithText(
          image: AssetImage("images/facility.png"),
          text: "Facility",
          width: 80,
          height: 90,
          onPressed: () {
            // Handle facility button click
            // You can add your logic here
          },
        ),
        ImageButtonWithText(
          image: AssetImage("images/publicspace.png"),
          text: "Public Space",
          width: 95,
          height: 95,
          onPressed: () {
            // Handle public space button click
            // You can add your logic here
          },
        ),
      ],
    );
  }
}

class ImageButtonsRow2 extends StatelessWidget {
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
            // Handle payment button click
            // You can add your logic here
          },
        ),
        ImageButtonWithText(
          image: AssetImage("images/card.png"),
          text: "Card",
          width: 80,
          height: 80,
          onPressed: () {
            // Handle card button click
            // You can add your logic here
          },
        ),
        ImageButtonWithText(
          image: AssetImage("images/family.png"),
          text: "Family",
          width: 80,
          height: 80,
          onPressed: () {
            // Handle family button click
            // You can add your logic here
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
          text: "Register",
          width: 80,
          height: 80,
          onPressed: () {
            // Handle payment button click
            // You can add your logic here
          },
        ),
        ImageButtonWithText(
          image: AssetImage("images/visitor.png"),
          text: "Card",
          width: 80,
          height: 80,
          onPressed: () {
            // Handle card button click
            // You can add your logic here
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