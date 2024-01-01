import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EmergencyDetail extends StatelessWidget {

  String _formatDate(DateTime date) {
    return '${date.year}-${_twoDigits(date.month)}-${_twoDigits(date.day)}';
  }

  String _formatTime(TimeOfDay time) {
    return '${_twoDigits(time.hour)}:${_twoDigits(time.minute)}';
  }

  String _twoDigits(int n) {
    if (n >= 10) {
      return '$n';
    }
    return '0$n';
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('emergency').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        return Container(
          height: 300,
          child: ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data = document.data() as Map<String, dynamic>;

              void _deleteData() async {
                await FirebaseFirestore.instance
                    .collection('emergency')
                    .doc(document.id)
                    .delete();
              }

              void _editData() {
                TextEditingController nameController =
                TextEditingController(text: data['name']);
                TextEditingController plateController =
                TextEditingController(text: data['plate']);
                DateTime selectedDate = DateTime.parse(data['checkindate']);
                TimeOfDay selectedTime = TimeOfDay(
                  hour: int.parse(data['checkintime'].split(':')[0]),
                  minute: int.parse(data['checkintime'].split(':')[1]),
                );
              }

              return Card(
                margin: EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(
                      'ID: ${data['ID']}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Emergency Type: ${data['emergencyType']}'),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          _deleteData(); // Call the delete function when delete icon is pressed
                        },
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
