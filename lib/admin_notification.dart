import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(AdminNotificationApp());
}


class AdminNotificationApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AdminNotificationPage(), // Change the page
    );
  }
}

class AdminNotificationPage extends StatefulWidget {
  @override
  _AdminNotificationPageState createState() => _AdminNotificationPageState();
}

class _AdminNotificationPageState extends State<AdminNotificationPage> { // Rename the class
  List<NotificationItem> notifications = [];

  TextEditingController titleController = TextEditingController();
  TextEditingController detailsController = TextEditingController();

  void _addNotification() async {
    // Fetch the user's name from Firebase based on user ID (replace 'userId' with the actual user ID)
    DocumentSnapshot userSnapshot = await FirebaseFirestore.instance.collection('users').doc('userId').get();
    String userName = userSnapshot.get('name');

    setState(() {
      String title = titleController.text;
      String details = detailsController.text;
      DateTime now = DateTime.now();
      String timestamp =
          '${now.day}/${now.month}/${now.year} ${now.hour}:${now.minute}:${now.second}';
      notifications.add(NotificationItem(
        title: title,
        details: details,
        timestamp: timestamp,
        senderName: userName, // Add sender's name to the NotificationItem
      ));
      titleController.clear();
      detailsController.clear();
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Notification Page'), // Change the title
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(notifications[index].title),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(notifications[index].details),
                      Text(
                        'Timestamp: ${notifications[index].timestamp}',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(labelText: 'Notification Title'), // Change the label
                ),
                SizedBox(height: 12),
                TextField(
                  controller: detailsController,
                  decoration: InputDecoration(labelText: 'Notification Details'), // Change the label
                ),
                SizedBox(height: 12),
                ElevatedButton(
                  onPressed: _addNotification,
                  child: Text('Add Notification'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class NotificationItem {
  final String title;
  final String details;
  final String timestamp;

  NotificationItem({
    required this.title,
    required this.details,
    required this.timestamp, required String senderName,
  });
}
