import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminAppointPubSpace extends StatelessWidget {

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

    return Scaffold(
      appBar: AppBar(
        title: Text('Register Public Space by Resident'),


      ),
      body: StreamBuilder(


        stream: FirebaseFirestore.instance.collection('pubspace').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return Container(

            child: ListView(
              children: snapshot.data!.docs.map((document)
              {
                Map<String, dynamic> data =
                document.data() as Map<String, dynamic>;

                void _deleteData() async {
                  await FirebaseFirestore.instance
                      .collection('pubspace')
                      .doc(document.id)
                      .delete();
                }

                void _editData() {
                  TextEditingController nameController = TextEditingController(text: data['name']);
                  TextEditingController reasonController = TextEditingController(text: data['reason']);
                  DateTime selectedDate = DateTime.parse(data['checkindate']);
                  TimeOfDay selectedTime = TimeOfDay(
                    hour: int.parse(data['checkintime'].split(':')[0]),
                    minute: int.parse(data['checkintime'].split(':')[1]),
                  );}

                return Card(
                  margin: EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text('Name: ${data['name']}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Day: ${_formatDate(DateTime.parse(data['checkindate']))} '),
                        Text('Reason: ${data['reason']}'),
                        Text('UID: ${data['uid']}'),
                      ],
                    ),

                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [

                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            // Call the delete function when delete icon is pressed
                            _deleteData();
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
      ),
    );
  }
}




