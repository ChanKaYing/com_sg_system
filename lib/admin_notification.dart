import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(AdminNotificationApp());
}

class AdminNotificationApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasData) {
            User? currentUser = snapshot.data as User?;
            String adminName = currentUser != null ? currentUser.displayName ?? 'Unknown' : 'Unknown';
            return AdminNotificationPage(adminName: adminName);
          } else {
            return SignInPage();
          }
        },
      ),
    );
  }
}

class SignInPage extends StatelessWidget {
  Future<void> _signIn() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInAnonymously();
      User? user = userCredential.user;
      if (user != null) {
        print('Signed in anonymously with UID: ${user.uid}');
      }
    } catch (e) {
      print('Error signing in: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sign In')),
      body: Center(
        child: ElevatedButton(
          onPressed: _signIn,
          child: Text('Sign In Anonymously'),
        ),
      ),
    );
  }
}

class AdminNotificationPage extends StatefulWidget {
  final String adminName;

  AdminNotificationPage({required this.adminName});

  @override
  _AdminNotificationPageState createState() => _AdminNotificationPageState();
}

class _AdminNotificationPageState extends State<AdminNotificationPage> {
  List<NotificationItem> notifications = [];
  TextEditingController titleController = TextEditingController();
  TextEditingController detailsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _startListeningToNotifications();
  }

  void _startListeningToNotifications() {
    FirebaseFirestore.instance
        .collection('notifications')
        .orderBy('timestamp') // Order by timestamp in ascending order
        .snapshots()
        .listen((snapshot) {
      setState(() {
        notifications = snapshot.docs.map((doc) => NotificationItem(
          title: doc['title'],
          details: doc['details'],
          timestamp: doc['timestamp'],
          senderName: doc['senderName'],
        )).toList();
      });
    });
  }

  void _addNotification() async {
    String title = titleController.text;
    String details = detailsController.text;
    DateTime now = DateTime.now();
    String timestamp =
        '${now.day}/${now.month}/${now.year} ${now.hour}:${now.minute}:${now.second}';

    String senderName = widget.adminName;

    await FirebaseFirestore.instance.collection('notifications').add({
      'title': title,
      'details': details,
      'timestamp': timestamp,
      'senderName': senderName,
    });

    titleController.clear();
    detailsController.clear();

    // Show alert dialog after adding notification
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Notification Added'),
          content: Text('The notification has been successfully added.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Notification Page'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Admin: ${widget.adminName}'),
          ),
        ],
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
                      Text(
                        'Sender: ${notifications[index].senderName}',
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
                  decoration: InputDecoration(labelText: 'Notification Title'),
                ),
                SizedBox(height: 12),
                TextField(
                  controller: detailsController,
                  decoration: InputDecoration(labelText: 'Notification Details'),
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
  final String senderName;

  NotificationItem({
    required this.title,
    required this.details,
    required this.timestamp,
    required this.senderName,
  });
}
