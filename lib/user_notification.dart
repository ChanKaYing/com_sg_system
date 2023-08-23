import 'package:flutter/material.dart';

void main() {
  runApp(UserNotificationApp());
}

class UserNotificationApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: UserNotificationPage(),
    );
  }
}

class UserNotificationPage extends StatefulWidget {
  @override
  _UserNotificationPageState createState() => _UserNotificationPageState();
}

class _UserNotificationPageState extends State<UserNotificationPage> {
  List<NotificationItem> notifications = [];

  TextEditingController titleController = TextEditingController();
  TextEditingController detailsController = TextEditingController();

  void _addNotification() {
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
      ));
      titleController.clear();
      detailsController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notification Page'),
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
                  decoration: InputDecoration(labelText: 'Title'),
                ),
                SizedBox(height: 12),
                TextField(
                  controller: detailsController,
                  decoration: InputDecoration(labelText: 'Details'),
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
    required this.timestamp,
  });
}
